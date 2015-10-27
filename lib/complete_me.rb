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

  def find_all_words
    
  end
  #
  # def suggest(string,output = [])
  #   current = zoom_to(string)
  #   binding.pry
  #   if current.word
  #     output << current.root
  #   end
  #   binding.pry
  #   current.links.keys.each do |char_key|
  #     binding.pry
  #     suggest(string+"char_key",output)
  #     binding.pry
  #   end
  #   output
  # end

end

completer = CompleteMe.new("")
completer.insert("hell")
completer.insert("heat")
p "suggest method: #{completer.suggest("h")}"
