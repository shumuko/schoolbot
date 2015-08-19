class User < ActiveRecord::Base
  include Geocoded
  has_secure_password

  belongs_to :district
  has_many :student_labels
  has_many :students, through: :student_labels

  validates :name, :street, :city, :state, :zip_code, presence: true

  before_save :ensure_authentication_token

  def address
    [street, city, state, zip_code].join(', ')
  end

  private

  def ensure_authentication_token
    if authentication_token.blank?
      self.authentication_token = generate_authentication_token
    end
  end

  def generate_authentication_token
    loop do
      token = SecureRandom.hex
      break token unless User.find_by(authentication_token: token)
    end
  end
end
