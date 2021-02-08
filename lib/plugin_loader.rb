# -*- coding: utf-8 -*-

class PluginLoader
  attr_reader :plugins
  def initialize(plugin_base, prefix = nil)
    @plugin_base = plugin_base
    @plugins = {}
    Dir.glob(@plugin_base + "#{prefix}*.rb").each do |p|
      require p
      name = to_classname(p)
      @plugins[name] = Object.const_get(name).new
    end
  end
  def add(plugin_base, prefix = nil)
    @plugin_base = plugin_base
    Dir.glob(@plugin_base + "#{prefix}*.rb").each do |p|
      require p
      name = to_classname(p)
      @plugins[name] = Object.const_get(name).new
    end
  end
  private
  def to_classname(str)
    str.sub(/^#{@plugin_base}/){""}.sub(/\.rb$/){""}.gsub(/\/(.?)/) { "::" + $1.upcase }.gsub(/(^|_)(.)/) { $2.upcase }
  end
end

