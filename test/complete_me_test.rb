require_relative '../lib/complete_me'
require 'minitest'
require 'pry'

class CompleteMeTest < Minitest::Test

  def test_class_exists
    assert CompleteMe.new
  end


end
