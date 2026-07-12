FactoryBot.define do
  factory :item do
    association :user
    name { '商品名' }
    info { '商品の説明' }
    category_id { 2 }
    sales_status_id { 2 }
    shipping_fee_status_id { 2 }
    prefecture_id { 2 }
    scheduled_delivery_id { 2 }
    price { 1000 }

    after(:build) do |item|
      item.image.attach(
        io: File.open(Rails.root.join('app/assets/images/item-sample.png')),
        filename: 'item-sample.png'
      )
    end
  end
end
