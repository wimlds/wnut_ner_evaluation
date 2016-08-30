"""
Nasty script to turn the features file into a mallet-friendly input.
"""
if __name__ == '__main__':
    feats = []
    with open('result_2/train.feats', 'r') as f:
        for line in f:
            features = line.split('\t')
            if len(features) > 0:
                label = features[0]
                tail = features[1:]
                if len(tail) > 0:
                    tail[-1] = tail[-1].strip('\n')
                tail.append(label)
                fs = '\t'.join(tail)
                feats.append(fs)
    #import ipdb; ipdb.set_trace()
    

    g = open('result_2/train.mallet_fs', 'a+')
    for line in feats:
        g.write(line)
        g.write('\n')
    g.close()