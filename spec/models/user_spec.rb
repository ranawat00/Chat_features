# spec/models/user_spec.rb

require 'rails_helper'

RSpec.describe User, type: :model do
  
  it { should have_many(:messages) }

  
  it 'is valid with valid attributes' do
    user = User.new(
      email: 'testuser@example.com',
      password: 'password',
      password_confirmation: 'password'
    )
    expect(user).to be_valid
  end

  it 'is not valid without an email' do
    user = User.new(email: nil, password: 'password', password_confirmation: 'password')
    expect(user).not_to be_valid
  end

  it 'is not valid without a password' do
    user = User.new(email: 'testuser@example.com', password: nil, password_confirmation: 'password')
    expect(user).not_to be_valid
  end

  it 'is not valid if passwords do not match' do
    user = User.new(email: 'testuser@example.com', password: 'password', password_confirmation: 'different_password')
    expect(user).not_to be_valid
  end

  it 'is not valid with a duplicate email' do
    User.create(email: 'testuser@example.com', password: 'password', password_confirmation: 'password')
    user = User.new(email: 'testuser@example.com', password: 'password', password_confirmation: 'password')
    expect(user).not_to be_valid
  end

  
  it 'can be created with a password' do
    user = User.create(
      email: 'testuser@example.com',
      password: 'password',
      password_confirmation: 'password'
    )
    expect(user.persisted?).to be true
  end

  it 'cannot be created without a password' do
    user = User.create(
      email: 'testuser@example.com',
      password: nil,
      password_confirmation: nil
    )
    expect(user.persisted?).to be false
  end
end
