require 'minitest_helper'


module TestMRUList

  MRUList = MRUList::MRUList

  class TestVersion < MiniTest::Unit::TestCase

    def test_that_it_has_a_version_number
      refute_nil ::MRUList::VERSION
    end

  end

  class TestLength < MiniTest::Unit::TestCase
    def setup
      @mrulist = MRUList.new(3)
    end

    def test_length
      3.times do
        @mrulist.promote 1
        assert_equal 1, @mrulist.length
      end

      3.times do
        @mrulist.promote 2
        assert_equal 2, @mrulist.length
      end

      3.times do
        @mrulist.promote 3
        assert_equal 3, @mrulist.length
      end

      3.times do
        @mrulist.promote 100
        assert_equal 3, @mrulist.length
      end
    end
  end

  class TestMRU < MiniTest::Unit::TestCase
    def setup
      @mrulist = MRUList.new(3)
    end

    def test_mru
      (1..10).each do |i|
        @mrulist.promote i
        assert_equal i, @mrulist.mru
      end
    end
  end

  class TestEnumerable < MiniTest::Unit::TestCase
    def setup
      @mrulist = MRUList.new(3)
      (1..10).each { |i| @mrulist.promote i }
    end

    def test_enumerable
      expected = [10, 9, 8]
      actual = @mrulist.map { |x| x }
      assert_equal expected, actual
    end
  end


  class TestPromote < MiniTest::Unit::TestCase

    ###
    # Runs before each test.
    def setup
      @added = nil
      @removed = nil
      @mrulist = MRUList.new(3,
                             onadd: lambda {|x| @added = x},
                             onremove: lambda {|x| @removed = x})
    end

    def assert_added(item)
      assert_equal item, @added
      @added = nil
    end

    def assert_removed(item)
      assert_equal item, @removed
      @removed = nil
    end

    def test_promote_onadd
      (1..5).each do |i|
        @mrulist.promote i
        assert_added i

        @mrulist.promote i
        assert_added nil # nothing new was added
      end
    end

    def test_promote_onremove
      (1..2*@mrulist.size).each do |i|
        @mrulist.promote i
        assert_added i

        @mrulist.promote i
        assert_added nil # nothing new was added

        if i > @mrulist.size
          assert_removed(i-@mrulist.size)
        end
      end
    end

    def test_promote
      items = [1, 2, 7, 2, 6, 4, 6]

      items.each { |i| @mrulist.promote i }

      list = @mrulist.map { |x| x }

      assert_equal [6,4,2], list
    end

  end

end
