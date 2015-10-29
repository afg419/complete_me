Complete Me text auto completer

for_complete_me.rb
  Contains the code for the ForCompleteMe class where pretty much everything is
  implemented: given a file of words, will create a directed graph with an edge
  from one word fragment to the next iff the first fragment occurs at the start
  of the next.  The allows for quick construction and quick search so that it is
  easy to find all words beginning with a particular word fragment.

rev_complete_me.rb
  Contains the code for the RevCompleteMe class.  This is a simplified mirror
  image of ForCompleteMe.  It is therefore very quick to use to find all words
  which end with a particular word fragment.

complete_me.rb
  Contains the code for the CompleteMe class.  It passes off the main
  responsibilities to the ForCompleteMe class except in the "includes" method.
  Here it passes data from instances of ForCompleteMe to RevCompleteMe and back
  in order to identify all words which contain a given fragment in any location.
