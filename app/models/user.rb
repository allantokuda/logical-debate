class User < ApplicationRecord
  has_many :statements, dependent: :destroy
  has_many :arguments, dependent: :destroy
  has_many :stances, dependent: :destroy
  has_many :votes, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def display_username
    username.presence || hash_username
  end

  # For prototype, simulate three-letter initials
  def hash_username
    charset = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
    Digest::SHA1.hexdigest(email + created_at.usec.to_s)
      .chars
      .each_slice(2)
      .map(&:join)
      .map { |hex| hex.to_i(16) }
      .map { |i| charset[i % charset.length] }
      .join
      .slice(0, 6)
  end

  def upvoted_argument?(argument)
    Vote.find_by(user: self, argument: argument).present?
  end

  def votes_on_statement(statement)
    Vote.joins(:argument => :subject_statement).where('statements.id = ?', statement.id)
  end

  def logged_in?
    true
  end
end
