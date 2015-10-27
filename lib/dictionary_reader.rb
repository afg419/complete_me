

class DictionaryReader

  def initialize(dictionary_file)
    @dictionary = File.open(dictionary_file, 'r')
  end  

end
