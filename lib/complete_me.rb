require 'pry'


class NullWord

end


class CompleteMe

  attr_accessor :root, :links,:word?

  def initialize(data = nil)
    @root = data
    @links = {"a" => nil, "b" => nil}
  end

  def add_word(string, depth = 0)

    if !data && depth == (string.length - 1)
      data = string
      self.word = true
    elsif !data
      data = string[0..depth]
      links[depth] ||= CompleteMe.new
      links[depth].add_word(string,depth +1)
    elsif
      links[depth] ||= CompleteMe.new
      links[depth].add_word(string,depth + 1)
    end

  end



end
