"""
This script takes a bracketed string tree and produces
an image of a human-readable tree.
IMPORTANT: For nltk to understand how the tree should be
built, a dummy root token is introduced: R.

Usage:
    create_corpus.py -i <path> -o <path> [-a <a>]
    create_corpus.py -h --help
    
Options:
    -i <path>   Path to tree.
    -o <path>   Where to write the data.
    -a <a>      Whether to print ascii in the command line. Default, yes. [default: 1]
    -h|--help   Show this screen.
"""
from docopt import docopt
from nltk.tree import Tree
from nltk.draw.util import CanvasFrame
from nltk.draw import TreeWidget


if __name__ == '__main__':
    opts = docopt(__doc__)
    input_file = open(opts['-i'], 'rb').read()
    input_file = input_file.replace(b"\u0028", b"op")
    input_file = input_file.replace(b"\u0029", b"cp")
    input_file = input_file.decode('unicode_escape')
    input_file = input_file.replace('\n', '')
    input_file = input_file.replace('(', '(R ')
    output_path = opts['-o']
    print_ascii = bool(opts['-a'])

    cf = CanvasFrame()
    tr = Tree.fromstring(input_file)
    #import ipdb; ipdb.set_trace()
    if print_ascii:
        tr.pretty_print()
    tc = TreeWidget(cf.canvas(),tr)
    cf.add_widget(tc, 10, 10)
    cf.print_to_file(output_path)
    cf.destroy()
    
    print('Tree saved in %s.' % output_path)
