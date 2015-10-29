require 'pry'
require_relative 'rev_complete_me'
require_relative 'for_complete_me'

class CompleteMe

  attr_accessor :for_complete, :rev_complete

  def initialize
    @for_complete = ForCompleteMe.new
    @rev_complete = RevCompleteMe.new
  end

  def insert(string)
    for_complete.insert(string)
  end

  def count
    for_complete.count
  end

  def suggest(fragment)
    for_complete.suggest(fragment)
  end

  def select(fragment,word,mode)
    for_complete.select(fragment,word)
  end

  def populate(file)
    for_complete.populate(file)
  end

  def for_complete_fragments #returns all fragments of the for_complete tree
    for_fragments = for_complete.find_all_fragments
  end

  def populate_rev_complete_by_array(array)
    array.each do |element|
      rev_complete.insert(element)
    end
  end

  def includes(fragment)
    results = []

    populate_rev_complete_by_array(for_complete_fragments)
    back_fragments_ending_with_fragment = rev_complete.suggest(fragment) #returns all fragments of forward tree ending with given fragment
    back_fragments_ending_with_fragment.each do |back_fragment|
      results += for_complete.suggest(back_fragment).to_a #finds all words of foward tree beginning with a fragment ending in given fragment
    end
    for_complete.sort_by_weights(fragment,results)
  end

end




# completer = ForCompleteMe.new("")
# completer.insert("hell")
# completer.insert("heat")
# completer.insert("he")
# p "suggest method: #{completer.find_all_words}"
# p completer.find_all_words[1]
# p completer.suggest("hel")
