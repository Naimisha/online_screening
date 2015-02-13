# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


#question = Question.create(question: 'hell', options: "[{\"opt\":\"A\"},{\"opt\": \"B\"}]", answer: '', weightage: 2, qtype: "m");
answer= AnswerSheet.create(user_id: 1, answer: "[{\"id\": 1, \"question_id\": 2},{\"id\": 2, \"question_id\": 1},{\"id\": 3, \"question_id\": 3}]", result: "[{\"question_id\": \"2\", \"answer\": \\\"\\\"}, {\"question_id\": \"1\", \"answer\": \\\"\\\"}, {\"question_id\": \"3\", \"answer\": \\\"\\\"}]")