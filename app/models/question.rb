#--
#   Copyright (C) 2011 Priyanka Menghani <priyanka.menghani@gmail.com>
#
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU Affero General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU Affero General Public License for more details.
#
#   You should have received a copy of the GNU Affero General Public License
#   along with this program.  If not, see <http://www.gnu.org/licenses/>.
#++

class Question
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :content, :type => String
  referenced_in :poster, :class_name => "User"
  
  embeds_many :comments
  
  after_create :increment_question_count
  before_destroy :decrement_question_count
  
  # Votes
  field :upvotes, :type => Integer, :default => 0
  # Down-votes
  field :downvotes, :type => Integer, :default => 0
  
  def user_editable?(current_user)
    !current_user.nil? && (self.poster == current_user || current_user.is_admin?)
  end
  
  def user_deletable?(current_user)
    !current_user.nil? && (self.poster == current_user || current_user.is_admin?)
  end
  
  def user_votable?(current_user)
    #TODO Stub method. Decide policy and implement
    !current_user.nil?  
  end
  
  def upvote_question
    self.inc(:upvotes, 1)
  end
  
  def downvote_question
    self.inc(:downvotes, 1)
  end
  
  protected
  def increment_question_count
    self.poster.inc(:question_count, 1)
  end
  
  def decrement_question_count
    self.poster.inc(:question_count, -1)
  end
end
