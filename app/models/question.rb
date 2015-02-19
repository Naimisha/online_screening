class Question < ActiveRecord::Base
	has_many  :exam_questions
	has_many :exams, :through => :exam_questions
	validates :question, :presence=> true
	validates :options, :presence=> true
	validates :answer, :presence=> true
	validates :weightage, :presence=> true
	validates :nooptions, :presence=> true, :numericality=> {only_integer: true, less_than: 7, greater_than: 0 } 
	validates :qtype, :presence=> true
end
