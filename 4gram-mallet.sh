#!/bin/bash

FLAG=$1

DATA_DIR="./data/"
OUT_DIR="./result_3/${FLAG}"

TRAIN_DATA="eval_3_train_newclass"
TEST_DATA="eval_3_dev_newclass"
#TRAIN_DATA="train_notype"
#TEST_DATA="dev_notype"
TRAIN_FEAT='eval_3_train_newclass.mallet_fs'
TEST_FEAT=${OUT_DIR}/${TEST_DATA}.feats

MODEL=${OUT_DIR}/${TRAIN_DATA}.model

MALLET_PATH="/home/mariana/Documents/MestriaUNC/Tesina/Code/Mallet/class:/home/mariana/Documents/MestriaUNC/Tesina/Code/Mallet/lib/mallet-deps.jar"
CRF="cc.mallet.fst.SimpleTagger"
# EVAL="perl connlleval.pl"

mkdir -p ${OUT_DIR}


TRAIN_OPTS="--orders 1,2 --train true --model-file ${MODEL}"

RUN_CMD="java -Xmx2g -cp ${MALLET_PATH} ${CRF} ${TRAIN_OPTS} ${TRAIN_FEAT}"
#training
eval "${RUN_CMD}"

#dumping a model
# ${CRF} dump ${MODEL} > ${MODEL}.txt
# 
TEST_OPTS="--model-file ${MODEL}"

RUN_CMD="java -Xmx2g -cp ${MALLET_PATH} ${CRF} ${TRAIN_OPTS} ${DATA_DIR}/${TEST_DATA}"

#prediction 
eval "${RUN_CMD} > ${TEST_FEAT}.results"

echo "${TEST_FEAT} finish prediction"

# cat ${TEST_FEAT}.results | tr '\t' ' ' | perl -ne '{chomp;s/\r//g;print $_,"\n";}' | ${EVAL} > ${TEST_FEAT}.SUMMARY
# cat ${TEST_FEAT}.SUMMARY
