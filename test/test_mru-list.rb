require 'minitest_helper'

class TestMRUList < MiniTest::Unit::TestCase

  def test_that_it_has_a_version_number
    refute_nil MRUList::VERSION
  end

end
