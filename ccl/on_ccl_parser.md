# CCL parser on tweets

## About CCL

CCL is a unsupervised incremental parser. Unsupervised because it's trained with unlabeled data, and incremental meaning that it builds the parse as it reads the utterances. The algorithm relies on the concept of **common cover links**, which resembles dependency links but with some important differences. For example, dependency links can only be found once the whole sentence was read, whereas a set of common cover links can be computed incrementally. A parsing tree can be recovered from such a set and is what the parser returns.
The parsing pipeline is something like this: a set of training utterances is given, at each step _i_ a parsing function _P<sub>i_ based on lexicon _L<sub>i_ computes weights for each possible link for the current word in utterance _U<sub>i_ and picks the one that is maximal. Once it's done with the sentence a lexicon _L<sub>i+1_ is created by updating the previous one with the result of _P<sub>i_. 
What the lexicon does is, for each word _w_, decides how "likely" it is for another word _x_ to become linked to _w_ as it becomes adjacent to it. I say "likely" because what the lexicon returns is not a probability but a number that represents how strong this possibility is. An important remark is that here a word may be "adjacent" to another not in the sense of being next to each other in a sequence, but, roughly, depending on whether or not there's a linking path between them with certain properties. 

## Input

We trained CCL parser with a data set consisting on ~1.7 million tweets where each character represents a token. We used the ascii encoding, as a result, any character with an integer representation above 127 and punctuation is written like ```\u00..```.
On top of the learning algorithm we produced trees for more than 600 thousands tweets.

## Output

In general the parser produces completely skewed trees on ascii characters and trees with more complex structures in non ascii, such as japanese. It's difficult for me to get any insights on the latter ones since I don't speak any of those languages (I couldn't tell whether or not it's recovering full words, for instance) but I think there are a couple things to keep in mind. First, punctuation in the parser has a role of blocking links (I need to dig more into this), so it captures a different structure when used as such. Since we are interested in emojis we consider them as tokens. Secondly, considering the fact that each parsing function is parameterized by a lexicon<sup id="a1">[1](#f1)</sup>, it probably makes sense to learn different parsing functions for different languages.

<b id="f1">1</b> I think about the lexicon as something that contains information on affinity between tokens in the contexts provided by the training set. In terms of CRFs, could we see this information as a factor?[↩](#a1)
