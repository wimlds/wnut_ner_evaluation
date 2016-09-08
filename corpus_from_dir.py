from gensim.corpora.textcorpus import TextCorpus
from os import walk
from os.path import join
from nltk import word_tokenize
import re
from string import punctuation

#diamond museum amsterdam

class CharCorpus:
    
    def __init__(self, path, dic):
        self.path = path
        self.dic = dic
        self.doc_names = []

    def __iter__(self):
        dic = self.dic
        for root, dirs, files in walk(self.path):
            for name in files:
                self.doc_names.append(name)
                file_path = join(root, name)
                f = open(file_path, 'r')
                text = list(f.read())
                yield dic.doc2bow(text)


class CharCorpusFromDir(TextCorpus):
    
    def get_texts(self):
        for root, dirs, files in walk(self.input):
            for name in files:
                file_path = join(root, name)
                f = open(file_path, 'r')
                text = list(f.read())
                yield text

    
class CorpusFromDir(TextCorpus):

    def get_texts(self):
        """
        Walks through a directory and creates a corpus with the 
        files.
        """
        for root, dirs, files in walk(self.input):
            for name in files:
                file_path = join(root, name)
                f = open(file_path, 'r')
                text = f.read()
                tokens = word_tokenize(text)
                yield tokens

    def get_names(self):
        """
        Just return the names of the files used to create
        the corpus.
        """
        names = []
        for root, dirs, files in walk(self.input):
            for name in files:
                names.append(name)
        return names
