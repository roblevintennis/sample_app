require 'spec_helper'

describe User do

  before(:each) do
    @attr = { :name => "Example User", :email => "user@example.com" }
  end

  it "should create a new instance given valid attributes" do
    User.create!(@attr)
  end
 
  it "should require a name" do
    no_name_user = User.new(@attr.merge :name => '')
    no_name_user.should_not be_valid
  end
 
  it "should require an email" do
    no_email = User.new(@attr.merge :email => '')
    no_email.should_not be_valid
  end
 
  it "should reject names that are too long" do
    ln = 'a' * 51
    long_name_user = User.new(@attr.merge :name => ln)
    long_name_user.should_not be_valid
  end

  it "should accept valid email addresses" do
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
      valid_email_user = User.new(@attr.merge(:email => address))
      valid_email_user.should be_valid
    end
  end

  it "should reject invalid email addresses" do
    addresses = %w[user@foo,com me_at_foo.org first.last@foo.]
    addresses.each do |address|
      invalid_email_user = User.new(@attr.merge(:email => address))
      invalid_email_user.should_not be_valid 
    end
  end
  
  it "should reject duplicate email addresses" do
    # First put a valid user in db and then check that we can't duplicate
    User.create!(@attr)
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end

  it "should reject email addresses identiacal up to case" do
    upcased_email = @attr[:email].upcase
    User.create!(@attr.merge(:email => upcased_email))
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end
end
