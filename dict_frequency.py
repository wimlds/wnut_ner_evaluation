"""
Very simple script to print how frequently the lexicons appear among
the features of some training or test set.
#TODO: main + docopt
"""
from os import walk


f = open('result/eval_3_dev_newclass.feats', 'r')
feats = f.read()
fs = feats.splitlines()
names_freq = []
for root, dirs, files in walk('lexicon/'):
    for dic_name in files:
        belongs_to = lambda line: dic_name in line
        filtered_l = list(filter(belongs_to, fs))
        names_freq.append((dic_name, len(filtered_l)))

names_freq = sorted(names_freq, key=lambda x: x[1])
for name, freq in names_freq:
    print('%s appears in %d documents.' % (name, freq))
