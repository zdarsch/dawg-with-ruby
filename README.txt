            Directed Acyclic Word Graphs

A finite state automatom (FSA), recognizing a set of strings,  can be viewed as a directed acyclic graph. Thus, such FSAs are also known as directed acyclic word graphs (DAWGs). The aim of  the project is to build them with Ruby, serialize them and use them in other projects. The project is based on the work of Jan Daciuk (http://www.jandaciuk.pl/fsa.html).

How to use:
1) Prepare a file with  a lexicographically sorted list of  words. One word  per line, no empty lines, no  repetitions. 
2) Rename the file to "dict.txt"
3) Run "fsa_build.rb" or "fsa_save.rb"

The script "fsa_build.rb" builds the (minimal) FSA and prints the number of  nodes and edges.

The script "fsa_save.rb" builds and saves the FSA to disk,  in the file "dict.fsa".

The script "fsa_decode.rb"  takes  "dict.fsa" as input and rapidly loads  the FSA. Then a depth-first traversal is done and the words recognized by the FSA are printed to disk, in the file "_dict.txt".
