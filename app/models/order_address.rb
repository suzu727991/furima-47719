class OrderAddress
  include ActiveModel::Model
  attr_accessor :user_id, :item_id, :postal_code, :prefecture_id, :city, :house_number, :building, :phone_number, :token

  with_options presence: true do
    validates :user_id
    validates :item_id
    validates :city
    validates :house_number
    validates :phone_number
    validates :token
    validates :postal_code, format: { with: /\A\d{3}-\d{4}\z/, message: 'is invalid. Enter it as follows (e.g. 123-4567)' }
  end
  validates :prefecture_id, numericality: { other_than: 1, message: "can't be blank" }
  with_options format: { with: /\A\d{10,11}\z/, message: 'is invalid. Enter only number' }, if: -> { phone_number.present? } do
    validates :phone_number
  end

  def save
    ActiveRecord::Base.transaction do
      order = Order.create!(user_id: user_id, item_id: item_id)
      Address.create!(
        postal_code: postal_code, prefecture_id: prefecture_id, city: city,
        house_number: house_number, building: building, phone_number: phone_number, order_id: order.id
      )
    end
  end
end
