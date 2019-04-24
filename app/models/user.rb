class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :todo_lists

  #generate access token for api's
  def generate_token
    loop do
      self.access_token = SecureRandom.base64(30)
      break unless User.exists?(access_token: self.access_token)
    end
    self.update(access_token: access_token)
  end
end
