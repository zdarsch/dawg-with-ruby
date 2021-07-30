            Directed Acyclic Word Graphs
           (with Ruby187 on Windows Xp)

A finite state automaton (FSA), recognizing a set of strings,  can be viewed as a directed acyclic graph. Thus, such FSAs are also known as directed acyclic word graphs (DAWGs). The aim of  the project is to build them with Ruby, serialize them and use them in other projects. The project is based on the work of Jan Daciuk (http://www.jandaciuk.pl/fsa.html).

How to use:
1) Prepare a file with  a lexicographically sorted list of  words. One word  per line, no empty lines, no  repetitions. 
2) Rename the file to "dict.txt"
3) Run "fsa_build.rb" or "fsa_save.rb"

The script "fsa_build.rb" builds the (minimal) FSA and prints the number of  nodes and edges.

The script "fsa_save.rb" builds and saves the FSA to disk,  in the file "dict.fsa".

The script "fsa_decode.rb"  takes  "dict.fsa" as input and rapidly loads  the FSA. Then a depth-first traversal is done and the words recognized by the FSA are printed to disk, in the file "_dict.txt".

The script "perfect_hashing.rb" uses "dict.fsa" to build a numbered automaton. The class "Node" gets a  new instance variable: "num". For each node, the value of  "num" is the size (number of words) of its right language. New methods  wrapped in a module are added to the automaton.  A post order traversal "dfs" sets the value of "num".  The methods "num2word" and "word2um" implement a minimal perfect hashing.

Further reading:
1) Kowaltowski, Lucchesi; "Applications of Finite Automata Representing Large Vocabularies"; Relatorio Tecnico DCC-01/92 (1992)
2) Kowaltowski, Lucchesi, Stolfi; "Finite Automata and Efficient Lexicon Implementation"; Relatorio Tecnico IC-98-2 (1998)
