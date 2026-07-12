require 'rails_helper'

RSpec.describe Item, type: :model do
  before do
    @item = FactoryBot.build(:item)
  end

  describe '商品出品' do
    context '正常系' do
      it 'すべての項目が存在すれば出品できる' do
        expect(@item).to be_valid
      end
    end

    context '異常系' do
      it '画像が空では出品できない' do
        @item.image = nil
        @item.valid?
        expect(@item.errors.full_messages).to include("Image can't be blank")
      end

      it '商品名が空では出品できない' do
        @item.name = ''
        @item.valid?
        expect(@item.errors.full_messages).to include("Name can't be blank")
      end

      it '商品の説明が空では出品できない' do
        @item.info = ''
        @item.valid?
        expect(@item.errors.full_messages).to include("Info can't be blank")
      end

      it 'カテゴリーが初期値では出品できない' do
        @item.category_id = 1
        @item.valid?
        expect(@item.errors.full_messages).to include('Category must be other than 1')
      end

      it '商品の状態が初期値では出品できない' do
        @item.sales_status_id = 1
        @item.valid?
        expect(@item.errors.full_messages).to include('Sales status must be other than 1')
      end

      it '配送料の負担が初期値では出品できない' do
        @item.shipping_fee_status_id = 1
        @item.valid?
        expect(@item.errors.full_messages).to include('Shipping fee status must be other than 1')
      end

      it '発送元の地域が初期値では出品できない' do
        @item.prefecture_id = 1
        @item.valid?
        expect(@item.errors.full_messages).to include('Prefecture must be other than 1')
      end

      it '発送までの日数が初期値では出品できない' do
        @item.scheduled_delivery_id = 1
        @item.valid?
        expect(@item.errors.full_messages).to include('Scheduled delivery must be other than 1')
      end

      it '価格が空では出品できない' do
        @item.price = ''
        @item.valid?
        expect(@item.errors.full_messages).to include('Price is not a number')
      end

      it '価格が300円未満では出品できない' do
        @item.price = 299
        @item.valid?
        expect(@item.errors.full_messages).to include('Price must be greater than or equal to 300')
      end

      it '価格が9,999,999円を超えると出品できない' do
        @item.price = 10_000_000
        @item.valid?
        expect(@item.errors.full_messages).to include('Price must be less than or equal to 9999999')
      end

      it '価格が全角数字では出品できない' do
        @item.price = '３００'
        @item.valid?
        expect(@item.errors.full_messages).to include('Price is not a number')
      end
    end
  end
end
