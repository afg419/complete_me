require 'pry'



class CompleteMe

  attr_accessor :root, :links, :word, :associator

  def initialize(data = nil)
    @root = data
    @links = {}
    @associator ={}
  end

  def insert(string, depth = 0)

    if !root && depth == string.length
      self.root = string
      self.word = true
    elsif root == string
      self.word = true
    else
      if !root
        self.root = string[0..depth-1]
      end
      links[string[depth]] ||= CompleteMe.new
      links[string[depth]].insert(string,depth + 1)
    end


  end

  def zoom_to(string)
    current = self
    chars = string.chars

    chars.each do |char|
      current = current.links[char]
    end

    current
  end

  def find_all_words(words = [])

    if links.length == 0
      words << root
    else
      if word
        words << root
      end

      links.keys.each do |char_key|
        links[char_key].find_all_words(words)
      end

    end
    words
  end

  def count
    find_all_words.length
  end

  def suggest(fragment)
    current = zoom_to(fragment)
    possible_words = current.find_all_words
    sort_by_weights(fragment,possible_words)
  end

  def select(fragment,word)
    self.associator[[fragment,word]] ||= 0
    self.associator[[fragment,word]] += 1
  end

  def sort_by_weights(fragment,word_array)
    weighted = word_array.map do |word|
      [associator[[fragment,word]].to_i,word]
    end
    weighted = weighted.sort.reverse
    words = weighted.map do |value,word|
      word
    end
    words
  end


end

# completer = CompleteMe.new("")
# completer.insert("hell")
# completer.insert("heat")
# completer.insert("he")
# p "suggest method: #{completer.find_all_words}"
# p completer.find_all_words[1]
# p completer.suggest("hel")
