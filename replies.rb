require 'sqlite3'
require 'singleton'

class RepliesDatabase < SQLite3::Database
  include Singleton

  def initialize
    super('questions.db')
    self.type_translation = true
    self.results_as_hash = true
  end
end

class Reply
  attr_accessor :id, :question_id, :parent_reply_id, :user_id, :body

  def self.all
    data = RepliesDatabase.instance.execute("SELECT * FROM replies")
    data.map { |datum| Reply.new(datum) }
  end

  def initialize(options)
    @id = options['id']
    @question_id = options['question_id']
    @parent_reply_id = options['parent_reply_id']
    @user_id = options['user_id']
    @body = options['body']
  end

  def self.find_by_user_id(user_id)
    data = RepliesDatabase.instance.execute("SELECT * FROM replies WHERE user_id = #{user_id}")
    data.map { |datum| Reply.new(datum) }
  end
  
  def self.find_by_question_id(question_id)
    data = RepliesDatabase.instance.execute("SELECT * FROM replies WHERE question_id = #{question_id}")
    data.map { |datum| Reply.new(datum) }
  end

  def author
    Users.find_by_id(@user_id)
  end

  def question
    Question.find_by_id(@question_id)
  end

  def parent_reply
    data = RepliesDatabase.instance.execute("SELECT * FROM replies WHERE id = #{parent_reply_id}")
    data.map { |datum| Reply.new(datum) }
  end

  def child_replies
    data = RepliesDatabase.instance.execute("SELECT * FROM replies WHERE parent_reply_id = #{id}")
    data.map { |datum| Reply.new(datum) }
  end
end