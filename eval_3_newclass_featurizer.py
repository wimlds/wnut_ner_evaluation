"""
A feature extractor for crfsuite.
Uses similarity to lexicon with gensim and postags as extra
features.
"""
import crfutils, sys, os, re
import string
import pickle

#Gensim stuff:
from gensim.corpora.dictionary import Dictionary
from gensim.models.tfidfmodel import TfidfModel

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

# Gensim models:
TFIDF_MODEL = 'Lexicon.tfidf'
INDEX_MODEL = 'Lexicon.index'
DICT = 'Lexicon.dic'

# Horrible copy-paste hardcoding:
DN = ['people.family_name',
    'cap.10',
    'lower.100',
    'firstname.100',
    'tv.tv_network',
    'internet.website',
    'sports.sports_league',
    'lower.10000',
    'business.consumer_company',
    'lastname.5000',
    'cvg.cvg_developer',
    'venues',
    'lastname.10',
    'lastname.100',
    'lower.5000',
    'cap.500',
    'business.brand',
    'broadcast.tv_channel',
    'cap.1000',
    'architecture.museum',
    'location.country',
    'lastname.1000',
    'book.newspaper',
    'venture_capital.venture_funded_company',
    'cvg.computer_videogame',
    'cap.100',
    'award.award',
    'automotive.model',
    'dictionaries.conf~',
    'business.sponsor',
    'lastname.500',
    'firstname.1000',
    'government.government_agency',
    'product',
    'bigdict',
    'tv.tv_program',
    'dictionaries.conf',
    'firstname.500',
    'emoji.text',
    'lower.1000',
    'lower.500',
    'automotive.make',
    'english.stop',
    'time.recurring_event',
    'firstname.5k',
    'sports.sports_team',
    'transportation.road',
    'business.consumer_product',
    'base.events.festival_series',
    'education.university',
    'firstname.10',
    'people.person.lastnames',
    'time.holiday',
    'location',
    'people.person',
    'cvg.cvg_platform',
    'people.family_name',
    'cap.10',
    'lower.100',
    'firstname.100',
    'tv.tv_network',
    'internet.website',
    'sports.sports_league',
    'lower.10000',
    'business.consumer_company',
    'lastname.5000',
    'cvg.cvg_developer',
    'venues',
    'lastname.10',
    'lastname.100',
    'lower.5000',
    'cap.500',
    'business.brand',
    'broadcast.tv_channel',
    'cap.1000',
    'architecture.museum',
    'location.country',
    'lastname.1000',
    'book.newspaper',
    'venture_capital.venture_funded_company',
    'cvg.computer_videogame',
    'cap.100',
    'award.award',
    'automotive.model',
    'dictionaries.conf~',
    'business.sponsor',
    'lastname.500',
    'firstname.1000',
    'government.government_agency',
    'product',
    'bigdict',
    'tv.tv_program',
    'dictionaries.conf',
    'firstname.500',
    'emoji.text',
    'lower.1000',
    'lower.500',
    'automotive.make',
    'english.stop',
    'time.recurring_event',
    'firstname.5k',
    'sports.sports_team',
    'transportation.road',
    'business.consumer_product',
    'base.events.festival_series',
    'education.university',
    'firstname.10',
    'people.person.lastnames',
    'time.holiday',
    'location',
    'people.person',
    'cvg.cvg_platform']


DF = None
class DictionaryFeatures:
    def __init__(self, dictDir):
        self.word2dictionaries = {}
        self.dictionaries = []
        i = 0
        for d in os.listdir(dictDir):
            print("read dict %s"%d, file=sys.stderr)
            self.dictionaries.append(d)
            if d == '.svn':
                continue
            for line in open(dictDir + "/" + d):
                word = line.rstrip('\n')
                word = word.strip(' ').lower()
                try:
                    self.word2dictionaries.get(word)       
                    self.word2dictionaries[word] = str(i)
                except KeyError:
                    self.word2dictionaries[word] += "\t%s" % i
            i += 1
        
    MAX_WINDOW_SIZE=6
    def GetDictFeatures(self, words, i):
        features = []
        
        # Load the similarity index and tfidf model:
        tfidf = pickle.load(open(TFIDF_MODEL, 'rb'))
        index = pickle.load(open(INDEX_MODEL, 'rb'))
        dic = pickle.load(open(DICT, 'rb'))
        
        # Feature extraction:
        for window in range(self.MAX_WINDOW_SIZE):
            for start in range(max(i-window+1, 0), i+1):
                end = start + window
                phrase = ' '.join(words[start:end]).lower().strip(string.punctuation)
                try:
                    self.word2dictionaries.get(phrase)
                    for j in self.word2dictionaries[phrase].split('\t'):
                        features.append('DICT=%s' % self.dictionaries[int(j)])
                        if window > 1:
                            features.append('DICTWIN=%s' % window)
                except KeyError:
                    pass
                
                # Here we add the three most similar 
                dic_phrase = dic.doc2bow(list(phrase))
                similarity = index[tfidf[dic_phrase]]
                for i, sim in enumerate(similarity):
                    features.append('SIM_%d=%s' % (i, DN[sim[0]]))
                
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
