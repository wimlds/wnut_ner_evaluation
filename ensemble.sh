#!/bin/bash

DATA_DIR="./data"
OUT_DIR="./result/ensemble"
TRAIN_DATA="train"
ENSEMBLE_DATA="dev_2015"
TEST_DATA="dev"
FEATURIZER="python ./featurizer.py"
FEATURIZER_NGRAM="python ./featurizer_ngram.py"
FEATURIZER_ENSEMBLE="python ./featurizer_ensemble.py"
DOVETAILER="perl dovetail.pl"
CRF="crfsuite"
EVAL="perl connlleval.pl"

DOVETAIL_TRAIN_ENSEMBLE="$DOVETAILER $DATA_DIR/$ENSEMBLE_DATA"
DOVETAIL_TEST="$DOVETAILER $DATA_DIR/$TEST_DATA"

# base system
BASE_DIR=$OUT_DIR/base
mkdir -p $BASE_DIR

TRAIN_FEAT=${BASE_DIR}/${TRAIN_DATA}.feats
ENSEMBLE_FEAT=${BASE_DIR}/${ENSEMBLE_DATA}.feats
TEST_FEAT=${BASE_DIR}/${TEST_DATA}.feats

MODEL=${BASE_DIR}/${TRAIN_DATA}.model

echo "***** (base) Running ${FEATURIZER} on ${TRAIN_DATA} (`date`) *****"
cat ${DATA_DIR}/${TRAIN_DATA} | ${FEATURIZER} > ${TRAIN_FEAT}

echo "***** (base) Running ${FEATURIZER} on ${TEST_DATA} (`date`) *****"
cat ${DATA_DIR}/${TEST_DATA} | ${FEATURIZER}  > ${TEST_FEAT}

echo "***** (base) Running ${FEATURIZER} on ${ENSEMBLE_DATA} (`date`) *****"
cat ${DATA_DIR}/${ENSEMBLE_DATA} | ${FEATURIZER}  > ${ENSEMBLE_FEAT}

#training
TRAIN_OPTS="learn -a ap"
RUN_CMD="${CRF} ${TRAIN_OPTS} -m ${MODEL} ${TRAIN_FEAT}"
eval "${RUN_CMD}"

#prediction 
TEST_OPTS="tag -r"
RUN_CMD="${CRF} ${TEST_OPTS} -m ${MODEL} ${TEST_FEAT}"
eval "${RUN_CMD} > ${TEST_FEAT}.results"
RUN_CMD="${CRF} ${TEST_OPTS} -m ${MODEL} ${ENSEMBLE_FEAT}"
eval "${RUN_CMD} > ${ENSEMBLE_FEAT}.results"

echo "(base) ${TEST_FEAT} finish prediction"

cat ${TEST_FEAT}.results | tr '\t' ' ' | perl -ne '{chomp;s/\r//g;print $_,"\n";}' | ${EVAL} > ${TEST_FEAT}.SUMMARY
echo "**** base"
cat ${TEST_FEAT}.SUMMARY

DOVETAIL_TRAIN_ENSEMBLE="$DOVETAIL_TRAIN_ENSEMBLE $BASE_DIR/${ENSEMBLE_FEAT}.results"
DOVETAIL_TEST="$DOVETAIL_TEST $BASE_DIR/${TEST_FEAT}.results"

