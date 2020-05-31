# -*- coding: utf-8 -*-

require 'pp'
require 'plugin_loader'
require 'shortcode_plugin'

class ShortcodeProcessor
  def initialize(changelog)
    @changelog = changelog
    ShortcodePlugin.set_changelog(@changelog)
    @ploader = PluginLoader.new(@changelog.config[:shortcode_plugin_dir])
  end
  def process
    @ploader.plugins.each_value do |p|
      p.process
    end
  end
end


