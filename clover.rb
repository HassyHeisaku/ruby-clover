#!/usr/bin/ruby
$LOAD_PATH.push('./lib')
$LOAD_PATH.push('./plugins/template_rule')
$LOAD_PATH.push('./plugins/model_rule')
$LOAD_PATH.push('./plugins/lib')

require 'changelog_model'
require 'dir_constructor'
require 'model_processor'
require 'shortcode_processor'
require 'template_processor'
require 'pp'

config_filename = File.dirname(__FILE__) + '/config.yaml'
changelog = ChangelogModel.new(config_filename)
dirconstructor = DirConstructor.new(changelog.config)
dirconstructor.remove_and_recreate_out_dir()

model_processor = ModelProcessor.new(changelog)
model_processor.process
shortcode_processor = ShortcodeProcessor.new(changelog)
shortcode_processor.process
template_processor = TemplateProcessor.new(changelog)
template_processor.process

dirconstructor.cp_static_files(:theme)
dirconstructor.cp_static_files(:custom_theme)
dirconstructor.cp_static_files(:static)
