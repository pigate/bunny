require 'rake'

namespace :recipes do

  desc "retag recipes"
  task :retag => :environment do
    Recipe.all.each do |r|
      stag = r.s_tags
      if !s_tag.match(/^\"tags/)
        s = Hash.new
        s["tags"] = stag 
        s_tags = s.to_json
        r.update_attribute(:s_tags => s_tags)
      end
    end
  end
  
  desc "reindex recipes by tags"
  task :reindex => :environment do
    #RecipesTags.destroy_all
    Recipe.all.each do |r|
     r.tags.destroy_all
    end 
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE recipes_tags;")
    Recipe.all.each do |r|
      index_recipe(r)
    end
  end

  def index_recipe(recipe)
    #need to create recipes_tags model file to access table like this
    obj = JSON.parse(recipe.s_tags)
    obj["tags"].each do |tag|
      t = Tag.find_by_name(tag)
      if t != nil
        recipe.tags.push(t)
      end
    end
  end

  desc "lowercase tag_types and tags"
  task :lowercase_tags => :environment do
    TagType.all.each do |tag_type|
      tag_type.update_attributes("name" => tag_type.name.downcase)
    end
    Tag.all.each do |tag|
      tag.update_attributes("name" => tag.name.downcase)
    end
  end

  desc "lowercase s_tags for recipes"
  task :lowercase_recipe_tags => :environment do
    Recipe.all.each do |r|
      r.update_attributes("s_tags" => r.s_tags.downcase)
    end
  end

  #run this daily
  desc "decay_trend_level"
  task :daily_decay_trend_level => :environment do
    Recipe.all.each do |r|
      r.update_attributes(:trend_level => r.trend_level * 95)
    end
  end

  #in case cached_rating drifts
  desc "calc avg rating"
  task :calc_avg_rating => :environment do
    Recipe.all.each do |r|
      reviews = r.reviews
      review_count = reviews.count

      if review_count > 0
        ratings = reviews.map { |rev| rev.rating }
        sum_ratings = 0.0
        ratings.each do |rating|
          sum_ratings += rating
        end
        avg_rating = sum_ratings/(review_count * 1.0)
      else
        avg_rating = 0.0
      end
      r.update_attributes(:cached_rating => avg_rating)
    end

  end

  desc "reset_trend_level"
  task :reset_trend_level => :environment do
    Recipe.all.each do |r|
      views = r.global_views
      hearts = r.hearts.count
      reviews = r.reviews
      review_count = reviews.count
      views_contrib = views * 0.6
      hearts_contrib = hearts * 0.5
      reviews_contrib = 0.4 * ( review_count * r.cached_rating)
      
      trend_score = views_contrib + hearts_contrib + reviews_contrib

      r.update_attributes(:trend_level => trend_score)
    end
  end

  desc "do all tasks"
  task :all => [:retag, :lowercase_tags, :lowercase_recipe_tags, :reindex, :reset_trend_level]

  desc "remake tags and reindex"
  task :reset => [:retag, :lowercase_tags, :lowercase_recipe_tags, :reindex]
    
end
