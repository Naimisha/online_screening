class AnswerSheet < ActiveRecord::Base
  belongs_to :user
  belongs_to :exam
  serialize :answer, JSON
  serialize :result, JSON 
end
