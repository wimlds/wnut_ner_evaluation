#!/bin/bash

FLAG=4gram

DATA_DIR="./data/"
OUT_DIR="./result/${FLAG}"
mkdir -p $OUT_DIR

TRAIN_DATA="train_4gram"
TEST_DATA="dev_4gram"
TRAIN_FEAT=${OUT_DIR}/${TRAIN_DATA}.feats
TEST_FEAT=${OUT_DIR}/${TEST_DATA}.feats

MODEL=${OUT_DIR}/${TRAIN_DATA}.model

FEATURIZER="python ./featurizer.py"
CRF="crfsuite"
EVAL="perl connlleval.pl"

mkdir -p ${OUT_DIR}

echo "***** Running ${FEATURIZER} on ${TRAIN_DATA} (`date`) *****"
cat ${DATA_DIR}/${TRAIN_DATA} | ${FEATURIZER} > ${TRAIN_FEAT}

echo "***** Running ${FEATURIZER} on ${TRAIN_DATA} (`date`) *****"
cat ${DATA_DIR}/${TEST_DATA} | ${FEATURIZER}  > ${TEST_FEAT}

TRAIN_OPTS="learn -a ap"

RUN_CMD="${CRF} ${TRAIN_OPTS} -m ${MODEL} ${TRAIN_FEAT}"
#training
eval "${RUN_CMD}"

#dumping a model
${CRF} dump ${MODEL} > ${MODEL}.txt

TEST_OPTS="tag -r"

RUN_CMD="${CRF} ${TEST_OPTS} -m ${MODEL} ${TEST_FEAT}"

#prediction 
eval "${RUN_CMD} > ${TEST_FEAT}.results"

echo "${TEST_FEAT} finish prediction"

cat ${TEST_FEAT}.results | tr '\t' ' ' | perl -ne '{chomp;s/\r//g;print $_,"\n";}' | \
    perl ngram2token.pl $DATA_DIR/dev 4 |
    ${EVAL} > ${TEST_FEAT}.SUMMARY
cat ${TEST_FEAT}.SUMMARY
