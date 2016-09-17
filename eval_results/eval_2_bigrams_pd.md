Using 

```
templates = (
    (('w', -2), ),
    (('w', -1), ),
    (('w',  0), ),
    (('w',  0), ('w',  1)),
    (('w', -1), ('w',  0)), 
    (('w',  0), ('w',  1)),
    (('w', -2), ('w',  -1), ('w', 0)), 
    (('w', -1), ('w',  0), ('w', 1)), 
    (('w', 0), ('w',  1), ('w', 2)),
    )
```

```
./result/4gram-feats/dev_4gram.feats finish prediction
processed 46902 tokens with 1998 phrases; found: 547 phrases; correct: 392.
accuracy:  94.16%; precision:  71.66%; recall:  19.62%; FB1:  30.81
          company: precision:  89.43%; recall:  41.83%; FB1:  56.99  123
         facility: precision:  80.00%; recall:   3.54%; FB1:   6.78  5
          geo-loc: precision:  66.43%; recall:  25.68%; FB1:  37.04  143
            movie: precision: 100.00%; recall:  33.33%; FB1:  50.00  6
      musicartist: precision:  85.71%; recall:   9.23%; FB1:  16.67  7
            other: precision:  43.86%; recall:   7.55%; FB1:  12.89  57
           person: precision:  75.68%; recall:  19.48%; FB1:  30.98  148
          product: precision:  42.31%; recall:  11.22%; FB1:  17.74  26
       sportsteam: precision:  73.33%; recall:  21.15%; FB1:  32.84  30
           tvshow: precision:  50.00%; recall:   1.64%; FB1:   3.17  2
```
