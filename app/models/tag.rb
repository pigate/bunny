class Tag < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  has_and_belongs_to_many :recipes
  before_save :default_name
  def default_name
    self.name = self.name.downcase
  end

end
