require_relative 'node'

class Tree
  attr_accessor :root

  def initialize(nodes = [])
    @root = build_tree(nodes)
  end

  def build_tree(nodes)
    return nil if nodes.empty?

    nodes.sort!
    nodes.uniq!

    m = nodes.length / 2
    root = Node.new(nodes[m])
    root.left = build_tree(nodes[0...m])
    root.right = build_tree(nodes[(m + 1)..-1])
    root
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  def insert(data)
    if @root.nil?
      @root = Node.new(data)
      return
    end

    p = @root

    loop do
      return if data == p.data

      if data < p.data
        if p.left.nil?
          p.left = Node.new(data)
          return
        end
        p = p.left
      else
        if p.right.nil?
          p.right = Node.new(data)
          return
        end
        p = p.right
      end
    end
  end

  def delete(node, data)
    return if node.nil?

    if data < node.data
      node.left = delete(node.left, data)
    elsif data > node.data
      node.right = delete(node.right, data)
    else
      return node.right if node.left.nil?
      return node.left if node.right.nil?

      min_node = node.right
      min_node = min_node.left while min_node.left
      node.data = min_node.data
      node.right = delete(node.right, min_node.data)
    end
    node
  end

  def find(data)
    p = @root
    while p
      return p if p.data == data

      p = if data < p.data
            p.left
          else
            p.right
          end
    end
    nil
  end

  def level_order_iter
    return [] if root.nil?

    queue = [@root]
    res = []
    until queue.empty?
      node = queue.shift
      yield(node) if block_given?
      res << node.data
      queue << node.left if node.left
      queue << node.right if node.right
    end
    res
  end

  def level_order_recur(queue = [@root], res = [], &block)
    return res if @root.nil?
    return res if queue.empty?

    node = queue.shift
    block.call(node) if block
    res << node.data
    queue << node.left if node.left
    queue << node.right if node.right
    level_order_recur(queue, res, &block)
  end

  def inorder(node = @root, res = [], &block)
    return res if node.nil?

    res = inorder(node.left, res, &block)
    block.call(node) if block
    res << node.data
    res = inorder(node.right, res, &block)
  end

  def preorder(node = @root, res = [], &block)
    return res if node.nil?

    block.call(node) if block
    res << node.data
    res = preorder(node.left, res, &block)
    res = preorder(node.right, res, &block)
  end

  def postorder(node = @root, res = [], &block)
    return res if node.nil?

    res = postorder(node.left, res, &block)
    res = postorder(node.right, res, &block)
    block.call(node) if block
    res << node.data
  end

  def height(data)
    node = find(data)
    return nil if node.nil?

    node_height(node)
  end

  def node_height(node)
    return -1 if node.nil?

    [node_height(node.left), node_height(node.right)].max + 1
  end

  def depth(data)
    p = @root
    res = 0
    until p.nil?

      return res if p.data == data

      p = if data < p.data
            p.left
          else
            p.right
          end
      res += 1
    end
    nil
  end

  def balanced?(node = @root)
    return true if node.nil?

    (node_height(node.left) - node_height(node.right)).abs <= 1 && balanced?(node.left) && balanced?(node.right)
  end

  def rebalance
    arr = level_order_iter
    @root = build_tree(arr)
  end
end