for NGRAM in 3 4 5 6 7
do  
    NGRAMIZER="perl ./train_to_ngram.pl $NGRAM separate"
    DENGRAMIZER="perl ngram2token.pl $NGRAM $DATA_DIR/dev"

    # generate training data
    NGRAM_DIR=$OUT_DIR/$NGRAM
    mkdir -p $NGRAM_DIR

    for DATA in $TRAIN_DATA $TEST_DATA $ENSEMBLE_DATA
    do
	cat $DATA_DIR/$DATA | ${NGRAMIZER} > $NGRAM_DIR/$DATA
    done

    # train model
    TRAIN_FEAT=${NGRAM_DIR}/${TRAIN_DATA}.feats
    TEST_FEAT=${NGRAM_DIR}/${TEST_DATA}.feats
    ENSEMBLE_FEAT=${NGRAM_DIR}/${ENSEMBLE_DATA}.feats

    MODEL=${NGRAM_DIR}/${TRAIN_DATA}.model

    echo "***** ($NGRAM-gram) Running ${FEATURIZER_NGRAM} on ${TRAIN_DATA} (`date`) *****"
    cat ${NGRAM_DIR}/${TRAIN_DATA} | ${FEATURIZER_NGRAM} > ${TRAIN_FEAT}

    echo "***** ($NGRAM-gram) Running ${FEATURIZER_NGRAM} on ${TEST_DATA} (`date`) *****"
    cat ${NGRAM_DIR}/${TEST_DATA} | ${FEATURIZER_NGRAM}  > ${TEST_FEAT}

    echo "***** ($NGRAM-gram) Running ${FEATURIZER} on ${ENSEMBLE_DATA} (`date`) *****"
    cat ${NGRAM_DIR}/${ENSEMBLE_DATA} | ${FEATURIZER_NGRAM}  > ${ENSEMBLE_FEAT}

    #training
    TRAIN_OPTS="learn -a ap"
    RUN_CMD="${CRF} ${TRAIN_OPTS} -m ${MODEL} ${TRAIN_FEAT}"    
    eval "${RUN_CMD}"

    #dumping a model
    #${CRF} dump ${MODEL} > ${MODEL}.txt

    #prediction 
    TEST_OPTS="tag -r"
    RUN_CMD="${CRF} ${TEST_OPTS} -m ${MODEL} ${TEST_FEAT}"
    eval "${RUN_CMD} > ${TEST_FEAT}.results"
    RUN_CMD="${CRF} ${TEST_OPTS} -m ${MODEL} ${ENSEMBLE_FEAT}"
    eval "${RUN_CMD} > ${ENSEMBLE_FEAT}.results"

    echo "($NGRAM-gram) ${TEST_FEAT} finish prediction"

    cat ${TEST_FEAT}.results | tr '\t' ' ' | perl -ne '{chomp;s/\r//g;print $_,"\n";}' | \
	${DENGRAMIZER} | ${EVAL} > ${TEST_FEAT}.SUMMARY
    echo "**** $NGRAM-grams:"
    cat ${TEST_FEAT}.SUMMARY

    DOVETAIL_TRAIN_ENSEMBLE="$DOVETAIL_TRAIN_ENSEMBLE $NGRAM_DIR/${ENSEMBLE_FEAT}.results"
    DOVETAIL_TEST="$DOVETAIL_TEST $NGRAM_DIR/${TEST_FEAT}.results"
done

echo ${DOVETAIL_TRAIN_ENSEMBLE}
eval "${DOVETAIL_TRAIN_ENSEMBLE} > ${OUT_DIR}/${ENSEMBLE_DATA}"
echo ${DOVETAIL_TEST}
eval "${DOVETAIL_TEST} > ${OUT_DIR}/${TEST_DATA}"

ENSEMBLE_FEAT=${OUT_DIR}/${ENSEMBLE_DATA}.feats
TEST_FEAT=${OUT_DIR}/${TEST_DATA}.feats

eval "cat ${OUT_DIR}/${ENSEMBLE_DATA} | ${FEATURIZER_ENSEMBLE}  > $ENSEMBLE_FEAT"
eval "cat ${OUT_DIR}/${TEST_DATA} | ${FEATURIZER_ENSEMBLE}  > $TEST_FEAT"

#training
TRAIN_OPTS="learn -a ap"
RUN_CMD="${CRF} ${TRAIN_OPTS} -m ${MODEL} ${ENSEMBLE_FEAT}"
eval "${RUN_CMD}"

#prediction 
TEST_OPTS="tag -r"
RUN_CMD="${CRF} ${TEST_OPTS} -m ${MODEL} ${TEST_FEAT}"
eval "${RUN_CMD} > ${TEST_FEAT}.results"

echo "(ensemble) ${TEST_FEAT} finish prediction"

cat ${TEST_FEAT}.results | tr '\t' ' ' | perl -ne '{chomp;s/\r//g;print $_,"\n";}' | ${EVAL} > ${TEST_FEAT}.SUMMARY
cat ${TEST_FEAT}.SUMMARY
