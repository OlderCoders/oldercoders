require 'test_helper'

class AccountTest < ActiveSupport::TestCase

  def setup
    @account      = accounts(:michael)
    @account_hugh = accounts(:hugh)
    @accounts     = [@account, @account_hugh]
  end

  test "should be valid" do
    @accounts.each do |account|
      assert account.valid?
    end
  end

  test "first and last name should be present" do
    @accounts.each do |account|
      %i[first_name last_name].each do |name_part|
        account[name_part] = '    '
        assert_not account.valid?
        account.restore_attributes
        assert account.valid?
      end
    end
  end

  test "name should not be too long" do
    @accounts.each do |account|
      %i[first_name last_name].each do |name_part|
        account[name_part] = "a" * 256
        assert_not account.valid?
        account.restore_attributes
        assert account.valid?
      end
    end
  end

  test "name should accept emoji" do
    @accounts.each do |account|
      %i[first_name last_name].each do |name_part|
        account[name_part] = "😈"
        account.save
        assert account.valid?
      end
    end
  end

  test "username should be present" do
    @accounts.each do |account|
      account.username = "     "
      assert_not account.valid?
    end
  end

  test "username should not accept emoji" do
    @accounts.each do |account|
      account.username = "😈" * 255
      account.save
      assert_not account.valid?
    end
  end

  test "username should not be too long" do
    @accounts.each do |account|
      account.username = "a" * 101
      assert_not account.valid?
    end
  end

  test "username validation should accept valid usernames" do
    # it should only accept letter, numbers and underscores
    valid_usernames = ['hugh_jass', '_hughjass__', '_h_u_g_h_', 'hughjass4eva' '123abc' ]
    valid_usernames.each do |valid_username|
      @accounts.each do |account|
        account.username = valid_username
        assert account.valid?, "#{valid_username.inspect} should be a valid username"
      end
    end
  end

  test "username validation should reject invalid usernames" do
    # it should only accept letter, numbers and underscores
    invalid_usernames = ['hugh jass', ' hughjass  ', 'hugh-jass', 'hugh*$$', 'hüghjàß', '<foo>', 'bar?', '😈', 'DROP TABLE *' ]
    invalid_usernames.each do |invalid_username|
      @accounts.each do |account|
        account.username = invalid_username
        assert_not account.valid?, "#{invalid_username.inspect} should be an invalid username"
      end
    end
  end

  test "username validation should reject reserved words without regards to case" do
    # it should only accept letter, numbers and underscores
    invalid_username = ReservedWords.all.sample
    @accounts.each do |account|
      account.username = invalid_username
      assert_not account.valid?, "#{account.username.inspect} should be an reserved username"
      account.username.upcase!
      assert_not account.valid?, "#{account.username.inspect} should be an reserved username"
    end
  end

  test "username should be unique" do
    @accounts.each do |account|
      duplicate_account = account.dup
      duplicate_account.username = account.username.upcase
      account.save!
      assert_not duplicate_account.valid?
    end
  end

  test "email should be present on user, but not necessarily on ensemble" do
    @account.email = "     "
    assert_not @account.valid?
  end

  test "email should not be too long" do
    @accounts.each do |account|
      account.email = "a" * 244 + "@example.com"
      assert_not account.valid?
    end
  end

  test "pending email should not be too long" do
    @accounts.each do |account|
      account.email = "a" * 244 + "@example.com"
      account.save
      assert_not account.valid?
    end
  end

  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @accounts.each do |account|
        # Check both email and pending email
        account.email = valid_address
        account.unconfirmed_email = valid_address
        assert account.valid?, "#{valid_address.inspect} should be valid"
      end
    end
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[account@example,com account_at_foo.org account.name@example.foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @accounts.each do |account|
        # Check both email and pending email
        account.email = invalid_address
        account.unconfirmed_email = invalid_address
        assert_not account.valid?, "#{invalid_address.inspect} should be invalid"
      end
    end
  end

  test "email addresses should strip leading and trailing whitespace" do
    @accounts.each do |account|
      sloppy_email = " #{account.username}@bar.com   "
      account.email = sloppy_email
      account.save
      # Because we're using :confirmable, Devise saves the new email in the :unconfirmed_email column
      assert_equal sloppy_email.downcase.strip, account.reload.unconfirmed_email
    end
  end

  test "pending email addresses should strip leading and trailing whitespace" do
    @accounts.each do |account|
      sloppy_email = " #{account.username}@biglog.com   "
      account.unconfirmed_email = sloppy_email
      account.save
      assert_equal sloppy_email.downcase.strip, account.reload.unconfirmed_email
    end
  end

  test "email addresses should be saved as lower-case" do
    @accounts.each do |account|
      new_email = "FoOBar_#{account.email}"
      account.email = new_email
      account.save
      # Remember :confirmable from Devise
      assert_equal new_email.downcase, account.reload.unconfirmed_email
      account.confirm
      assert_equal new_email.downcase, account.reload.email
    end
  end

  test "pending email addresses should be saved as lower-case" do
    @accounts.each do |account|
      mixed_case_email = "#{account.username}_FoO@BAr.OrG"
      account.unconfirmed_email = mixed_case_email
      account.save
      assert_equal mixed_case_email.downcase, account.reload.unconfirmed_email
    end
  end

  test "email addresses for accounts should be unique" do
    duplicate_account = @account.dup
    duplicate_account.email = @account.email.upcase
    assert_not duplicate_account.valid?
  end

  test "pending email addresses for accounts should be unique" do
    # make sure that the new email doesn't match another account's email
    @account_hugh.email = @account.email.upcase
    assert_not @account_hugh.valid?

    # Make sure pending addresses are also unique amongst themselves
    pending_address = "luke@rebelalliance.com"
    @account.unconfirmed_email = pending_address
    @account.save
    assert @account.valid?
    @account_hugh.unconfirmed_email = pending_address
    assert_not @account_hugh.valid?
  end

  test "password should not equal the username or email address, case insensitive" do
    @accounts.each do |account|
      assert account.valid?
      account.password = account.email.upcase
      assert_not account.valid?
      account.password = account.username.upcase
      assert_not account.valid?
    end
  end

  test "Arbitrary HTML should be stripped string attributes on save" do
    html = '<b><a href="http://foo.com/">foo</a></b><img src="bar.jpg"><script src="http://hackz.js"></script>'
    @accounts.each do |account|
      account.attributes.select{ |_, value| value.is_a? String }.each do |key, value|
        previous_value = value
        account[key] = html
        if account.valid?
          account.save!
          assert_equal 'foo', account.reload[key]
          account[key] = previous_value
          account.save
        else
          # The HTML string didn't pass validation. Reset the value
          account[key] = value
        end
      # As an enum, 'role' throws an ArgumentError if you try to set it as something invalid
      rescue ArgumentError => exception
        account[key] = value
      end
    end
  end

  test "Creating an Account should create a Profile" do
    assert_difference 'Account::Profile.count', 1 do
      Account.create first_name: 'Luke', last_name: 'Skywalker', password: 'rebelyellers', email: 'luke@rebelalliance.org'
    end
  end

  test "Associated Profile should be destroyed when destroying Account" do
    assert_difference 'Account::Profile.count', @accounts.count * -1 do
      @accounts.each(&:destroy)
    end
  end

  test "associated account should be destroyed when destroying Account" do
    assert_difference 'Account.count', @accounts.count * -1 do
      @accounts.each(&:destroy)
    end
  end

end
