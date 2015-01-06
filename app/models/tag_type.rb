class TagType < ActiveRecord::Base
  has_many :tags
  validates :name, presence: true, uniqueness: true
  before_save :default_name
  def default_name
    self.name = self.name.downcase
  end

end
