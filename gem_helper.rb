#!/usr/bin/env ruby
#  gem_helper.rb
#  goo
#
#  Created by Robin Lu on 8/21/08.
#  Copyright (c) 2008 __MyCompanyName__. All rights reserved.
#
require 'rubygems'
require 'rubygems/doc_manager'
require 'erb'
require 'cgi'

module GemHelper
  TEMPLATE = <<-EOF
  <?xml version="1.0" encoding="UTF-8"?>
  <!DOCTYPE plist SYSTEM "file://localhost/System/Library/DTDs/PropertyList.dtd">
  <plist version="1.0">
  <array>
    <% source_index.each {|path, spec| %>
      <dict>
        <key>authors</key>
        <string><%= h spec.authors.sort.join(", ") %></string>
		<key>path</key>
		<string><%= h spec.full_gem_path %></string>
        <key>date</key>
        <date><%= h spec.date.strftime('%Y-%m-%dT%H:%M:%SZ') %></date>
        <key>doc_path</key>
        <string><%= File.join Gem.dir, 'doc', spec.full_name, 'rdoc' %></string>
        <key>full_name</key>
        <string><%= h spec.full_name %></string>
        <key>homepage</key>
        <string><%= h spec.homepage %></string>
        <key>name</key>
        <string><%= h spec.name %></string>
        <key>rdoc_installed</key>
        <<%= Gem::DocManager.new(spec).rdoc_installed? %>/>
        <key>summary</key>
        <string><%= h spec.summary %></string>
        <key>version</key>
        <string><%= spec.version.to_s %></string>
      </dict>
    <% } %>
  </array>
  </plist>
  EOF
  def self.specs
    spec_dir = File.join Gem.dir, 'specifications'
    source_index = Gem::SourceIndex.from_gems_in spec_dir
    template = ERB.new TEMPLATE
    puts template.result(binding)
  end

  def self.h(str)
    unless str
      ''
    else
      CGI::escapeHTML str
    end
  end
  
end

GemHelper::specs