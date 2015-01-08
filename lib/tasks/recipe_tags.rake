require 'rake'
require 'json'

namespace :recipe_tags do
  desc "wipe tag_types"
  task :wipe_tag_types => :environment do
    TagType.destroy_all
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE tag_types;")
  end

  desc "create default tag_types"
  task :setup_tag_types => :environment do
    TagType.destroy_all
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE tag_types;")

    default_tag_types = ["culture", "level"]
    default_tag_types.each do |tag_type_name|
     TagType.create!(:name => tag_type_name)
    end
  end

  desc "wipe tags, set default"
  task :wipe_and_setup => [:environment, :setup_tag_types] do
    Tag.destroy_all
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE tags;")
    default_culture = ["chinese", "american"]
    default_level = ["lazy", "easy", "average", "difficult"]
    default_culture.each do |tag_name|
      Tag.create!(:name => tag_name, :tag_type_id => TagType.find_by_name("culture").id)
    end
    default_level.each do |tag_name|
      Tag.create!(:name => tag_name, :tag_type_id => TagType.find_by_name("level").id)
    end 
  end

  desc "denest tags"
  task :denest_tags => [:environment] do
    R = Recipe.all
    R.each do |r|
      raw_tags = denest_tags(r.s_tags)
      s = Hash.new
      s["tags"] = raw_tags 
      r.update_attributes(:s_tags => s.to_json)
    end    
  end

  desc "do all tasks"
  task :all => [:denest_tags, :wipe_and_setup]
    
 @debug = false

def denest_tags(obj)
 if obj.class.name != "Array" && obj.class.name != "Hash" && obj.class.name != "String"
   raise "denest_tags: bad obj type"
 end
 to_break = false
 a = obj
 arr = []
 if a.class.name == "Array"
   if @debug
     puts "Found array"
   end
   arr = a
 else
   while a.class.name != "Hash" && !to_break
     if @debug
       puts "Found not hash. Type #{a.class.name}"
       puts a
     end
     begin
       a = destringify(a)
     rescue
       if @debug
         puts "Rescue #{a.class.name} found"
       end
       to_break = true
       if a.class.name == "Array"
         if @debug
           puts "Found array inside!"
         end
       elsif a.class.name == "String"
         if @debug
           puts "Here's a string!"
           puts a
         end
         arr = a.split(',')
         if @debug
           puts "Split a"
           puts arr
         end
       end
     end
   end
   if a.class.name == "Hash" && a.class.name != "Array" && !to_break
     if a.has_key?("tags")
       if @debug
         puts "Going Deeper. Type #{a.class.name}"
         puts a
       end
       a = a["tags"]
       arr = denest_tags(a)
     else
       if @debug
         puts "Give up"
         puts a
       end
       arr = []
     end
   elsif a.class.name == "String"
     if @debug
       puts "Found string"
       puts a
     end
     begin
       arr = a = destringify(a)["tags"]
     rescue
       arr = a.split(',')
     end
   end
 end
 arr.map { |r| r.strip }
end

def destringify(string_json)
  if (string_json != '' && string_json != nil)
    JSON.parse(string_json)
  else
    []
  end
end


end
