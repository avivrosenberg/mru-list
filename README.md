mru-list
========

Gem for maintaining a most-recently-used items list, with convenient hooks.

### Usage Example

```ruby
require 'mru-list'

# Create an MRUList of size 3, with a callback for when an item is removed.
mrulist = MRUList::MRUList.new(3, onremove: lambda {|x| puts "Removed #{x}!"})

mrulist.promote 1 # [1]
mrulist.promote 2 # [2,1]
mrulist.promote 3 # [3,2,1]
mrulist.promote 4 # => Removed 1!
mrulist.promote 3 # [3,4,2]
```
