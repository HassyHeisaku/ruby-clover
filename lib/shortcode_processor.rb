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
      c[:contents].gsub!(/(?<!\\)%%([^%\n]+)%%/){@ploader.plugins[$1.split(' ')[0]].process($1,c)} if(c[:contents][/(?<!\\)%%([^%\n]+)%%/,1])
      c[:contents].gsub!(/\\%%/,"%%")
    end
  end
end


