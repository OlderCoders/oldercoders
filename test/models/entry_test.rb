require 'test_helper'

class EntryTest < ActiveSupport::TestCase
  def setup
    @account = accounts(:michael)
    @post    = entries(:post_1)
    @post_2  = entries(:post_2)
  end

  test "post should be valid" do
    byebug
    assert @post.valid?
  end

  test "post title is required" do
    @post.title = nil
    assert_not @post.valid?
  end

  test "slug is required" do
    @post.title = nil
    assert_not @post.valid?
  end

  test "slug should be unique" do
    @post.slug = @post_2.slug
    assert_not @post.valid?
  end

  test "entry should have an author, which is an Account" do
    assert @post.author.is_a? Account
  end

  test "an entry author is required" do
    @post.author = nil
    assert_not @post.valid?
  end

  test "Unique slugs are generated with each new post" do
    title = "Post Title"
    content = "Post Content"

    new_post_1 = @account.posts.create(title: title, body_raw: content)
    new_post_2 = @account.posts.create(title: title, body_raw: content)

    assert_not_equal new_post_1.slug, new_post_2.slug
  end

  test "Entry content is an RichText object" do
    assert @post.content.is_a? RichText
  end

end
