class Review < ApplicationRecord
    belongs_to :user, optional: true
    belongs_to :restaurant

    validates :content, presence: true
    validates :rating, presence: true
end
