class Statement < ApplicationRecord
  has_many :premises, dependent: :destroy
  has_many :arguments
  has_many :dependent_arguments, through: :premises

  def words
    text.split(' ').map(&:strip)
  end
end
