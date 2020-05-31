# -*- coding: utf-8 -*-

require 'pp'
require 'plugin_loader'
require 'model_plugin'

class ModelProcessor
  def initialize(changelog)
    @changelog = changelog
    ModelPlugin.set_changelog(@changelog)
    @ploader = PluginLoader.new(@changelog.config[:model_plugin_dir])
  end
  def process
    final_func = @ploader.plugins.delete("Markdown2Html")
    @ploader.plugins.each_value do |p|
      p.process
    end
    final_func.process
  end
end


