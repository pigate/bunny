require 'rake'

namespace :recipe_tags do
  desc "wipe tag_types"
  task :wipe_tag_types => :environment do
    TagType.destroy_all
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE tag_type;")
  end

  desc "create default tag_types"
  task :setup_tag_types => :environment do
    :wipe_tag_types
    default_tag_types = ["culture", "level"]
    default_tag_types.each do |tag_type_name|
     TagType.create!(:name => tag_type_name)
    end
  end

  desc "wipe tags, set default"
  task :wipe_and_setup => [:environment, :setup_tag_types] do
    Tag.destroy_all
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE tag;")
    default_culture = ["chinese", "american"]
    default_level = ["lazy", "easy", "average", "difficult"]
    default_culture.each do |tag_name|
      Tag.create!(:name => tag_name, :tag_type_id => 1)
    end
    default_level.each do |tag_name|
      Tag.create!(:name => tag_name, :tag_type_id => 2)
    end 
  end

  desc "do all tasks"
  task :all => [:wipe_and_setup]
    
end
