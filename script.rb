#Has an attribute for the data it stores, its right child, and its left child
#Try including Comparable module and comparing nodes using their data attribute
class Node
  attr_accessor :data, :left, :right

  def initialize(data)
    #Holds the value in this node
    @data = data

    #Holds the values of the right/left child nodes of this node
    @left = nil
    @right = nil
  end

end

class Tree

  attr_accessor :array, :root

  def initialize(array)
    @array = array.sort.uniq
    @root = build_tree(@array, 0, @array.length)
  end

  def build_tree(array, start_index, end_index)

    #Base case
    if start_index > end_index
      return nil
    end

    middle_index = (start_index + end_index) / 2
    node = Node.new(array[middle_index])
    if array[start_index..(middle_index - 1)].length >= 1
      node.left = build_tree(array, start_index, middle_index - 1)
    end
    if array[(middle_index + 1)..end_index].length >= 1
      node.right = build_tree(array, middle_index + 1, end_index)
    end
    return node

  end


  #Inserts a value as a new leaf of the tree
  def insert(value, node = @root)

    if value == node.data
      puts "Invalid input, no duplicates allowed!"
      return
    elsif value < node.data
      if node.left
        insert(value, node.left)
      else
        node.left = Node.new(value)
      end
    elsif value > node.data
      if node.right
        insert(value, node.right)
      else
        node.right = Node.new(value)
      end
    end

  end


  #Deletes a given value from the tree
  def delete(value, node = @root)

    if value == node.data

      if (node.left == nil) && (node.right == nil)
        node.data = nil
        return node
      elsif node.left && node.right == nil
        node.data = node.left.data
        node.left.data = nil
        if node.left.left || node.left.right
          node.left = node.left.left
          node.right = node.left.right
        end
        return node
      elsif node.left == nil && node.right
        node.data = node.right.data
        node.right.data = nil
        if node.right.left || node.right.right
          node.left = node.right.left
          node.right = node.right.right
        end
        return node
      elsif node.left && node.right
        right_child = node.right
        inorder_successor = find_inorder_successor(right_child)
        node.data = inorder_successor.data
        inorder_successor.data = nil
        if inorder_successor.right
          node.left = inorder_successor.right
        end
        return node
      end

    elsif value < node.data
      delete(value, node.left)
    elsif value > node.data
      delete(value, node.right)
    end
  end


  #Finds the inorder successor of a node. Takes the right child of that node as its parameter.
  def find_inorder_successor(right_child)
    if right_child.left
      find_inorder_successor(right_child.left)
    else
      return right_child
    end
  end


  #Finds and returns the node in the tree that contains a given value
  #Doesn't have to search the whole tree - goes right or left depending on
  #whether the value is greater or smaller than the data in the node being evaluated
  def find(value, node = @root)
    if value == node.data
      puts "Found node #{node} with value #{value}"
      p node
      return node
    elsif value < node.data
      if node.left
        find(value, node.left)
      else
        puts "Node not found!"
        return nil
      end
    elsif value > node.data
      if node.right
        find(value, node.right)
      else
        puts "Node not found!"
        return nil
      end
    end
  end

  #Traverses the tree in level order
  #Yields each node to a block
  #If no block is given, returns an array of the values of the nodes
  def level_order(node = @root, queue = [node], data_array = [], &block)

    if block_given?
      block.call queue[0]
      queue.push(queue[0].left) if queue[0].left
      queue.push(queue[0].right) if queue[0].right
      queue.shift

      level_order(node.left, queue, data_array, &block) if node.left
      level_order(node.right, queue, data_array, &block) if node.right
    else
      data_array.push(queue[0].data)
      queue.push(queue[0].left) if queue[0].left
      queue.push(queue[0].right) if queue[0].right
      queue.shift

      level_order(node.left, queue, data_array, &block) if node.left
      level_order(node.right, queue, data_array, &block) if node.right

      return data_array
    end

  end

  #Performs inorder traversal of the tree
  #Yields each node to a block
  #Returns an array of values if no block is given
  def inorder(node = @root, data_array = [], &block)
    if node == nil
      return
    end

    if node.left
      inorder(node.left, data_array, &block)
    end

    if block_given?
      block.call(node)
    else
      data_array.push(node.data)
    end

    if node.right
      inorder(node.right, data_array, &block)
    end

    unless data_array.empty?
      return data_array
    end

  end


  #Performs preorder traversal of the tree
  #Yields each node to a block
  #Returns an array of values if no block is given
  def preorder(node = @root, data_array = [], &block)
    if node == nil
      return
    end

    if block_given?
      block.call node
    else
      data_array.push(node.data)
    end

    preorder(node.left, data_array, &block)
    preorder(node.right, data_array, &block)

    unless data_array.empty?
      return data_array
    end
  end

  #Performs postorder traversal of tree
  #Yields each node to a block
  #Returns an array of values if no block is given
  def postorder(node = @root, data_array = [], &block)
    if node == nil
      return
    end

    postorder(node.left, data_array, &block)
    postorder(node.right, data_array, &block)

    if block_given?
      block.call node
    else
      data_array.push(node.data)
    end

    unless data_array.empty?
      return data_array
    end

  end

  #Finds the height of the tree
  def height(node = @root)

    if node == nil
      return -1
    end

    left_height = height(node.left)
    right_height = height(node.right)

    if left_height > right_height
      return (left_height + 1)
    else
      return (right_height + 1)
    end

  end


  #Finds the depth of a node
  def depth(value, node = @root)
    if node == nil
      return -1
    end

    distance = -1

    if ((node.data == value) || (distance = depth(value, node.left)) >= 0 || (distance = depth(value, node.right)) >= 0)
      return distance + 1
    end

    return distance
  end

  #Returns true if the tree is balanced and false if it is not
  #A balanced tree is one where the heights of the left and right subtrees
  #for every node differ by no more than 1.
  def balanced?(node = @root)
    if node == nil
      return true
    end

    left_height = height(node.left)
    right_height = height(node.right)

    difference = left_height - right_height

    if ((difference).abs <= 1) && balanced?(node.left) && balanced?(node.right)
      return true
    else
      return false
    end

  end

  #Rebalances an unbalanced tree
  #Uses a traversal method to provide a new array to the build_tree method
  def rebalance
    data_array = inorder
    @root = build_tree(data_array, 0, data_array.length)
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

