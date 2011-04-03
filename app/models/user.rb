class User
  include Mongoid::Document
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  field :username, :type => String
  field :question_count, :type => Integer, :default => 0
  field :comment_count, :type => Integer, :default => 0
  
  validates_presence_of :username
  validates_uniqueness_of :username
  
  references_many :questions, :inverse_of => :poster, :dependent => :delete
  references_many :comments, :inverse_of => :comment_poster, :dependent => :delete
  
  attr_accessible :email, :username, :password, :password_confirmation, :remember_me
  
  def user_editable?(current_user)
    !current_user.nil? && (self == current_user || current_user.is_admin?)
  end
  
  def is_admin?
    #TODO: Set up an appropriate admin user check
    true
  end
end
