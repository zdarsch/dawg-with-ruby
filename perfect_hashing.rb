# ruby187 on Windows Xp; automata have final transitions (not states).

f=File.open("dict.fsa", "rb")
# To implement perfect hashing
# we use dict.fsa to build a numbered automaton.
# The new variable(num) holds the size (number of words) 
# of the right language of the node.

class Node
attr_accessor  :edges,  :num
def initialize	
	@edges=[]
end
end#Node

# Create the automaton
h =Hash.new { |fsa, n| fsa[n] = Node.new }
x, edge = 0, []
while s=f.read(4) do #s.length <= 4
if s[1]&4==4 then #target is next
f.pos = f.pos - s.length + 2 #s.length <= 4 
edge=[ s[0], x+1, s[1]&7 ]
else
edge=[ s[0], (s[1]>>3) + (s[2]<<5) + (s[3]<<13), s[1]&7 ] 
end
h[x].edges << edge
x+=1 if s[1]&2==2 #last edge in node
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

# Adding methods to the automaton
h.extend(A)

# Numbering the automaton
h.dfs(0) 

# Testing
g=File.open("results", "w")
h.keys.sort.each do |n| g.puts [n, h[n].num].join("=>") end
#0=>2039133, . . .
# The following (commented out) line :
# (1 .. 2039133).each do |x| g.puts h.num2word(x) end
# is a way of getting the whole list of words
# recognised by the automaton.




