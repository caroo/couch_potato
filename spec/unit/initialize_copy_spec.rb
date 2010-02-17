require File.dirname(__FILE__) + '/../spec_helper'

class Tree
  include CouchPotato::Persistence
  property :branch
end

class Branch
  include CouchPotato::Persistence
  property :leaf_or_branch  
end

describe 'initialize_copy' do
  it "should deep clone itself" do
    branch_with_leaf = Branch.new :leaf_or_branch => "leaf"
    branch = Branch.new :leaf_or_branch => branch_with_leaf
    tree = Tree.new :branch => branch
    
    cloned_tree = tree.clone
    cloned_tree.branch.leaf_or_branch.leaf_or_branch.object_id.should_not eql(tree.branch.leaf_or_branch.leaf_or_branch.object_id)
  end
end