class User < ActiveRecord::Base
  attr_accessor :password
  before_save :encrypt_password

  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :email
  validates_uniqueness_of :email

  has_one :user_stat
  has_many :blackjacks

  def self.authenticate(email, password)
    user = find_by(email: email)
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end

  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end

  def increment_user_score(game_state)
    if game_state == Blackjack::STATE_USER_WIN
      self.user_stat.increment!(:wins)
    elsif game_state == Blackjack::STATE_DEALER_WIN
      self.user_stat.increment!(:losses)
    end
  end
end
