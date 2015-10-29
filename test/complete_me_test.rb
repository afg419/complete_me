require_relative '../lib/complete_me'
require 'minitest'

class CompleteMeTest < Minitest::Test

  def test_exists
    assert CompleteMe

  end

  def test_initializes_with_for_and_rev_completers
    complete = CompleteMe.new

    assert_equal ForCompleteMe, complete.for_complete.class
    assert_equal RevCompleteMe, complete.rev_complete.class
  end

  def test_can_insert_words_to_for_complete_tree
    complete = CompleteMe.new
    complete.insert("hello")

    assert_equal "hello", complete.for_complete.zoom_to("hello").root
  end

  def test_can_extract_all_for_complete_fragments
    complete = CompleteMe.new
    complete.insert("hello")
    complete.insert( "mean")
    expected = (%w{ hello hell hel he h mean mea me m } + [""]).sort

    assert_equal expected, complete.for_complete_fragments.sort
  end


  def test_can_find_single_word_containing_fragment
    complete = CompleteMe.new
    complete.insert("hello")

    assert_equal ["hello"], complete.includes("el")
  end

  def test_can_find_single_word_when_fragment_is_word
    complete = CompleteMe.new
    complete.insert("hello")

    assert_equal ["hello"], complete.includes("hello")
  end

  def test_can_find_single_word_with_other_words_added
    complete = CompleteMe.new
    complete.insert("hello")
    complete.insert("cess")

    assert_equal ["hello"], complete.includes("ll")
  end

  def test_can_find_two_words
    complete = CompleteMe.new
    complete.insert("hello")
    complete.insert("jelly")

    assert_equal ["hello","jelly"], complete.includes("ell")

  end

  def test_can_find_words_when_fragment_at_start
    complete = CompleteMe.new
    complete.insert("hello")

    assert_equal ["hello"], complete.includes("he")
  end

  def test_can_find_words_when_fragment_at_end
    complete = CompleteMe.new
    complete.insert("hello")

    assert_equal ["hello"], complete.includes("lo")
  end

  def test_can_find_all_the_damn_words
    complete = CompleteMe.new
    complete.populate("hello\ngoodbye\nhe\nshe\nit\ni\na\nbanana")

    assert_equal ["hello", "goodbye", "he", "she"].sort, complete.includes("e").sort

  end

  def test_can_find_all_the_damn_word_medium_amount_of_words
    complete = CompleteMe.new
    complete.populate(medium_word_list)
    expected = medium_word_list.split("\n").select{|x| x.include?("cy")}
    puts expected
    assert_equal expected.sort, complete.includes("cy").sort
  end

  def medium_word_list
    File.read("./test/medium.txt")
  end

end
