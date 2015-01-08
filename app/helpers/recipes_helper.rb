require 'json'
module RecipesHelper
  @@num = 10
  def destringify(string_json)
    if (string_json != '' && string_json != nil)
#    if (string_json && /[A-Za-z]/.match(string_json))
      JSON.parse(string_json)
    else
      []
    end
  end

  def round_float_2(some_float)
    some_float.round(2)
  end
  def get_rating_px(some_float)
    (some_float/5.0) * 69 #69 px
  end

  def reindex_recipes_tags
    RecipesTags.destroy_all
    Recipes.each do |recipe|
      index_recipe(recipe)
    end
  end

  def index_recipe(recipe)
    #need to create recipes_tags model file to access table like this
    RecipesTags.where(:recipe_id => recipe.id).destroy_all
    obj = JSON.parse(recipe.s_tags)    
    obj["tags"].each do |tag|
      t = Tag.find_by_name(tag)
      if t != nil
        recipe.tags.push(t)
      end
    end
  end

  def add_to_analysis(filters, weight)
    if !member_signed_in?
      return
    else
      row = TagHits.find_by_member_id(current_member.id)
      tag_was_hit = false
      @filters = filters
      @valid_filters = []
      columns = TagHits.columns.map {|c| c.name}
      base_columns = columns.select { |i| !i.match(/percent$/) && i.match(/count$/) }

      @filters.each do |f|
        filter_count = "#{f}_count"
        if base_columns.include? filter_count
          @valid_filters.push(f)
          if !tag_was_hit
            row.update_attributes(:views => row.views + weight)
          end
          tag_was_hit = true
          filter_count_sym = filter_count.to_sym
          new_count = row.read_attribute(filter_count_sym) + weight
          row.update_attributes(filter_count_sym => new_count)
        end
      end
      total_views = row.views
      if total_views >= @@num && tag_was_hit
        base_columns.each do |f|
          filter_count = f
          filter_count_sym = filter_count.to_sym
          #recalculate percentages
          #for each filter_count, filter_count_percentage is calculated
          filter_count_percent = "#{filter_count}_percent"
          filter_count_percent_sym = "#{filter_count}_percent".to_sym
          #reset each filter_count
          #reset num views
          old_filter_count_percent = row.read_attribute(filter_count_percent_sym)
          if old_filter_count_percent == 0.0 #initialize attention at full span
            row.update_attributes(filter_count_percent_sym => row.read_attribute(filter_count_sym)/(total_views*1.0), filter_count => 0, :views => 0)
          else #attention span staggers off. use a weighted 'avg' interest
             new_percent = 0.4*(old_filter_count_percent)+0.6*row.read_attribute(filter_count_sym)/(total_views*1.0)
             row.update_attributes(filter_count_percent_sym => new_percent, filter_count => 0, :views => 0)
          end
       end
      end
    end
  end
end
