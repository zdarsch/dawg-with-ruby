# Ruby 274

f=File.open("dict.fsa", "rb")
g=File.open("_dict.txt", "w")
class Node
attr_accessor  :edges 
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

## Top level instance variables:
@candidate=[]
@replacements=[]

def dfs(n, h, depth)
i=depth	
node=h[n]
node.edges.each do |edge|
        @candidate[i]=edge[0].chr
        if edge[2]&1==1 then
	@candidate.slice!(i+1 .. -1)
        @replacements<<@candidate.join
	end#if
         dfs(edge[1], h, i+1)
end#each
end#dfs

dfs(0, h,0)
g.puts @replacements 
