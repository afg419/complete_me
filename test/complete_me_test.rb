require_relative '../lib/complete_me'
require 'minitest'
require 'pry'

class CompleteMeTest < Minitest::Test

  attr_reader :complete

  def setup
    @complete = CompleteMe.new("")
  end

  def test_it_exists
    assert CompleteMe.new
  end

  def test_it_initializes_without_data
    completed = CompleteMe.new
    refute completed.root
  end

  def test_it_can_initialize_with_data
    assert_equal "" , complete.root
  end

  def test_it_begins_with_alphabet_links
    assert_equal({"a" => nil, "b" => nil} , complete.links)
  end

  def test_it_can_add_a_letter_word
    complete.add_word("a")

    assert_equal "a", complete.links["a"].root
  end

  def test_it_recognizes_letter_as_a_word
    complete.add_word("a")

    assert complete.links["a"].word
  end

  def test_it_can_add_a_two_letter_word
    complete.add_word("ba")

    assert_equal "ba", complete.links["b"].links["a"].root
  end

  def test_when_it_adds_a_two_letter_word_it_adds_the_first_letter_as_word
    complete.add_word("ba")

    assert_equal "b", complete.links["b"].root
  end

  def test_it_recognizes_two_letter_word_as_word_but_not_first_letter
    complete.add_word("ba")

    refute complete.links["b"].word
    assert complete.links["b"].links["a"].word
  end

  def test_can_add_a_second_two_letter_word_with_same_first_letter
    complete.add_word("ba")
    complete.add_word("bb")

    assert_equal "bb", complete.links["b"].links["b"].root
  end

  def test_adding_a_second_two_letter_word_doesnt_mess_with_word_recognition
    complete.add_word("ba")
    complete.add_word("bb")

    assert complete.links["b"].links["b"].word
    assert complete.links["b"].links["a"].word
    refute complete.links["b"].word
  end

  def test_can_add_two_two_letter_words_with_different_first_letter
    complete.add_word("ba")
    complete.add_word("ab")

    assert_equal "ba", complete.links["b"].links["a"].root
    assert_equal "b", complete.links["b"].root
    assert_equal "a", complete.links["a"].root
    assert_equal "ab", complete.links["a"].links["b"].root
  end

  def test_can_zoom_to_given_two_letter_string
    complete.add_word("ba")

    assert_equal "ba", complete.zoom_to("ba").root
    assert_equal "b", complete.zoom_to("b").root
  end

  def test_it_can_add_a_longer_word
    complete.add_word("hello")

    assert_equal "hello", complete.zoom_to("hello").root
  end

  def test_it_recognizes_longer_words_as_words
    complete.add_word("hello")

    assert complete.zoom_to("hello").word
  end

end
