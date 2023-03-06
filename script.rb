#Has an attribute for the data it stores, its right child, and its left child
#Try including Comparable module and comparing nodes using their data attribute
class Node
  attr_accessor :data, :left_child_data, :right_child_data

  def initialize(data)
    @data = data
    @left_child_data = nil
    @right_child_data = nil
  end


end

class Tree

  def initialize(array)
    array = array.sort!.uniq!
    @root = build_tree(array)
  end


  #Here's my main function that builds the balanced binary search tree
  def build_tree(array, level = 0)
    puts "level: #{level}"
    #My base case: if array.length == 1 it's a leaf and we are done
    puts "array: #{array}"
    middle_index = array.length / 2
    puts "middle index: #{middle_index}"
    new_node = Node.new(array[middle_index])
    puts "new node data level #{level}: #{new_node.data}"

    #If the array can still be split, call build_tree on it again
    if array.length > 1
      left_array = array[0..(middle_index - 1)]
      right_array = array[(middle_index + 1)..(-1)]

      if left_array.length >= 1
        new_node.left_child_data = build_tree(left_array, level + 1)
        puts "new node left child data level #{level}: #{new_node.left_child_data}"
      end

      if right_array.length >= 1
        new_node.right_child_data = build_tree(right_array, level + 1)
        puts "new node right child data level #{level}: #{new_node.right_child_data}"
      end
    end

    return new_node.data

  end

end

tree = Tree.new([2, 4, 8, 1, 8, 3, 7, 6, 2, 5, 3])