class User < ApplicationRecord
  # fields in database: first_name, last_name, active

  scope :active, ->{ where(active: true) }

  def full_name
    "#{first_name} #{last_name}"
  end

  def inactive?
    !active
  end
end

RSpec.describe 'User' do
  describe '.active' do
    it 'returns all the active users' do
      # We need proper database records because `.active` performs a database query (using .create!)
      active_user = User.create! active: true
      inactive_user = User.create! active: false

      expect(User.active).to eq([active_user])
    end
  end

  describe '#full_name' do
    it 'returns the full name of a user' do
      # We can do it without a proper database instance (only using .new)
      user = User.new first_name: 'John', last_name: 'Doe'

      # don't interpolate but explicitly expect what should be returned
      expect(user.full_name).to eq('John Doe')
    end
  end

  describe '#inactive?' do
    let(:user) { User.new(active: active) }

    context 'active = true' do
      let(:active) { true }

      it 'returns false' do
        expect(user.inactive?).to eq(false)
      end
    end

    context 'active = false' do
      let(:active) { false }

      it 'returns true' do
        expect(user.inactive?).to eq(true)
      end
    end

    context 'edge case: active = nil' do
      let(:active) { nil }

      it 'returns true' do
        expect(user.inactive?).to eq(true)
      end
    end
  end
end
