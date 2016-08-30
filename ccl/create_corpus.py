"""
This script reads all jsons contained in some directory, 
and writes the text of all tweets into a file.

Usage:
    create_corpus.py -d <path> -o <path>
    create_corpus.py -h --help
    
Options:
    -d <path>   Path to directory with json files.
    -o <path>   Where to write the data.
    -h|--help   Show this screen.
"""
import json
import bz2
from pickle import dump
from os import path, walk
from docopt import docopt
from string import punctuation, ascii_letters, digits
import binascii


def punct_code_point():
    d = dict()
    for i in punctuation:
        d.update({i: binascii.b2a_hex(i.encode('unicode_escape'))})
    return d


PCP = punct_code_point()
PREFIX = "\\u00"


def proper_encode_2(letter):
    """
    Turns punctuation into ascii representation.
    
    Parameters:
    -----------
        @letter: The char.
        
    Returns:
    --------
        @returns: A string consisting on the unicode representation of the input char.
    """
    if letter in punctuation:
        encoded_str = PREFIX + str(PCP[letter], 'utf-8')
    else:
        encoded_str = str(letter.encode('unicode_escape'), 'utf-8')
    return encoded_str


def proper_encode(letter):
    """
    Turns every ascii char into ascii representation.
    
    Parameters:
    -----------
        @letter: The char.
        
    Returns:
    --------
        @returns: A string consisting on the unicode representation of the input char.
    """
    if letter in punctuation \
              or letter in ascii_letters \
              or letter in digits:
        ascii_encode = binascii.b2a_hex(letter.encode('unicode_escape'))
        encoded_str = PREFIX + str(ascii_encode, 'utf-8')
    else:
        encoded_str = str(letter.encode('unicode_escape'), 'utf-8')
    return encoded_str


if __name__ == '__main__':
    opts = docopt(__doc__)
    directory = opts['-d']
    output_path = opts['-o']
    output_file = open(output_path, 'a+')
    
    # Read all the .json files on directory:
    tweet_files = []
    for root, dirs, files in walk(directory):
        for f in files:
            print(f)
            f = path.join(root, f)
            if '.bz2' in f:
                try:
                    bz = bz2.open(f).read()
                except EOFError:
                    pass
                data = bz.decode('utf-8')
                data = data.splitlines()
                tweets = []
                for line in data:
                    temp_tweet = json.loads(line)
                    try:
                        text = temp_tweet['text']
                        tokens = text.split()
                        chars = [ch for token in tokens for ch in token]
                        chars = [proper_encode(letter) for letter in chars]
                        tweet = ' '.join(chars)
                        output_file.write(tweet)
                        output_file.write('\n')
                    except KeyError:
                        pass

    output_file.close()
