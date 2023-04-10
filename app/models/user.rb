# frozen_string_literal: true

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  attr_accessor :skip_password_validation
  extend Devise::Models
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
  include DeviseTokenAuth::Concerns::User

  after_create :create_sendinBlue_contact

  protected

  def password_required?
    return false if skip_password_validation
    super
  end


  def create_sendinBlue_contact
    SendinblueContactService.new(self).call
  end
end
