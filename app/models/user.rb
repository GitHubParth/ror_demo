class User < ApplicationRecord
    before_save { self.email = email.downcase }
    has_many :articles, dependent: :destroy
    validates :username, presence: true, 
                uniqueness: { case_sensitive: false },
                length: { minimum: 3, maximum: 25 }
    VALID_EMAIL_REGEX =  /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email, presence: true, 
                uniqueness: { case_sensitive: false }, 
                length: { maximum: 105 }, 
                format: { with: VALID_EMAIL_REGEX }
    validates :password, presence: true, length: { minimum: 8, maximum: 30 }, on: :create
    has_secure_password
    has_one_attached :profile_img
end
