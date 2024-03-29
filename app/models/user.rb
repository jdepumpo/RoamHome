class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :trips
  has_many :tasks, through: :trips
  has_many :my_tasks, foreign_key: 'user_id', class_name: 'Task'
  has_one_attached :photo
end
