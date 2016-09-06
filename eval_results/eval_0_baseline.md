Baseline
```
10 Entity Types:
accuracy:  96.06%; precision:  53.91%; recall:  36.80%; FB1:  43.74
          company: precision:  70.00%; recall:  51.22%; FB1:  59.15  30
         facility: precision:  37.50%; recall:  30.00%; FB1:  33.33  16
          geo-loc: precision:  64.29%; recall:  46.55%; FB1:  54.00  42
            movie: precision:  20.00%; recall:  33.33%; FB1:  25.00  5
      musicartist: precision:  25.00%; recall:   8.33%; FB1:  12.50  4
            other: precision:  33.33%; recall:  13.11%; FB1:  18.82  24
           person: precision:  61.46%; recall:  50.43%; FB1:  55.40  96
          product: precision:  36.36%; recall:  22.22%; FB1:  27.59  11
       sportsteam: precision:  27.27%; recall:  16.67%; FB1:  20.69  11
           tvshow: precision:  25.00%; recall:  12.50%; FB1:  16.67  4

No Types:
accuracy:  96.64%; precision:  60.36%; recall:  47.47%; FB1:  53.14
                 : precision:  60.36%; recall:  47.47%; FB1:  53.14  280
                 : precision:  60.36%; recall:  47.47%; FB1:  53.14  280
```
---
Baseline (with emoji dictionary included)  
```
Storing the model
Number of active features: 32978 (93296)
Number of active attributes: 26872 (87172)
Number of active labels: 21 (21)
Writing labels
Writing attributes
Writing feature references for transitions
Writing feature references for attributes
Seconds required: 0.079

End time of the training: 2016-09-06T03:01:41Z

./result//dev.feats finish prediction
processed 11570 tokens with 356 phrases; found: 247 phrases; correct: 136.
accuracy:  96.13%; precision:  55.06%; recall:  38.20%; FB1:  45.11
          company: precision:  70.00%; recall:  51.22%; FB1:  59.15  30
         facility: precision:  53.85%; recall:  35.00%; FB1:  42.42  13
          geo-loc: precision:  65.91%; recall:  50.00%; FB1:  56.86  44
            movie: precision:  20.00%; recall:  33.33%; FB1:  25.00  5
      musicartist: precision:  16.67%; recall:   8.33%; FB1:  11.11  6
            other: precision:  37.50%; recall:  14.75%; FB1:  21.18  24
           person: precision:  61.22%; recall:  51.28%; FB1:  55.81  98
          product: precision:  28.57%; recall:  22.22%; FB1:  25.00  14
       sportsteam: precision:  27.27%; recall:  16.67%; FB1:  20.69  11
           tvshow: precision:  50.00%; recall:  12.50%; FB1:  20.00  2
```
