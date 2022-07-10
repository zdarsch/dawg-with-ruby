# Ruby 274

f=File.open("dict.fsa", "rb")

# To implement perfect hashing
# we use dict.fsa to build a numbered automaton.
# The new variable(num) holds the cardinal 
# of the right language of the node.

class Node
attr_accessor  :edges,  :num
def initialize	
	@edges=[]
end
end#Node

# Load  the automaton
h =Hash.new { |fsa, n| fsa[n] = Node.new }
x, edge = 0, []
while s=f.read(4) do
s=s.each_byte.to_a
# edge=[label, target, flags]
edge=[ s[0], (s[1]>>2) + (s[2]<<6) + (s[3]<<14), s[1]&3 ] 
h[x].edges << edge
(x+=1; h[x]) if s[1]&2==2 #last edge of node
end#while

# The  methods defined in the following module
# will be added to the automaton.
module A
def recognize?(w)
h=self
edge=[]
word=w
node=h[0] #@root
word.each_byte.with_index do |byte, x| 
 edge=node.edges.assoc(byte)
 return false unless edge
node=h[edge[1]]
end#each_byte
return  edge[2]&1==1#? true : false
end #recognize?

def dfs(n)
h=self
node=h[n]
#postorder traversal
count=0
node.edges.each do |edge|
count+=dfs(edge[1])
count+=1 if edge[2]&1==1#edge last in word
end#each
node.num=count
end#def

def num2word(m)
	count=m
	h, n =self, 0
	output_word=""
	return nil if  m > h[0].num # m is too big
	while node=h[n] do
	node.edges.each do |e|
		if count > h[e[1]].num + (e[2]&1) then
		count -= h[e[1]].num + (e[2]&1)
		else
			output_word+=e[0].chr
			count=count-1 if e[2]&1==1
			n=e[1]
			break #each
                end#if		
	end#each
	 break if  count==0
         end#while	 
	return output_word	
end#def

def word2num(w)
h=self
s=0
word=w
edge=[]
node=h[0] # root 
word.each_byte.with_index do |byte, x| 
 edge=node.edges.assoc(byte)
return nil unless edge
s+=edge[2]&1
node.edges.each do |e|
	if e[0] <word[x].ord then
	s+=h[e[1]].num
	s+=e[2]&1 
        end#if	
end#each 
node=h[edge[1]]
end#each_byte_with_index
return nil unless edge[2]&1==1 
return s
end #def

def index2word(n)
return num2word(n+1)
end#def

def word2index(w)
return word2num(w) -1
end#def

end#module

# Add methods to the automaton
h.extend(A)

# Number the automaton
h.dfs(0) 


g=File.open("results", "w")
# another way of decoding dict.fsa
(1 .. h[0].num).each do |x| g.puts h.num2word(x) end




