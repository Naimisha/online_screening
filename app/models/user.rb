class User < ActiveRecord::Base
	has_one :privilege
	has_one :role, :through => :privilege
	has_one :answer_sheet


	
	validates :first_name, :presence=> true
	validates :last_name, :presence=> true
	
	validates :date_of_birth, :presence=> true
	
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
