require_relative '../lib/rev_complete_me'
require 'minitest'

class RevCompleteMeTest < Minitest::Test

  attr_reader :complete

  def setup
    @complete = RevCompleteMe.new
  end

  def test_it_exists
    assert RevCompleteMe.new
  end

  def test_it_initializes_with_empty_string_data
    assert_equal "", complete.root
  end

  def test_it_can_initialize_with_data
    completed = RevCompleteMe.new("hello")
    assert_equal "hello" , completed.root
  end

  def test_it_can_initialize_with_nil
    completed = RevCompleteMe.new(nil)
    refute completed.root
  end

  def test_it_begins_with_no_alphabet_links
    assert_equal({} , complete.links)
  end

  def test_it_can_add_a_letter_word
    complete.insert("a")
    assert_equal "a", complete.links["a"].root
  end


  def test_it_can_add_a_two_letter_word
    complete.insert("ba")
    assert_equal "ba", complete.links["a"].links["b"].root
  end

  def test_when_it_adds_a_two_letter_word_it_adds_the_first_letter_fragment
    complete.insert("ba")
    assert_equal "a", complete.links["a"].root
    refute complete.links["b"]
  end

  def test_can_add_a_second_two_letter_word_with_same_last_letter
    complete.insert("ba")
    complete.insert("bb")

    assert_equal "bb", complete.links["b"].links["b"].root
    assert_equal "ba", complete.links["a"].links["b"].root
  end

  def test_can_add_two_two_letter_words_with_different_first_letter
    complete.insert("ba")
    complete.insert("ab")

    assert_equal "ba", complete.links["a"].links["b"].root
    assert_equal "b", complete.links["b"].root
    assert_equal "a", complete.links["a"].root
    assert_equal "ab", complete.links["b"].links["a"].root
  end

  def test_can_zoom_to_given_two_letter_string
    complete.insert("ba")

    assert_equal "ba", complete.zoom_to("ba").root
    assert_equal "a", complete.zoom_to("a").root
  end

  def test_it_can_add_a_longer_word
    complete.insert("hello")

    assert_equal "hello", complete.links["o"].links["l"].links["l"].links["e"].links["h"].root
  end

  def test_it_can_zoom_to_longer_word
    complete.insert("hello")

    assert_equal "hello", complete.zoom_to("hello").root
  end

  def test_it_raises_an_error_if_you_try_to_zoom_to_word_not_in_dictionary
    refute (complete.zoom_to("hello"))
  end

  def test_it_does_not_add_more_nodes_than_expected_when_large_word_added
    complete.insert("amazing")
    assert_equal({},complete.zoom_to("amazing").links)
  end

  def test_it_populates_all_word_fragments_when_longer_words_inserted
    complete.insert("hello")

    assert_equal "ello", complete.zoom_to("ello").root
    assert_equal "llo", complete.zoom_to("llo").root
    assert_equal "lo", complete.zoom_to("lo").root
    assert_equal "o", complete.zoom_to("o").root
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


  end

  def test_it_adds_all_fragments_when_it_adds_bunches_of_words
    words = %w{hello lobo aleph leaf leaven leave}
    words.each do |word|
      complete.insert(word)
    end

    assert_equal "eph", complete.zoom_to("eph").root
    assert_equal "en", complete.zoom_to("en").root
    assert_equal "o", complete.zoom_to("o").root
    assert_equal "af", complete.zoom_to("af").root
    assert_equal "llo", complete.zoom_to("llo").root
    assert_equal "eaven", complete.zoom_to("eaven").root
  end

  def test_it_can_find_all_entered_fragments
    words = %w{hello hire goodbye style}
    words.each do |word|
      complete.insert(word)
    end
    expected = (words + [""] + %w{ ello llo lo o ire re oodbye odbye dbye bye ye tyle yle le e }).sort

    assert_equal expected, complete.find_all_fragments.sort

  end

  def test_it_can_suggest_fragments_from_non_word_fragment
    words = %w{leaven leaves shallow tallow hallowed hallow hall allow}
    words.each do |word|
      complete.insert(word)
    end
    expected = %w{shallow hallow llow allow low tallow}.sort
    computed = complete.suggest("low").sort

    assert_equal expected, computed
  end

  def test_it_raises_an_error_if_you_suggest_word_fragment_not_in_library
    words = %w{leaven leave leaves hallowed hallow hall allow}
    words.each do |word|
      complete.insert(word)
    end

    refute complete.suggest("ham")
  end


  def test_it_populates_words
    complete.populate("hello\ngoodbye\nhe\nshe\nit\ni\na\nbanana")
    assert_equal "hello", complete.zoom_to("hello").root
    assert_equal "she", complete.zoom_to("she").root
  end


end
