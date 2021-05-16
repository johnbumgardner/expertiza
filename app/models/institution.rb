class Institution < ApplicationRecord
  attr_accessible :name
  has_many :courses, dependent: :destroy

  validates :name, length: {minimum: 1}
  validates :name, uniqueness: true
end
