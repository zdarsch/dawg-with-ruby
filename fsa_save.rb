# ruby187 on Windows Xp

# Builds and serializes the minimal fsa with final transitions representing the lexicographically sorted list of strings "dict.txt". Empty lines and duplicates are not allowed. 

# The serialization is adapted to our use cases: 4 bytes (at most) are used to represent an edge.

words=IO.readlines("dict.txt") 
f= File.open("dict.fsa", 'wb')


class Node
	attr_accessor :edges, :idx
def initialize
	@edges=[]
end

end# Node

class Fsa
	
def initialize
	@previous_wd=""
	@root= Node.new
	@stack=[@root]
	@register={}
	@a=[] # holds the nodes in their registration order
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
@a<< child# 
@register[child.edges]=child
end #if @register
end#if limit
end#upto
@stack=@stack.slice(0 .. limit)
end #register_or_replace

def insert(word)
# get the length("cpl") of the longest common prefix.
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
end#insert

def insert_last_word
self.register_or_replace
@register[@root.edges]=@root
@a<< @root #
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

def to_a
@a.reverse
end

end#Fsa

fsa=Fsa.new
words.each{|word| fsa.insert(word.strip)}
fsa.insert_last_word

puts "nodes: #{fsa.node_count.to_s}"
puts "edges: #{fsa.edge_count.to_s}"

fsa= fsa.to_a # now fsa is topologically ordered
fsa.each_with_index do |node, x|  node.idx=x  end

a=[] 
fsa.each_with_index do |node, x|
node.edges.each do |edge|
flags= edge[2] ? 1 : 0 # set word_final flag
flags +=2 if edge==node.edges[-1]# set node_final_flag
flags +=4 if edge[1].idx==x + 1 # set target_is_next flag
a<<[edge[0], edge[1].idx, flags ]
end
end

a.each do |label, fix, flags|
fix<<=3     # make room for flags
fix|=flags   # insert flags
if flags&4 ==4 then # flag target_is_next is set
f.print label.chr, flags.chr 
else
f.print	label.chr, (fix&0xff).chr, ((fix>>8)&0xff).chr,  (fix>>16).chr  
end#if
end#each




  