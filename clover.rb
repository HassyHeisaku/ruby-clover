#!/usr/bin/ruby
$LOAD_PATH.push('./lib')
$LOAD_PATH.push('./plugins/template_rule')
$LOAD_PATH.push('./plugins/model_rule')
$LOAD_PATH.push('./plugins/lib')

require 'changelog_model'
require 'model_processor'
require 'shortcode_processor'
require 'template_processor'

config_filename = File.dirname(__FILE__) + '/config.yaml'
changelog = ChangelogModel.new(config_filename)
%x(rm -r #{changelog.config[:output_dir]})
%x(mkdir #{changelog.config[:output_dir]})
%x(mkdir #{changelog.config[:output_dir]+ 'css'})
%x(mkdir #{changelog.config[:output_dir]+ 'javascript'})
%x(mkdir #{changelog.config[:output_dir]+ 'images'})
model_processor = ModelProcessor.new(changelog)
model_processor.process
shortcode_processor = ShortcodeProcessor.new(changelog)
shortcode_processor.process
template_processor = TemplateProcessor.new(changelog)
template_processor.process
%x(cp #{changelog.config[:theme][:dir] + changelog.config[:theme][:css_path] + '*'} #{changelog.config[:output_dir]+ 'css/'})
%x(cp #{changelog.config[:custom_theme][:dir] + changelog.config[:custom_theme][:css_path] + '*'} #{changelog.config[:output_dir]+ 'css/'})
%x(cp #{changelog.config[:theme][:dir] + changelog.config[:theme][:javascript_path] + '*'} #{changelog.config[:output_dir]+ 'javascript/'})
%x(cp #{changelog.config[:custom_theme][:dir] + changelog.config[:custom_theme][:javascript_path] + '*'} #{changelog.config[:output_dir]+ 'javascript/'})
%x(cp #{changelog.config[:theme][:dir] + changelog.config[:theme][:images_path] + '*'} #{changelog.config[:output_dir]+ 'images/'})
%x(cp -r #{changelog.config[:static][:dir] + '*'} #{changelog.config[:output_dir]})
