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
    assert_equal({} , complete.links)
  end

  def test_it_can_add_a_letter_word
    complete.insert("a")

    assert_equal "a", complete.links["a"].root
  end

  def test_it_recognizes_letter_as_a_word
    complete.insert("a")

    assert complete.links["a"].word
  end

  def test_it_can_add_a_two_letter_word
    complete.insert("ba")

    assert_equal "ba", complete.links["b"].links["a"].root
  end

  def test_when_it_adds_a_two_letter_word_it_adds_the_first_letter_as_word
    complete.insert("ba")

    assert_equal "b", complete.links["b"].root
  end

  def test_it_recognizes_two_letter_word_as_word_but_not_first_letter
    complete.insert("ba")

    refute complete.links["b"].word
    assert complete.links["b"].links["a"].word
  end

  def test_can_add_a_second_two_letter_word_with_same_first_letter
    complete.insert("ba")
    complete.insert("bb")

    assert_equal "bb", complete.links["b"].links["b"].root
  end

  def test_adding_a_second_two_letter_word_doesnt_mess_with_word_recognition
    complete.insert("ba")
    complete.insert("bb")

    assert complete.links["b"].links["b"].word
    assert complete.links["b"].links["a"].word
    refute complete.links["b"].word
  end

  def test_can_add_two_two_letter_words_with_different_first_letter
    complete.insert("ba")
    complete.insert("ab")

    assert_equal "ba", complete.links["b"].links["a"].root
    assert_equal "b", complete.links["b"].root
    assert_equal "a", complete.links["a"].root
    assert_equal "ab", complete.links["a"].links["b"].root
  end

  def test_can_zoom_to_given_two_letter_string
    complete.insert("ba")

    assert_equal "ba", complete.zoom_to("ba").root
    assert_equal "b", complete.zoom_to("b").root
  end

  def test_it_can_add_a_longer_word
    complete.insert("hello")

    assert_equal "hello", complete.links["h"].links["e"].links["l"].links["l"].links["o"].root
  end

  def test_it_can_zoom_to_longer_word
    complete.insert("hello")

    assert_equal "hello", complete.zoom_to("hello").root
  end

  def test_it_recognizes_longer_words_as_words
    complete.insert("hello")

    assert complete.zoom_to("hello").word
  end

  def test_it_populates_all_word_fragments_with_longer_words
    complete.insert("hello")

    assert_equal "hell", complete.zoom_to("hell").root
    assert_equal "hel", complete.zoom_to("hel").root
    assert_equal "he", complete.zoom_to("he").root
    assert_equal "h", complete.zoom_to("h").root
  end

  def test_word_fragments_of_longer_words_not_words
    complete.insert("hello")

    refute complete.zoom_to("hell").word
    refute complete.zoom_to("hel").word
    refute complete.zoom_to("he").word
    refute complete.zoom_to("h").word
  end

  def test_word_fragments_of_longer_words_not_words_even_if_they_are
    complete.insert("leaven")

    assert complete.zoom_to("leaven").word
    refute complete.zoom_to("leave").word
  end

  def test_word_fragments_of_longer_words_not_words_until_they_are_added
    complete.insert("leaven")
    refute complete.zoom_to("leave").word
    complete.insert("leave")
    assert complete.zoom_to("leave").word
  end

  def test_it_adds_bunches_of_words
    words = %w{hello lobo aleph leaf leaven leave}
    words.each do |word|
      complete.insert(word)
    end

    assert_equal "hello", complete.zoom_to("hello").root
    assert_equal "leave", complete.zoom_to("leave").root
    assert_equal "lobo", complete.zoom_to("lobo").root
    assert_equal "aleph", complete.zoom_to("aleph").root
    assert_equal "leaf", complete.zoom_to("leaf").root
    assert_equal "leaven" , complete.zoom_to("leaven").root
    assert_equal "ale", complete.zoom_to("ale").root
    assert_equal "le", complete.zoom_to("le").root
    assert_equal "l", complete.zoom_to("l").root

  end

  def test_it_recognizes_words_amongst_bunches_of_words
    words = %w{hello lobo aleph leaf leaven leave}
    words.each do |word|
      complete.insert(word)
    end

    assert complete.zoom_to("hello").word
    assert complete.zoom_to("leave").word
    assert complete.zoom_to("lobo").word
    assert complete.zoom_to("aleph").word
    assert complete.zoom_to("leaf").word
    assert complete.zoom_to("leaven").word
    refute complete.zoom_to("ale").word
    refute complete.zoom_to("le").word
    refute complete.zoom_to("l").word

  end

  def test_it_can_find_all_words_no_fragment_words
    words = %w{hello, hire, goodbye, style}
    words.each do |word|
      complete.insert(word)
    end

    assert_equal words, complete.find_all_words

  end

  def test_it_can_find_all_words_with_fragment_words
    words = %w{leaven leave leaves hallowed hallow hall allow}
    words.each do |word|
      complete.insert(word)
    end

    assert_equal words.sort, complete.find_all_words.sort

  end

  def test_it_can_count_words
    words = %w{leaven leave leaves hallowed hallow hall allow}
    words.each do |word|
      complete.insert(word)
    end

    assert_equal 7, complete.count
  end

  def test_it_can_suggest_words_from_non_word_fragment
    words = %w{leaven leave leaves hallowed hallow hall allow}
    words.each do |word|
      complete.insert(word)
    end
    expected = %w{leaven leave leaves}.sort
    computed = complete.suggest("lea")

    assert_equal expected, computed
  end

  def test_it_can_suggest_words_from_word_fragment
    words = %w{leaven leave leaves hallowed hallow hall allow}
    words.each do |word|
      complete.insert(word)
    end
    expected = %w{leaven leave leaves}.sort
    computed = complete.suggest("leave")

    assert_equal expected, computed
  end

end
