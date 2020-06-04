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
    @changelog.contents.each do |c|
      c[:contents].gsub!(/%%([^%]+)%%/){@ploader.plugins[$1.split(' ')[0]].process($1.split(' '))} if(c[:contents][/%%([^%]+)%%/,1])
    end
  end
end


