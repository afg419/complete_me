require 'pry'


class NullWord

end


class CompleteMe

  attr_accessor :root, :links, :word

  def initialize(data = nil)
    @root = data
    @links = {}
  end

  def insert(string, depth = 0)

    if !root && depth == (string.length)
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

  def suggest(string)
    current = zoom_to(string)
    current.find_all_words
  end

end

completer = CompleteMe.new("")
completer.insert("hell")
completer.insert("heat")
completer.insert("he")
p "suggest method: #{completer.find_all_words}"
p completer.find_all_words[1]
p completer.suggest("hel")
