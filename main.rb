require_relative 'lib/tree'

test = Tree.new(Array.new(15) { rand(1..100) })

puts 'Initial tree:'
test.pretty_print
puts "Confirm that the tree is balanced: #{test.balanced?}"

puts "Level order: #{test.level_order_iter}"
puts "Pre order: #{test.preorder}"
puts "Post order: #{test.postorder}"
puts "In order: #{test.inorder}"

puts 'Unbalance the tree by adding 112, 129, 231, 229, 717, 727'
[112, 129, 231, 229, 717, 727].each { |val| test.insert(val) }

puts 'Tree after unbalancing inserts:'
test.pretty_print
puts "Confirm that the tree is unbalanced: #{test.balanced?}"

puts 'Balance the tree'
test.rebalance

puts 'Tree after rebalance:'
test.pretty_print
puts "Confirm that the tree is balanced: #{test.balanced?}"

puts "Level order: #{test.level_order_iter}"
puts "Pre order: #{test.preorder}"
puts "Post order: #{test.postorder}"
puts "In order: #{test.inorder}"
