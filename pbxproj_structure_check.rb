#
#  pbxproj_structure_check.rb
#  v.1.0.1
#
#  Copyright (c) 2014 Kamil Borzym
#  Released under the MIT License
#

require 'rubygems'
require 'json'

class PbxStructure

  attr_accessor :ignored_ids

  def initialize(pbx_tree)
    @pbx_tree = pbx_tree
    @pbx_objects = pbx_tree["objects"]
  end
  
  def check_object(object_id, object_location)
    if (not @ignored_ids.nil?) and (@ignored_ids.include?(object_id))
      return
    end
    object = @pbx_objects[object_id]
    
    if object_location.empty?
      object_description = "Object '#{object_id}' named '#{object["name"]}' at '/'"
    else 
      object_description = "Object '#{object_id}' named '#{object["name"]}' at '#{object_location}'"
    end
    
    if not object["sourceTree"].eql?("<group>")
      abort "#{object_description} is not relative to <group> but to #{object["sourceTree"]}"
    end
    if object["path"].nil?
      abort "#{object_description} has no physical path"
    end
    if (not object["name"].nil?) and (not object["name"].eql?(object["path"]))
      abort "#{object_description} has name '#{object["name"]}' different from its real path '#{object["path"]}'"
    end
  
    children_location = "#{object_location}/#{object["path"]}"
    if not object["children"].nil?
      object["children"].each do |child_id|
        check_object(child_id, children_location)
      end 
    end
  end
  
  def check
    root_object = @pbx_objects[@pbx_tree["rootObject"]]
    main_group = @pbx_objects[root_object["mainGroup"]]
  
    main_group["children"].each do |child_id|
      check_object(child_id, "")
   end
  end
end


if __FILE__ == $0
  def usage
    abort "ruby #{__FILE__} pbx_path [ignored_id:...]"
  end

  pbx_path = ARGV[0]
  if pbx_path.nil?
    usage
  end
  pbx_data = `plutil -convert json -o - #{ARGV[0]}`
  if $? != 0
    abort "Could not read project file!"
  end
  
  pbx_tree = JSON.parse(pbx_data)

  pbx_structure = PbxStructure.new(pbx_tree)
  if not ARGV[1].nil?
    pbx_structure.ignored_ids = ARGV[1].split(":")
  end
  pbx_structure.check
end
