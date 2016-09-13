"""A feature extractor for crfsuite"""
import crfutils, sys, os, re
import string
import pickle
from collections import defaultdict

# Distance stuff:
from fuzzywuzzy import process

# For postagging:
from nltk import pos_tag

# Separator of field values.
separator = '\t'
templates = []
fields = 'w y'

templates = (
    (('w', -1), ),
    (('w',  0), ),
    (('w', -1), ('w',  0)), 
    (('w',  0), ('w',  1)),
    )


DF = None
class DictionaryFeatures:
    def __init__(self, dictDir):
        self.dictionaries = defaultdict(list)
        gazs = os.listdir(dictDir)
        for gaz in gazs:
            path = os.path.join(dictDir, gaz)
            f = open(path, 'r').read()
            f_lines = f.splitlines()
            self.dictionaries.update({gaz: f_lines})
    
    def NClosestGazetteer(self, phrase, n):
        """
        Returns the n closest gazetteers from the lexicon.
        
        Parameters:
        -----------
            @param phrase: The phrase we want to match with the lexicon.
            @param n: The number of closest items from the lexicon to return.
            
        Returns:
        --------
            @returns: The name of the n closest gazetteers from the lexicon.
        """
        items = self.dictionaries.items()
        n_closest = []
        for gaz_name, gaz_content in items:
            tmp = (gaz_name, process.extractOne(phrase, gaz_content))
            print('-----extracted', gaz_name)
            n_closest.append(tmp)
        n_closest = sorted(n_closest, key=lambda x: x[1], reverse=True)
        return n_closest
        
    MAX_WINDOW_SIZE=6
    def GetDictFeatures(self, words, i, limit=3):
        features = []
        
        # Feature extraction:
        for window in range(self.MAX_WINDOW_SIZE):
            for start in range(max(i-window+1, 0), i+1):
                end = start + window
                phrase = ' '.join(words[start:end]).lower().strip(string.punctuation)
                n_closest = self.NClosestGazetteer(phrase, limit)
                for i, item in enumerate(n_closest):
                    features.append("CLOSEST_GAZ_%d=%s" % (i, item[0]))
        return list(set(features))

def GetOrthographicFeatures(word, goodCap=True):
    features = []

    features.append("word=%s" % word)
    features.append("word_lower=%s" % word.lower())
    if(len(word) >= 4):
        features.append("prefix=%s" % word[0:1].lower())
        features.append("prefix=%s" % word[0:2].lower())
        features.append("prefix=%s" % word[0:3].lower())
        features.append("suffix=%s" % word[len(word)-1:len(word)].lower())
        features.append("suffix=%s" % word[len(word)-2:len(word)].lower())
        features.append("suffix=%s" % word[len(word)-3:len(word)].lower())

    if re.search(r'^[A-Z]', word):
        features.append('INITCAP')
    if re.search(r'^[A-Z]', word) and goodCap:
        features.append('INITCAP_AND_GOODCAP')
    if re.match(r'^[A-Z]+$', word):
        features.append('ALLCAP')
    if re.match(r'^[A-Z]+$', word) and goodCap:
        features.append('ALLCAP_AND_GOODCAP')
    if re.match(r'.*[0-9].*', word):
        features.append('HASDIGIT')
    if re.match(r'[0-9]', word):
        features.append('SINGLEDIGIT')
    if re.match(r'[0-9][0-9]', word):
        features.append('DOUBLEDIGIT')
    if re.match(r'.*-.*', word):
        features.append('HASDASH')
    if re.match(r'[.,;:?!-+\'"]', word):
        features.append('PUNCTUATION')
    return features


def Featurizer(X):
    global DF
    if X:
        # For postagging:
        sentence = []
        for x_ in X:
            sentence.append(x_['w'])
        tagged = pos_tag(sentence)
        
        for t in range(len(X)):
            w = X[t]['w']
            feats = DF.GetDictFeatures(w,t) + GetOrthographicFeatures(w)
            X[t]['F'].append('POSTAG_NLTK=%s'%(tagged[t][1]))
            for f in feats:
                X[t]['F'].append('%s'%(f))


def FeatureExtractor(X):
    """apply attribute templates to obtain features (in fact, attributes)"""
    crfutils.apply_templates(X, templates)

    Featurizer(X)
    if X:
        X[0]['F'].append('__BOS__')     # BOS feature
        X[-1]['F'].append('__EOS__')    # EOS feature

if __name__ == '__main__':
    DF = DictionaryFeatures("./lexicon")
    crfutils.main(FeatureExtractor, fields=fields, sep=separator)
