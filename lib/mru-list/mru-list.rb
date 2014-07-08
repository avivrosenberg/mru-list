module MRUList

  ###
  # Small utility class to manage most-recently-used items.
  class MRUList
    include Enumerable

    NOP = lambda { |x| }

    attr_reader :size

    ###
    # size - number of recently used items to keep
    # onadd - Proc to run when a new item is added to the MRU list
    # onremove - Proc to run when an existing item is removed from the MRU list
    # onpromote - Proc to run when an existing item is promoted to the front of the MRU list
    def initialize(size, callbacks = {onadd: nil, onremove: nil, onpromote: nil})
      @size = size
      @list = []

      # default the callbacks to no-op
      @onadd = callbacks[:onadd] || NOP
      @onremove = callbacks[:onremove] || NOP
      @onpromote = callbacks[:onpromote] || NOP
    end

    ###
    # Promotes the given item to the top of the MRU list.
    # If it's a new item, and the MRU list is full, the least used item will be removed.
    # Returns the promoted item.
    def promote(item)

      # already in list? need to promote
      if idx = @list.index(item)
        # move to top of MRU list
        @list.delete_at idx
        @list.unshift item
        @onpromote.call(item)
        return item
      else

        if @list.length == @size
          # remove the least-recently-used and invoke callback
          lru = @list.pop
          @onremove.call(lru)
        end

        # add the new item as the mru
        @list.unshift item
        @onadd.call(item)
      end

      return item
    end

    ###
    # Returns the most recently used item in the MRU list.
    def mru
      @list.first
    end

    ###
    # Returns the least recently used item in the MRU list.
    def lru
      @list.last
    end

    ###
    # Number of current MRU items
    def length
      @list.length
    end

    ###
    # Enumerate like a normal list
    def each(&block)
      @list.each(&block)
    end
  end
end
