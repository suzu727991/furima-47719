require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = FactoryBot.build(:user)
  end

  describe 'ユーザー新規登録' do
    it 'すべての項目が存在すれば登録できる' do
      expect(@user).to be_valid
    end

    it 'nicknameが空では登録できない' do
      @user.nickname = ''
      expect(@user).not_to be_valid
    end

    it 'emailが空では登録できない' do
      @user.email = ''
      expect(@user).not_to be_valid
    end

    it 'emailが重複していると登録できない' do
      @user.save
      another_user = FactoryBot.build(:user, email: @user.email)
      expect(another_user).not_to be_valid
    end

    it 'emailに@が含まれていないと登録できない' do
      @user.email = 'testtest'
      expect(@user).not_to be_valid
    end

    it 'passwordが空では登録できない' do
      @user.password = ''
      expect(@user).not_to be_valid
    end

    it 'passwordが5文字以下では登録できない' do
      @user.password = 'a1b2c'
      @user.password_confirmation = 'a1b2c'
      expect(@user).not_to be_valid
    end

    it 'passwordが半角英字のみでは登録できない' do
      @user.password = 'abcdef'
      @user.password_confirmation = 'abcdef'
      expect(@user).not_to be_valid
    end

    it 'passwordが半角数字のみでは登録できない' do
      @user.password = '123456'
      @user.password_confirmation = '123456'
      expect(@user).not_to be_valid
    end

    it 'passwordとpassword_confirmationが不一致では登録できない' do
      @user.password_confirmation = 'def456'
      expect(@user).not_to be_valid
    end

    it 'first_nameが空では登録できない' do
      @user.first_name = ''
      expect(@user).not_to be_valid
    end

    it 'last_nameが空では登録できない' do
      @user.last_name = ''
      expect(@user).not_to be_valid
    end

    it 'first_nameが全角でなければ登録できない' do
      @user.first_name = 'taro'
      expect(@user).not_to be_valid
    end

    it 'last_nameが全角でなければ登録できない' do
      @user.last_name = 'yamada'
      expect(@user).not_to be_valid
    end

    it 'first_name_kanaが空では登録できない' do
      @user.first_name_kana = ''
      expect(@user).not_to be_valid
    end

    it 'last_name_kanaが空では登録できない' do
      @user.last_name_kana = ''
      expect(@user).not_to be_valid
    end

    it 'first_name_kanaが全角カタカナでなければ登録できない' do
      @user.first_name_kana = 'たろう'
      expect(@user).not_to be_valid
    end

    it 'last_name_kanaが全角カタカナでなければ登録できない' do
      @user.last_name_kana = 'やまだ'
      expect(@user).not_to be_valid
    end

    it 'birth_dateが空では登録できない' do
      @user.birth_date = ''
      expect(@user).not_to be_valid
    end
  end
end
