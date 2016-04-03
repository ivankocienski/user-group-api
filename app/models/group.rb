class Group < ActiveRecord::Base

  has_many :user_groups
  has_many :users, through: :user_groups

  validates :name, 
    length: { in: 3..100 }, 
    format: { with: /\A\w+\Z/, message: 'Contains bad characters' },
    presence: true,
    uniqueness: true

end
