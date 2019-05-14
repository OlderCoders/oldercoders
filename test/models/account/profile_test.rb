require 'test_helper'

class Account::ProfileTest < ActiveSupport::TestCase

  def setup
    @profile = account_profiles(:michael)
    @social_url_props = %i[
      facebook_url
      linkedin_url
      stackoverflow_url
      dribbble_url
      medium_url
      behance_url
      gitlab_url
    ]
    @other_url_props = %i[
      website_url
      employer_url
    ]
    @all_url_props = (@social_url_props & @other_url_props).uniq
    @tlds = {
      behance: 'net'
    }
  end

  test "profile should be vaild" do
    assert @profile.valid?
  end

  test "Birthday should be required" do
    @profile.birthday = nil
    assert_not @profile.valid?
  end

  test "Birthday should not be in the future" do
    @profile.birthday = 1.day.from_now
    assert_not @profile.valid?
  end

  test "Birthday should be within an older coder date range" do
    @profile.birthday = 122.years.ago
    assert_not @profile.valid?
    @profile.birthday = 20.years.ago
    assert_not @profile.valid?
  end

  test "Coding Since can be blank" do
    @profile.coding_since = nil
    assert @profile.valid?
  end

  test "Coding Since can the same year as a birthday" do
    @profile.coding_since = @profile.birthday.beginning_of_year
    assert @profile.valid?
  end

  test "Coding Since cannot be earlier than birthday birthday" do
    @profile.coding_since = @profile.birthday.beginning_of_year - 1.year
    assert_not @profile.valid?
  end

  test "website urls can be blank" do
    @all_url_props.each do |url|
      @profile.send "#{url}=", '   '
      assert @profile.valid?
      @profile.restore_attributes
    end
  end

  test "website urls should have an https? scheme" do
    @all_url_props.each do |url|
      domain = valid_domain_for url
      @profile.send "#{url}=", "#{domain}/#{@profile.account.username}"
      assert_not @profile.valid?, "#{url.to_sym} should require a scheme"
      %w[ftp file mailto ldap news tel telnet urn].each do |scheme|
        @profile.send "#{url}=", "#{scheme}://#{domain}/#{@profile.account.username}"
        assert_not @profile.valid?, "#{url.to_sym} incorrectly allowed scheme #{scheme}"
      end
      @profile.send "#{url}=", "http://#{domain}/#{@profile.account.username}"
      assert @profile.valid?
      @profile.send "#{url}=", "https://#{domain}/#{@profile.account.username}"
      assert @profile.valid?
      @profile.restore_attributes
    end
  end

  test "social website urls should validate to their specific domains, and have at least a subdirectory" do
    @social_url_props.each do |url|
      domain = valid_domain_for url
      @profile.send "#{url}=", "http://foo.com/"
      assert_not @profile.valid?, "#{url.to_sym} validation allowed a domain it shouldn't have"
      @profile.send "#{url}=", "http://#{domain}/"
      assert_not @profile.valid?, "#{url.to_sym} validation allowed no URL segments"
      @profile.send "#{url}=", "http://#{domain}/#{@profile.account.username}"
      assert @profile.valid?, "#{url.to_sym} should allow URL segments"
      @profile.restore_attributes
    end
  end

  test "website urls should not be too long" do
    @all_url_props.each do |url|
      domain = valid_domain_for url
      @profile.send "#{url}=", "http://#{domain}/#{'a' * 118}"
      assert_not @profile.valid?, "#{url.to_sym} failed length validation being too long"
      @profile.restore_attributes
    end
  end

  test "website should reject invalid URLs" do
    @all_url_props.each do |url|
      @profile.send "#{url}=", 'not a valid URL'
      assert_not @profile.valid?
      @profile.restore_attributes
    end
  end

  test "location can be blank" do
    @profile.location = nil
    assert @profile.valid?
  end

  test "twitter can be blank" do
    @profile.twitter_username = '   '
    assert @profile.valid?
  end

  test "twitter username gets cleaned up by trimming and stripping the @ symbol" do
    username = '   @username  '
    @profile.twitter_username = username
    @profile.save
    assert_equal @profile.reload.twitter_username, username.squish.delete('@')
    assert @profile.valid?
  end

  test "twitter username should not be too long" do
    @profile.twitter_username = "a" * 129
    assert_not @profile.valid?
  end

  test "github username can be blank" do
    @profile.github_username = '   '
    assert @profile.valid?
  end

  test "github username gets cleaned up by trimming and stripping the @ symbol" do
    username = '   @username  '
    @profile.github_username = username
    @profile.save
    assert_equal @profile.reload.github_username, username.squish.delete('@')
    assert @profile.valid?
  end

  test "github username should not be too long" do
    @profile.github_username = "a" * 129
    assert_not @profile.valid?
  end

  test "bio can be blank" do
    @profile.bio = nil
    assert @profile.valid?
  end

  test "bio should not be too long" do
    @profile.bio = "a" * 256
    assert_not @profile.valid?
  end

  test "Bio should be able to include emoji" do
    @profile.bio = "😈"
    @profile.save
    assert @profile.valid?
  end

  test "Arbitrary HTML should be stripped string attributes on save" do
    html = '<b><a href="http://foo.com/">foo</a></b><img src="bar.jpg"><script src="http://hackz.js"></script>'
    @profile.attributes.each do |attr_name, attr_value|
      next unless attr_value.is_a? String
      @profile[attr_name] = html
      if @profile.valid?
        @profile.save!
        assert_equal 'foo', @profile.reload[attr_name]
      else
        # The HTML string didn't pass validation. Reset the value
        @profile[attr_name] = attr_value
      end
    end
  end

  private

    def valid_domain_for(sym)
      domain = sym.to_s.gsub '_url', ''
      tld = @tlds[domain.to_sym]
      return "#{domain}.#{tld}" if tld.present?

      "#{domain}.com"
    end

end
