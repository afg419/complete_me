require 'pry'

class RevCompleteMe

  attr_accessor :root, :links, :associator, :dictionary

  def initialize(data = "")
    @root = data
    @links = {}
    @associator ={}
  end

  def insert(string, depth = 0)
    #we can remove the first if - then, leave self.root = string[0..depth-1]
    #concerned about speed, though (it basically means rewriting)
    if !root
      self.root = string[-depth..-1]
    end

    if depth == string.length
      self.root = string
    else
      links[string[-depth-1]] ||= RevCompleteMe.new(nil)
      links[string[-depth-1]].insert(string,depth + 1)
    end
  end

  def zoom_to(string)
    current = self
    chars = string.chars

    chars.reverse.each do |char|
      if current.links[char]
        current = current.links[char]
      else
        puts "Input fragment begins no words in library!"
        return nil
      end
    end
    current
  end

  def find_all_fragments(fragments = [])
    fragments << root

    links.keys.each do |char_key|
      links[char_key].find_all_fragments(fragments)
    end

    fragments
  end

  def suggest(fragment)
    if zoom_to(fragment)
      current = zoom_to(fragment)
      possible_words = current.find_all_fragments
    else
      []
    end
  end

  def populate(dictionary_file_handle)
    dictionary_file_handle.split("\n").each do |word|
      insert(word)
    end
  end

end
