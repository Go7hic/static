require 'spec_helper'

describe User do
  before do
    @user = User.new(name: "Example User", email: "user@example.com", password: "foobar", password_confirmation: "foobar")
  end
  subject { @user }
  it {should respond_to(:name)}
  it { should respond_to(:email) }
  it {should respond_to (:password_digest)}
  it {should respond_to(:password)}
  it {should respond_to(:password_confirmation)}
  it {should be_valid}

  describe "when password is n ot present" do
    before {@user.password = @user.password_confirmation = ''}
    it { should_not be_valid }
  end

  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation = "mismatch" }
    it {should_not be_valid}
  end

  describe "when password confirmation is nil" do
    before {@user.password_confirmation = nil}
    it {should_not be_valid}
  end

  describe "width a password that's too short" do
    before { @user.password = @user.password_confirmation = "a"*5 }
    it {should be_valid}
  end

  describe "return value of authenticate method" do
    before {@user.save}
    let (:found_user) { User.find_by_email(@user.email) }

    describe "width valid password" do
      it { should == found_user.authenticate(@user.password) }
    end
    describe "width invalid password " do
      let (:user_for_invalid_password) {found_user.authenticate("invalid")}

      it {should_not == user_for_invalid_password}
      specify {user_for_invalid_password.should be_valid}
    end
  end
end
