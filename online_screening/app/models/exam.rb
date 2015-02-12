class Exam < ActiveRecord::Base
	has_many :exam_questions, :dependent => :delete_all
	has_many :question, :through => :exam_questions
	has_many :answer_sheets, :dependent => :delete_all
	
	validates :exam_name, :presence=> true
	validates :college_name, :presence=> true
	validates :duration_mins, :presence=> true, :numericality=> {only_integer: true, greater_than_or_equal_to: 0 }
	#validates :marks, :presence=> true, :numericality=> {only_integer: true, reater_than_or_equal_to: 0 }
	validates :date, :presence=> true
	#validates :time, :presence=> true
end
