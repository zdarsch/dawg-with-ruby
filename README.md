
            Directed Acyclic Word Graphs
	    
The present  project is based on the work of Jan Daciuk (http://www.jandaciuk.pl/fsa.html) but final transitions were preferred to final states, as this choice yields  smaller minimal automata. By FSA or simply automaton, we always mean a minimal finite state automaton with final transitions.

An FSA, recognizing a set of strings,  can be viewed as a directed acyclic graph.  Thus, instead of states and transitions we may also speak of nodes and edges.

How to use the scripts:
1) Prepare a file with  a lexicographically sorted list of  words. One word  per line, no empty lines, no  repetitions. 
2) Rename the file to "dict.txt"
3) Run "fsa_build.rb" or "fsa_save.rb"

The script "fsa_build.rb" builds the  automaton and prints its number of  nodes and edges.

The script "fsa_save.rb" builds the automaton and saves its serialization  in the file "dict.fsa".

The script "fsa_decode.rb"  takes  "dict.fsa" as input,   loads  the automaton and  prints the list of words it recognizes  in the file "_dict.txt".

The script "perfect_hashing.rb"  builds a numbered automaton.  The methods "num2word" and "word2num" implement a minimal perfect hashing.

The scripts were first written  for Ruby 187  and later adapted to Ruby 274. They were tested on a  list of 2 039 133 russian accented words.  Ruby 187  builds and saves the minimal automaton in 8 minutes on Windows Xp, while  Ruby 274 does it in 16 seconds on Windows 10.

Further reading:
1) Kowaltowski, Lucchesi; "Applications of Finite Automata Representing Large Vocabularies"; Relatorio Tecnico DCC-01/92 (1992)
2) Kowaltowski, Lucchesi, Stolfi; "Finite Automata and Efficient Lexicon Implementation"; Relatorio Tecnico IC-98-2 (1998)
