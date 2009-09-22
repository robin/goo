require "builder"
require "osx/cocoa"
require "active_support"
require "RedCloth"

set :build_type, "Release"
set :build_path, '/Users/splyb/Projects/xcode.build'
set :info_plist_path, 'Info.plist'
set :app_name, 'goo'
set :base_url , "http://www.robinlu.com/goo"
set :release_notes, "release_notes.html"
set :private_key, "dsa_priv.pem"
set :release_notes_template, "release_notes_template.html.erb"
set :upload_path, "/var/www/vhosts/robinlu.com/htdocs/goo"

role :file_store, 'www.robinlu.com'

def local_run(cmd)
  puts "** local run: #{cmd}"
  `#{cmd}`
end

def info_plist
  @info_plist ||= OSX::NSDictionary.dictionaryWithContentsOfFile(File.expand_path(info_plist_path)) || {}
end

def app_version
  @app_version ||= info_plist['CFBundleVersion']
end

def appcast_filename
  url = info_plist['SUFeedURL'].to_s
  url.split('/').last
end

def pkg_name
  "#{app_name}-#{app_version}.zip"
end

def pkg
  "#{build_path}/#{build_type}/#{pkg_name}"
end

def dsa_signature
  @dsa_signature ||= `openssl dgst -sha1 -binary < "#{pkg}" | openssl dgst -dss1 -sign "#{private_key}" | openssl enc -base64`
end

def make_appcast
  FileUtils.mkdir_p "#{build_path}"
  appcast = File.open("#{build_path}/#{appcast_filename}", 'w') do |f|
    xml = Builder::XmlMarkup.new(:indent => 2)
    xml.instruct!
    xml_string = xml.rss('xmlns:atom' => "http://www.w3.org/2005/Atom",
            'xmlns:sparkle' => "http://www.andymatuschak.org/xml-namespaces/sparkle", 
            :version => "2.0") do
      xml.channel do
        xml.title(app_name)
        xml.description("#{app_name} updates")
        xml.link(base_url)
        xml.language('en')
        xml.pubDate Time.now.to_s(:rfc822)
        # xml.lastBuildDate(Time.now.rfc822)
        xml.atom(:link, :href => "#{base_url}/#{appcast_filename}", 
                 :rel => "self", :type => "application/rss+xml")

        xml.item do
          xml.title("#{app_name} #{app_version}")
          xml.tag! "sparkle:releaseNotesLink", "#{base_url}/#{release_notes}"
          xml.pubDate Time.now.to_s(:rfc822) #(File.mtime(pkg))
          xml.guid("#{app_name}-#{app_version}", :isPermaLink => "false")
          xml.enclosure(:url => "#{base_url}/#{pkg_name}", 
                        :length => "#{File.size(pkg)}", 
                        :type => "application/zip",
                        :"sparkle:version" => app_version,
                        :"sparkle:dsaSignature" => dsa_signature)
        end
      end
    end
    f << xml_string
  end
end

def release_notes_html
  RedCloth.new(release_notes_content).to_html
end

def make_release_notes
  File.open("#{build_path}/#{release_notes}", "w") do |f|
    template = File.read(release_notes_template)
    f << ERB.new(template).result(binding)
  end
end

def release_notes_content
  if File.exists?("release_notes.txt")
    File.read("release_notes.txt")
  else
    <<-TEXTILE.gsub(/^      /, '')
    h1. #{version} #{Date.today}
    
    h2. Another awesome release!
    TEXTILE
  end
end

def upload_files
  [pkg, "#{build_path}/#{release_notes}", "#{build_path}/#{appcast_filename}"].each {|file|
    upload file, upload_path, :roles => 'file_store', :via => :scp
  }
end

def append_git_version
  # Change this if your path isn’t here
  common_git_paths = %w[/usr/local/bin/git /usr/local/git/bin/git /opt/local/bin/git]
  git_path = ""

  common_git_paths.each do |p|
    if File.exist?(p)
      git_path = p
      break
    end
  end

  if git_path == ""
    puts "Path to git not found"
    exit
  end

  command_line = git_path + " rev-parse --short HEAD"
  sha = `#{command_line}`.chomp

  info_file = "#{build_path}/#{build_type}/#{app_name}.app/Contents/#{File.basename info_plist_path}"

  f = File.open(info_file, "r").read
  re = /([\t ]+<key>CFBundleVersion<\/key>\n[\t ]+<string>)(.*?)(<\/string>)/
  f =~ re

  # Get the version info from the source Info.plist file
  # If the script has already been run we need to remove the git sha
  # from the bundle’s Info.plist.
  version = $2.sub(/ \([\w]+\)/, "")

  # Inject the git has into the bundle’s Info.plist
  sub = "\\1#{version} (#{sha})\\3"
  f.gsub!(re, sub)
  File.open(info_file, "w") { |file| file.write(f) }
end

namespace :xcode do
  desc 'default'
  task :default do
    build
    package
    feed
    upload
  end
  
  desc "build xcode project"
  task :build do
    local_run "xcodebuild -configuration #{build_type}"
    #append_git_version
  end
  
  desc "package"
  task :package do
    local_run "cd #{build_path}/#{build_type} && ditto -ck --rsrc --keepParent #{app_name}.app #{pkg_name}"
  end
  
  desc "feed"
  task :feed do
    make_appcast
    make_release_notes
  end
  
  desc "upload"
  task :upload do
    upload_files
  end
end