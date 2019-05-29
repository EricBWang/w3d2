require 'sqlite3'
require 'singleton'

class QuestionFollowsDatabase < SQLite3::Database
  include Singleton

  def initialize
    super('questions.db')
    self.type_translation = true
    self.results_as_hash = true
  end
end

class QuestionFollow
  attr_accessor :id, :question_id, :user_id

  def self.all
    data = QuestionFollowsDatabase.instance.execute("SELECT * FROM question_follows")
    data.map { |datum| QuestionFollow.new(datum) }
  end

  def initialize(options)
    @id = options['id']
    @question_id = options['question_id']
    @user_id = options['user_id']
  end

  def self.followers_for_question_id(question_id)
    data = QuestionFollowsDatabase.instance.execute("SELECT users.id, users.fname, users.lname FROM question_follows LEFT JOIN users ON question_follows.user_id = users.id WHERE question_follows.question_id = #{question_id}")
    data.map { |datum| User.new(datum) }
  end

  def self.followed_questions_for_user_id(user_id)
    data = QuestionFollowsDatabase.instance.execute("SELECT questions.id, questions.title, questions.body FROM question_follows LEFT JOIN questions ON question_follows.question_id = questions.id WHERE question_follows.user_id = #{user_id}")
    data.map { |datum| Question.new(datum) }
  end

  def self.most_followed_questions(n)
    data = QuestionFollowsDatabase.instance.execute("SELECT questions.title, questions.body, questions.id FROM question_follows LEFT JOIN questions ON question_follows.question_id = questions.id GROUP BY question_follows.question_id ORDER BY COUNT(question_follows.user_id)  DESC LIMIT #{n}")
    data.map { |datum| Question.new(datum) }
  end
end