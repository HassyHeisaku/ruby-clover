# -*- coding: utf-8 -*-

require 'pp'
require 'plugin_loader'
require 'template_plugin'

class TemplateProcessor
  def initialize(changelog)
    @changelog = changelog
    TemplatePlugin.set_changelog(@changelog)
    @ploader = PluginLoader.new(@changelog.config[:template_plugin_dir])
  end
  def process
    @ploader.plugins.each_value do |p|
      p.process
    end
  end
end


