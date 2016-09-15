"""Trains a similarity model.

Usage:
  train_sim.py -o <file> -c <file> [-n <int>]
  train_sim.py -h | --help

Options:
  -o <file>     Output pickle filename.
  -c <file>     Filename of pickled corpus.
  -n <int>      Number of most similar documents to return. [default: 3]
  -h --help     Show this screen.
"""
from docopt import docopt
from gensim.similarities.docsim import Similarity
from gensim.models.lsimodel import LsiModel
from gensim.models.logentropy_model import LogEntropyModel
from corpus_from_dir import CharCorpus
from os.path import abspath, dirname
import pickle
import resource

resource.setrlimit(resource.RLIMIT_DATA, (1024, -1))
# TODO: corregir esto.

if __name__ == '__main__':
    opts = docopt(__doc__)
    filename = opts['-o']
    path = abspath(dirname(filename))
    corpus = pickle.load(open(opts['-c'], 'rb'))
    dic = corpus.dictionary
    
    lsi = LsiModel(log_ent[corpus], id2word=dic)
    lsi.save(filename + '.lsi')
    
    sim = Similarity(path,
                     lsi[corpus],
                     num_features=lsi.num_topics,
                     num_best=int(opts['-n']))
    sim.save(filename + '.sim')
