


class CompleteMe

  attr_accessor :root, :links, :word, :associator

  def initialize(data = "")
    @root = data
    @links = {}
    @associator ={}
  end

  def insert(string, depth = 0)

    if depth == string.length
      self.root = string
    end

    if root == string
      self.word = true
    else
      if !root
        self.root = string[0..depth-1]
      end
      links[string[depth]] ||= CompleteMe.new(nil)
      links[string[depth]].insert(string,depth + 1)
    end

  end

  def zoom_to(string)
    #if string isn't in the library, raise error

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
    words - [""]
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
    # if fragment not in word, raise error
    if word[0..fragment.length-1] == fragment
      self.associator[[fragment,word]] ||= 0
      self.associator[[fragment,word]] -= 1
    else
      puts "Input fragment doesn't begin input word!"
    end
  end

  def sort_by_weights(fragment,word_array)
    weighted = word_array.sort_by{|word| [associator[[fragment,word]].to_i,word] }
  end

  def populate(dictionary_file_handle)
    dictionary_file_handle.split("\n").each do |word|
      insert(word)
    end
  end


end

# completer = CompleteMe.new("")
# completer.insert("hell")
# completer.insert("heat")
# completer.insert("he")
# p "suggest method: #{completer.find_all_words}"
# p completer.find_all_words[1]
# p completer.suggest("hel")
