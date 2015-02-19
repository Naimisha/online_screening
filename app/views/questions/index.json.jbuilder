json.array!(@questions) do |question|
  json.extract! question, :id, :question, :options, :answer, :weightage, :qtype
  json.url question_url(question, format: :json)
end
