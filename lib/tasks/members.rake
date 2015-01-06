require 'rake'

namespace :members do
  desc "member_analytics search_tags"
  task :setup_tag_hits => :environment do
    TagHits.destroy_all
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE tag_hits;")
    Member.all.each do |m|
      #create a row for each member
      TagHits.create!(:member_id => m.id)
    end
  end

  desc "member_analytics recently_viewed_recipes"
  task :setup_recipe_views => :environment do
    RecentlyViewedRecipes.destroy_all
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE recently_viewed_recipes;")
    Member.all.each do |m|
      RecentlyViewedRecipes.create!(:member_id => m.id)
    end
  end

  desc "setup recommendations for each user"
  task :recommend => :environment do
    columns = TagHits.columns.map {|c| c.name}
    base_columns = columns.select { |i| !i.match(/percent$/) && i.match(/count$/) }
    t = Tag.all
    Member.all.each do |m|

      reviewed_list = m.reviewed_recipes

      full_rec_list = []
      #pull from members current member is following
      followeds = m.following
      followeds.each do |f|
        #append recently viewed recipes
        recently_viewed = f.recently_viewed_recipes.recently_viewed_list.split(',')
        recently_viewed.each do |r|
          if !full_rec_list.include? r
            full_rec_list.push(Recipe.find(r.to_i))
          end
        end
        hearted = f.liked_recipes
        hearted.each do |r|
          if !full_rec_list.include? r
            full_rec_list.push(r)
          end
        end
        reviews = f.reviews
        reviews.each do |rev|
          r = rev.reviewed_recipe
          if rev.rating >= 4 and !full_rec_list.include? r
            full_rec_list.push(r)
          end
        end
        f.recipes.each do |r|
          if !full_rec_list.include? r
            full_rec_list.push(r)
          end
        end
      end

      #pull from top trending from categories of interest
      row = TagHits.find_by_member_id(m.id)
      #check if need to initialize any percents
      total_count = 0.0
      base_columns.each do |b|
        base_percent_sym = "#{b}_percent".to_sym
        base_sym = "#{b}".to_sym
        base_percent_amount = row.read_attribute(base_percent_sym)
        if base_percent_amount == 0.0
          if row.views != 0
            row.update_attributes(base_sym  => row.read_attribute(base_sym)/row.views)
            base_percent_amount = row.read_attribute(base_percent_sym)
          end
        end
        total_count += base_percent_amount
      end      
      
      if total_count != 0.0
        base_columns.each do |b|
          base_percent_sym = "#{b}_percent".to_sym
          base_percent_amount = row.read_attribute(base_percent_sym)
          num_to_get = (10 * base_percent_amount/total_count).to_i
          tag_name = b.sub('_count','') # "chinese"
          puts tag_name
          t_select = t.select { |tag| tag.name == tag_name }
          if t_select != []
            actual_tag = t_select[0] 
            grabbed = actual_tag.recipes.limit(num_to_get)
            grabbed.each do |r|
              if !full_rec_list.include? r
                full_rec_list.push(r)
              end
            end
          end
        end
      end

      #top trending
      top_trending = Recipe.order('trend_level DESC').limit(5)
      top_trending.each do |r|
        if !full_rec_list.include? r
          full_rec_list.push(r)
        end
      end

      top_rated = Recipe.order('cached_rating DESC').limit(5)
      top_rated.each do |r|
        if !full_rec_list.include? r
          full_rec_list.push(r)
        end
      end

      current_member_rated = m.reviewed_recipes
      unordered_rec_list = full_rec_list.select { |r| !current_member_rated.include? r and !reviewed_list.include? r}

      ordered_rec_list = unordered_rec_list.sort_by { |e| -e[:trend_level] }
      rec_row = Recommendations.find_by_member_id(m.id)
      id_list = ordered_rec_list.map { |e| e.id }
      rec_row.update_attributes(:recs_list => id_list.join(','))
    end
  end

  desc "setup recs"
  task :setup_rec_table => :environment do
    Recommendations.destroy_all
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE recommendations;")
    Member.all.each do |m|
      Recommendations.create!(:member_id => m.id)
    end
  end


  desc "do all tasks"
  task :all => [:setup_tag_hits, :setup_recipe_views, :setup_rec_table, :recommend]
    
end
