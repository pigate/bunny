class Post < ActiveRecord::Base
  has_one :convo, :as => :conversable, :dependent => :destroy
  has_attached_file :photo,
    :default_url => "missing-recipe/:style.png",
    :styles => {
      :original => "590x405#",
      :cropped_square_thumb => {:geometry => "230x230#", :jcrop => true }
    },
    :convert_options => {
      :thumb => "-quality 75 -strip"
    },
    :bucket => ENV['AWS_BUCKET']

  validates_attachment_content_type :photo, :content_type => /\Aimage/
  validates_attachment_file_name :photo, :matches => [/png\Z/, /PNG\Z/, /jpe?g\Z/, /JPE?G\Z/]

end
