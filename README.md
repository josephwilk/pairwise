Pairwise
-------

Pairwise is a Ruby based tool for selecting a smaller number of test input combinations (using pairwise generation) 
rather than exhaustively testing all possible permutations.

Created by Joseph Wilks, updated by Ali King for newer Rubies

How to use Pairwise: http://aliking.github.com/pairwise/

Newer Rubies and Syck vs Psych
-----------
Syck and Psych are YAML serialization libraries. Historically Ruby used syck, now Psych is the default. There are a 
couple of differences between the two, which are better described here :- http://devblog.arnebrasseur.net/2014-02-yaml-syck-vs-psych

This fork from the original pairwise just removes a directive to use syck and adds some tests for multibyte characters 
which may have been interpreted differently by the different libraries. 

Also adds unicode-display_width gem to help with formatting - multibyte characters are tricksy.

Tested on ruby 1.8.7-p374 and 2.0.0-p353 as a sampling, but this should be future-proof. 


Running tests
------------
<pre><code>rake</code></pre>



Copyright
--------

See LICENSE for details.

