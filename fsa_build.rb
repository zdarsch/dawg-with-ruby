#encoding: Windows-1251
Encoding.default_external="Windows-1251"

# Builds the minimal fsa with final transitions representing a lexicographically sorted list of strings. Empty lines or repetitions are not allowed. Tested with  Ruby 274 on Windows 10.

words=IO.readlines("dict.txt")

class String
def cplen(str)
count=0
(0 ... str.length).each{ |i|
self[i]==str[i] ? count +=1 :  break
}
return count
end#def
end#class

class Node
	attr_accessor :edges
	
def initialize
	@edges=[] 
end

end#Node

class Fsa
	
def initialize
	@prev_word=""
	@root= Node.new
	@prev_path=[@root] #array of nodes
	@register={} 
end



def minimize_downto(limit)
a=@prev_path	
(a.length - 1 ).downto(limit)do |x|
if @register.has_key?(a[x].edges) then
#replace	
a[x-1].edges[-1][1]=@register[a[x].edges]
else
#register
@register[a[x].edges]=a[x]
end #if
end#downto
end#def

# @prev_path is the path recognizing prev_word in the fsa under construction. Thus, in @prev_path the last edge of each node points to the next node, the last edge of the path is marked as final and the labels are the characters (or bytes) of prev_word.

# When next_word has been added and cpl, the length of the longest common prefix, has been determined, the subarray @prev_path[0 .. cpl] is the path of the longest common prefix.

# We then  know from the lexicographic ordering of the words that the nodes of @prev_path[cpl+1 .. -1] will never get any other child. So, these nodes are now ready to be registered (or replaced as the case may be) according to the following principle: register a node once all its children have been registered. 

# The next step is to update @prev_word and @prev_path to prepare  the insertion of yet another word.The path of the longest common prefix is unchanged except for its last node ( @prev_path[cpl])which gets a new edge labeled next_word[cpl]. 



def insert(word)
cpl=@prev_word.cplen(word)
minimize_downto(cpl+1) 
# update @prev_word
@prev_word=word
# update @prev_path
@prev_path.slice!( cpl+1 .. -1)
node=@prev_path[cpl]
suffix=word[cpl .. -1] 
suffix.each_byte do |byte| 
next_node = Node.new
node.edges<<[byte, next_node]
@prev_path<<next_node
node=next_node
end
@prev_path[-2].edges[-1] << true # mark transition as final
end

def insert_last_word
# 0 instead of 1, to register @root at the same time:  
minimize_downto(0)
end

def node_count
@register.length
end

def edge_count
count=0
@register.values.each{|node|
count += node.edges.length
}
return count
end

end#Fsa

fsa=Fsa.new
words.each{|word| fsa.insert(word.chomp) }
fsa.insert_last_word

puts "nodes: #{fsa.node_count}"
puts "edges: #{fsa.edge_count}"



  
