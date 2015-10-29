require 'pry'
require_relative 'rev_complete_me'

class ForCompleteMe

  attr_accessor :root, :links, :word, :associator

  def initialize(data = "")
    @root = data
    @links = {}
    @associator ={}
  end

  def insert(string, depth = 0)
    #we can remove the first if - then, leave self.root = string[0..depth-1]
    #concerned about speed, though (it basically means rewriting)
    if !root
      self.root = string[0..depth-1]
    end

    if depth == string.length
      self.root, self.word = string, true
    else
      links[string[depth]] ||= ForCompleteMe.new(nil)
      links[string[depth]].insert(string,depth + 1)
    end
  end

  def zoom_to(string)
    current = self
    chars = string.chars

    chars.each do |char|
      if current.links[char]
        current = current.links[char]
      else
        puts "Input fragment begins no words in library!"
        return nil
      end
    end
    current
  end

  def find_all_words(words = [])
    if word
      words << root
    end

    links.keys.each do |char_key|
      links[char_key].find_all_words(words)
    end

    words
  end

  def count
    find_all_words.length
  end

  def suggest(fragment)
    if zoom_to(fragment)
      current = zoom_to(fragment)
      possible_words = current.find_all_words
      sort_by_weights(fragment,possible_words)
    end
  end

  def select(fragment,word)
    if word[0..fragment.length-1] == fragment
      self.associator[[fragment,word]] ||= 0
      self.associator[[fragment,word]] -= 1
    else
      puts "Input fragment doesn't begin input word!"
    end
  end

  def sort_by_weights(fragment,word_array)
    weighted = word_array.sort_by{|word| [associator[[fragment,word]].to_i, word] }
  end

  def populate(dictionary_file_handle)
    dictionary_file_handle.split("\n").each do |word|
      insert(word)
    end
  end

  def find_all_fragments(fragments = [])
    fragments << root

    links.keys.each do |char_key|
      links[char_key].find_all_fragments(fragments)
    end

    fragments
  end


  # def included_by(fragment, words = [])
  #   if word && root.include?(fragment)
  #     words << root
  #   end
  #
  #   links.keys.each do |char_key|
  #     links[char_key].included_by(fragment, words)
  #   end
  #   sort_by_weights(fragment,words)
  # end
  #
  # def included_by2(fragment, words = [])
  #   words += suggest(fragment)
  #   15.times do
  #     shorter = delete_each_node_first_char
  #     shorter.insert(fragment)
  #     words += shorter.suggest(fragment)
  #   end
  # end
  #
  # def delete_each_node_first_char
  #   self.root = self.root[1..-1] if !root.nil?
  #
  #   links.keys.each do |char_key|
  #     links[char_key].delete_each_node_first_char
  #   end
  #   self
  # end

end




# completer = ForCompleteMe.new("")
# completer.insert("hell")
# completer.insert("heat")
# completer.insert("he")
# p "suggest method: #{completer.find_all_words}"
# p completer.find_all_words[1]
# p completer.suggest("hel")
