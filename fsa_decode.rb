# ruby187 on Windows Xp

f=File.open("dict.fsa", "rb")
g=File.open("_dict.txt", "w")
class Node
attr_accessor  :edges 
def initialize	
	@edges=[]
end
end#Node

class String
# (2<= string.length <=4)	
def label
return self[0]
end

def flags
return self[1]&7
end

def node_final?
return self[1]&2==2
end

def target_is_next?
return self[1]&4==4
end
	
def target
return  (self[1]>>3) + (self[2]<<5) + (self[3]<<13)
end

end#String

h = Hash.new { |hash, key| hash[key] = Node.new }
x, edge = 0, []
while s=f.read(4) do# s.length <= 4
if s.target_is_next? then 
f.pos = f.pos - s.length + 2 # s.length <= 4 
edge=[ s.label, x+1, s.flags ]
else
edge=[ s.label, s.target, s.flags ] 
end
h[x].edges << edge
x+=1 if s.node_final?
end#while

$candidate=[]
$replacements=[]

def dfs(n, h, depth)
i=depth	
node=h[n]
node.edges.each do |edge|
        $candidate[i]=edge[0].chr
        if edge[2]&1==1 then
	$candidate.slice!(i+1 .. -1)
        $replacements<<$candidate.to_s 
	end#if
         dfs(edge[1], h, i+1)
end#each
end#dfs

dfs(0, h,0)

  $candidate#.clear
  
  g.puts $replacements 
