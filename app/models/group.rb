class Group < ActiveRecord::Base

  validates :name, 
    length: { in: 3..100 }, 
    format: { with: /\A\w+\Z/, message: 'Contains bad characters' },
    presence: true,
    uniqueness: true

end
