# ruby187 on Windows Xp

# Builds the minimal fsa with final transitions representing the lexicographically sorted list of strings "dict.txt". Empty lines and duplicates are not allowed. 

words=IO.readlines("dict.txt")

class Node
	attr_accessor :edges
	
def initialize
	@edges=[] 
end

end#Node

class Fsa
	
def initialize
	@previous_wd=""
	@root= Node.new
	@stack=[@root]
	@register={} # holds the minimal fsa
end

def register_or_replace(limit=0)
1.upto(@stack.length) do |x|
if limit == (@stack.length - x)    then
break
else		
child=@stack[-x]
parent=@stack[-(x+1)]
if @register.has_key?(child.edges) then	
parent.edges[-1][1]=@register[child.edges]
else
@register[child.edges]=child
end #if @register
end#if limit
end#upto
@stack=@stack.slice(0 .. limit)
end

def insert(word)
# get the length ("cpl") of the longest common prefix.
cpl=0
(0 ... word.length).each{ |i|
word[i]==@previous_wd[i] ? cpl +=1 :  break
}
suffix=word[cpl .. -1] 
self.register_or_replace(cpl)
node=@stack[-1]
suffix.each_byte{|byte| 
next_node = Node.new
node.edges<<[byte, next_node]
@stack<<next_node
node=next_node
}
@stack[-2].edges[-1] << true # mark transition as final
@previous_wd=word
end

def insert_last_word
self.register_or_replace
@register[@root.edges]=@root
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
words.each{ |word| fsa.insert(word.strip) }
fsa.insert_last_word

puts "nodes: #{fsa.node_count.to_s}"
puts "edges: #{fsa.edge_count.to_s}"





  