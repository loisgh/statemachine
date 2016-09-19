require_relative "Article"
require "test/unit"

class TestArticle < Test::Unit::TestCase

  def test_happy_path
    #Instanciate a new Article
    article = Article.new
    #Create the article
    article.create
    assert_equal(article.current_state,"Creation")
    #Accept the article the state should now be set to writing
    article.accept!
    assert_equal(article.current_state,"Writing")
    #Update the copy the state should stay at Writing
    article.update_copy
    assert_equal(article.current_state,"Writing")
    #Accept the Article the state should be set to Editing
    article.accept!
    assert_equal(article.current_state,"Editing")
    #Reject the article the state should stay as Editing
    article.reject!
    assert_equal(article.current_state,"Editing")
    #Accept the article the state should be set to Design
    article.accept!
    assert_equal(article.current_state,"Design")
    #Set the art  the state should be set to Art_Review
    article.set_art!
    assert_equal(article.current_state,"Art_Review")
    #Reject the Art the state should be set to Design
    article.reject_art!
    assert_equal(article.current_state,"Design")
    #Set Art
    article.set_art!
    #Accept the art the state should be set to Build
    article.accept_art!
    assert_equal(article.current_state,"Build")
    #Build Code the state should be set to Preview
    article.build_code
    assert_equal(article.current_state,"Preview")
    #Stage the state should be set to "Final_Review"
    article.stage
    assert_equal(article.current_state,"Final_Review")
    #Update Copy the state should be set back to Build
    article.update_copy
    assert_equal(article.current_state,"Build")
    article.build_code
    article.stage
    #Accept the article the state should be set to Publish
    article.accept!
    assert_equal(article.current_state,"Publish")
    #Publish the state should be set to Published
    article.publish
    assert_equal(article.current_state,"Published")
  end

  def test_errors_raised
    #This test demonstrates that an article must be in the proper state before an action is taken.  If it isn't an exception is thrown.
    article = Article.new
    assert_raise_with_message RuntimeError, "you cannot accept this article from the following state: " do
      article.accept!
    end

    assert_raise_with_message RuntimeError, "you can only accept art from stage Art Review" do
      article.accept_art!
    end

    assert_raise_with_message RuntimeError, "you cannot reject this article from the following state: " do
      article.reject!
    end

    assert_raise_with_message RuntimeError, "you can only reject art from stage Art Review" do
      article.reject_art!
    end

    assert_raise_with_message RuntimeError, "you can only set art from stage Design" do
      article.set_art!
    end

    assert_raise_with_message RuntimeError, "you cannot update_copy from this state" do
      article.update_copy
    end

    assert_raise_with_message RuntimeError, "you can only build code if the state is Build" do
      article.build_code
    end

    assert_raise_with_message RuntimeError, "you can only stage if the state is Preview" do
      article.stage
    end
  end

  def test_cancel
    #This test demonstrates that the article can be canceled at any point.
    article = Article.new
    #Create the article
    article.create
    #Cancel the article
    article.cancel
    assert_equal(article.current_state,"Cancel")

    article = Article.new
    #Create the article
    article.create
    article.accept!
    article.accept!
    article.accept!
    assert_equal(article.current_state,"Design")
    #Cancel the article
    article.cancel
    assert_equal(article.current_state,"Cancel")
    #You cannot go to any other state from Cancel
    assert_raise_with_message RuntimeError, "you cannot accept this article from the following state: Cancel" do
      article.accept!
    end
    assert_raise_with_message RuntimeError, "you can only accept art from stage Art Review" do
      article.accept_art!
    end

  end

end