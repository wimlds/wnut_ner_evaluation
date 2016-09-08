# Conditional Random Fields

Very roughly, conditional random fields are a framework where a conditional probability _P(y|x)_ is modeled as $\frac{1}{Z} \prod exp(\sum\lambda f(x, y))$, where each $f$ is a feature function over a cliqué (subgraph). 
We can think about CRF's about something similar to MEMM but instead of being computed in the state space (that is, every transition from one state to another defines a probability distribution), it is computed over the sequence space.

## Mallet
This implements linear CRF with arbitrary high-order potentials. The class SimpleTagger is an interface to an arbitrary ordered CRF in which the order can be set on the command line with the option _--order_.
We are training a second order CRF over the data with the new class.

# The knowledge base

## Using distance as features
A char-based tfidf model was built on top of the lexicons. To train, apart from the lexicon features a distance features was added such that the closest five lexicons were part of the feature vector.
This did not improved the results.

## Augmenting k. b. with wikipedia
Too big to handle so far. TODO: search engine?


# Adding postag features.

By adding postag features we improve precision on almost a 3% reaching 86.99% on eval_3_train_newclass data set. Recall remains almost the same. In general low recall is observed.