end


tree = Tree.new(Array.new(15) {rand(1..100)} )
tree.pretty_print
puts "Tree balanced? #{tree.balanced?}"

puts "Level order traversal:"
tree.level_order { |node| p node.data }

puts "Inorder traversal:"
tree.inorder { |node| p node.data}

puts "Preorder traversal:"
tree.preorder { |node| p node.data}

puts "Postorder traversal:"
tree.postorder { |node| p node.data}

tree.insert(rand(1..100))
tree.insert(rand(1..100))
tree.insert(rand(1..100))
tree.insert(rand(1..100))
tree.insert(rand(1..100))
tree.insert(rand(1..100))
tree.insert(rand(1..100))
tree.insert(rand(1..100))
tree.insert(rand(1..100))
tree.insert(rand(1..100))
tree.insert(rand(1..100))
tree.insert(rand(1..100))
tree.insert(rand(1..100))
tree.insert(rand(1..100))
tree.insert(rand(1..100))
tree.insert(rand(1..100))
tree.insert(rand(1..100))
tree.insert(rand(1..100))
tree.pretty_print

puts "Tree balanced? #{tree.balanced?}"

tree.rebalance
tree.pretty_print
puts "Tree balanced? #{tree.balanced?}"

puts "Level order traversal:"
tree.level_order { |node| p node.data }

puts "Inorder traversal:"
tree.inorder { |node| p node.data}

puts "Preorder traversal:"
tree.preorder { |node| p node.data}

puts "Postorder traversal:"
tree.postorder { |node| p node.data}