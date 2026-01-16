#!/usr/bin/env ruby
require 'xcodeproj'

project_path = 'vocab-builder.xcodeproj'
project = Xcodeproj::Project.open(project_path)

# Get the main app target
main_target = project.targets.find { |t| t.name == 'vocab-builder' }
raise "Main target not found" unless main_target

# Check if widget target already exists
if project.targets.find { |t| t.name == 'VocabWidgetExtension' }
  puts "Widget target already exists!"
  exit 0
end

# Get main target's bundle identifier base
main_bundle_id = main_target.build_configurations.first.build_settings['PRODUCT_BUNDLE_IDENTIFIER'] || 'com.michaelzhao.vocab-builder'
widget_bundle_id = "#{main_bundle_id}.VocabWidget"

# Create widget extension target
widget_target = project.new_target(
  :app_extension,
  'VocabWidgetExtension',
  :ios,
  '17.0'
)

# Set build settings for widget target
widget_target.build_configurations.each do |config|
  config.build_settings['PRODUCT_BUNDLE_IDENTIFIER'] = widget_bundle_id
  config.build_settings['INFOPLIST_FILE'] = 'VocabWidget/Info.plist'
  config.build_settings['CODE_SIGN_STYLE'] = 'Automatic'
  config.build_settings['CURRENT_PROJECT_VERSION'] = '1'
  config.build_settings['GENERATE_INFOPLIST_FILE'] = 'YES'
  config.build_settings['MARKETING_VERSION'] = '1.0'
  config.build_settings['PRODUCT_NAME'] = '$(TARGET_NAME)'
  config.build_settings['SWIFT_EMIT_LOC_STRINGS'] = 'YES'
  config.build_settings['SWIFT_VERSION'] = '5.0'
  config.build_settings['TARGETED_DEVICE_FAMILY'] = '1,2'
  config.build_settings['INFOPLIST_KEY_CFBundleDisplayName'] = 'VocabWidget'
  config.build_settings['INFOPLIST_KEY_NSHumanReadableCopyright'] = ''
  config.build_settings['LD_RUNPATH_SEARCH_PATHS'] = '$(inherited) @executable_path/Frameworks @executable_path/../../Frameworks'
  config.build_settings['SKIP_INSTALL'] = 'YES'
  config.build_settings['ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME'] = 'AccentColor'
  config.build_settings['ASSETCATALOG_COMPILER_WIDGET_BACKGROUND_COLOR_NAME'] = 'WidgetBackground'
end

# Create VocabWidget group if it doesn't exist
widget_group = project.main_group.find_subpath('VocabWidget', true)
widget_group.set_source_tree('<group>')
widget_group.set_path('VocabWidget')

# Add VocabWidget.swift to widget target
widget_swift_path = 'VocabWidget/VocabWidget.swift'
if File.exist?(widget_swift_path)
  widget_file_ref = widget_group.new_file(widget_swift_path)
  widget_target.add_file_references([widget_file_ref])
  puts "Added VocabWidget.swift to widget target"
end

# Find VocabularyData.swift and add to widget target as well
vocab_data_ref = nil
project.main_group.recursive_children.each do |child|
  if child.is_a?(Xcodeproj::Project::Object::PBXFileReference) && child.path&.include?('VocabularyData.swift')
    vocab_data_ref = child
    break
  end
end

if vocab_data_ref
  # Add to widget target's compile sources
  widget_target.source_build_phase.add_file_reference(vocab_data_ref)
  puts "Added VocabularyData.swift to widget target"
else
  puts "Warning: VocabularyData.swift not found in project"
end

# Add widget extension to main app's dependencies
main_target.add_dependency(widget_target)

# Create embed extension build phase
embed_phase = main_target.new_copy_files_build_phase('Embed Foundation Extensions')
embed_phase.dst_subfolder_spec = '13' # PlugIns folder
embed_phase.add_file_reference(widget_target.product_reference)

# Set the embed phase file settings
embed_phase.files.each do |file|
  file.settings = { 'ATTRIBUTES' => ['RemoveHeadersOnCopy'] }
end

# Add WidgetKit framework to widget target
widget_target.add_system_framework('WidgetKit')
widget_target.add_system_framework('SwiftUI')

# Save the project
project.save

puts "Successfully added VocabWidgetExtension target!"
puts "Now open Xcode and build the project."
