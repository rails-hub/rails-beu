class CreditCardInformation < ActiveRecord::Base
  belongs_to :user
  attr_accessible :card_number, :expiry_date, :first_name, :last_name, :response, :user_id, :verification_code, :is_active, :full_name
  validate :card_number, :presence => true
  scope :inactive, where(:is_active=>false)
  after_save do |credit_card_information|
    user = credit_card_information.user
    user.credit_card_informations.update_all({:is_active=>false}, ["credit_card_informations.id <> ?", credit_card_information.id]) if credit_card_information.is_active?
  end
  def full_name
    "#{first_name} #{last_name}"
  end
  def full_name=(name)
    name = name.split(" ", 2)
    first_name, last_name = name.first, name.last
  end
end
