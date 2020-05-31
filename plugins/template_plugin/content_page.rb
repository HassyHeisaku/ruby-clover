# -*- coding: utf-8 -*-

require 'erb'
require 'template_plugin'
require 'pp'

class ContentPage < TemplatePlugin
  def initialize
    super('content_page/content.erb')
  end
  def process
    @changelog = @@changelog.dup
    @changelog.contents.each do |content| 
      File.open(content[:output_name], 'w', :encoding => 'utf-8') do |f|
        f.puts @erb.result(binding)
      end
      puts "processed! #{content[:output_name]}"
    end
  end
end
