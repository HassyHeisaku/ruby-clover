# -*- coding: utf-8 -*-

require 'erb'
require 'fileutils'
require 'pp'

class TemplatePlugin
  include ERB::Util
  @@changelog = nil
  def render(filename, content = {})
    ERB.new(File.read(custom_or_pub(filename), :encoding => 'utf-8'), nil, '-').result(binding)
  end
  def render_this(template_string, content = {})
    ERB.new(template_string, nil, '-').result(binding)
  end
  def initialize(filename)
    @erb = ERB.new(File.read(custom_or_pub(filename), :encoding => 'utf-8'), nil, '-') if(filename)
  end
  def self.set_changelog(changelog)
    @@changelog = changelog
    @@changelog.contents.each do |c|
      FileUtils.mkdir_p(File.dirname(c[:output_name]))
    end
  end
  def custom_or_pub(filename)
    if(File.exists?(@@changelog.config[:custom_theme][:dir] + @@changelog.config[:custom_theme][:template_path] + filename))
      fname = @@changelog.config[:custom_theme][:dir] + @@changelog.config[:custom_theme][:template_path] + filename
      return fname
    else
      fname = @@changelog.config[:theme][:dir] + @@changelog.config[:theme][:template_path] + filename
      return fname
    end
  end
  def process
   ''
  end
end
