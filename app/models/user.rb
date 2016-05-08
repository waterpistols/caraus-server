class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :user_authentication_tokens, dependent: :destroy

  attr_accessor :auth_token

  ROLES = {
    :owner => 0,
    :regular => 1,
    :company => 2,    
    :admin => 3    
  }  
end
