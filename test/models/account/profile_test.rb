require 'test_helper'

class Account::ProfileTest < ActiveSupport::TestCase

  def setup
    @profile = account_profiles(:michael)
    @url_props = %i[
      website_url
      employer_url
      facebook_url
      linkedin_url
      stackoverflow_url
      dribbble_url
      medium_url
      behance_url
      gitlab_url
    ]
  end

  test "profile should be vaild" do
    assert @profile.valid?
  end

  test "website urls should not be too long" do
    @url_props.each do |url|
      @profile.send "#{url}=", 'a' * 129
      assert_not @profile.valid?
      @profile.restore_attributes
    end
  end

  test "website should a valid URL" do
    @url_props.each do |url|
      @profile.send "#{url}=", 'not a valid URL'
      assert_not @profile.valid?
      @profile.restore_attributes
    end
  end

  test "location should not be too long" do
    @profile.location = "a" * 129
    assert_not @profile.valid?
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

end
