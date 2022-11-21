#encoding: Windows-1251
Encoding.default_external="Windows-1251"

# Builds and serializes the minimal fsa with final transitions representing a lexicographically sorted list of strings. Empty lines or repetitions are not allowed. Tested with  Ruby 274 on Windows 10.

words=IO.readlines("dict.txt")
f= File.open("dict.fsa", 'wb')

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
	attr_accessor :edges, :idx
def initialize
	@edges=[]
end

end# Node

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


def insert(word)
cpl=@prev_word.cplen(word)
minimize_downto(cpl+1) 
# update @prev_word
@prev_word=word
# update @prev_path
@prev_path.slice!( cpl+1 .. -1)
node=@prev_path[cpl]
# complete @prev_path for new path 
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

def to_a2
# Ruby274 preserves the insertion order 
@register.values.reverse
end

end#Fsa

fsa=Fsa.new
words.each{|word| fsa.insert(word.chomp) }
fsa.insert_last_word

puts "nodes: #{fsa.node_count}"
puts "edges: #{fsa.edge_count}"

ar= fsa.to_a2  # nodes in topological order


ar.each_with_index do |node, x|  node.idx=x  end

a=[] 
ar.each_with_index do |node, x|
node.edges.each do |edge|
flags= edge[2] ? 1 : 0 # set word final flag
flags +=2 if edge==node.edges[-1]# set node final flag
a<<[edge[0], edge[1].idx, flags ]
end
end

a.each do |label, fix, flags|
fix<<=2     #  room for flags
fix|=flags   #  insert flags
f.print	label.chr, (fix&0xff).chr, ((fix>>8)&0xff).chr,  (fix>>16).chr
end#each




  
