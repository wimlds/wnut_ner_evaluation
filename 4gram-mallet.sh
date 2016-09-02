#!/bin/bash

FLAG=$1

DATA_DIR="./data/"
OUT_DIR="./result_3/${FLAG}"

TRAIN_DATA="train"
TEST_DATA="dev"
#TRAIN_DATA="train_notype"
#TEST_DATA="dev_notype"
TRAIN_FEAT='train.mallet_fs'
TEST_FEAT=${OUT_DIR}/${TEST_DATA}.feats

MODEL=${OUT_DIR}/${TRAIN_DATA}.model

MALLET_PATH="/home/mariana/Documents/MestriaUNC/Tesina/Code/Mallet/class:/home/mariana/Documents/MestriaUNC/Tesina/Code/Mallet/lib/mallet-deps.jar"
CRF="cc.mallet.fst.SimpleTagger"
# EVAL="perl connlleval.pl"

mkdir -p ${OUT_DIR}


TRAIN_OPTS="--orders 1,2 --train true --model-file ${MODEL}"

RUN_CMD="java -cp ${MALLET_PATH} ${CRF} ${TRAIN_OPTS} ${TRAIN_FEAT}"
#training
eval "${RUN_CMD}"

#dumping a model
# ${CRF} dump ${MODEL} > ${MODEL}.txt
# 
TEST_OPTS="--model-file ${MODEL}"

RUN_CMD="java -cp ${MALLET_PATH} ${CRF} ${TRAIN_OPTS} ${TEST_FEAT}"

#prediction 
eval "${RUN_CMD} > ${TEST_FEAT}.results"

echo "${TEST_FEAT} finish prediction"

cat ${TEST_FEAT}.results | tr '\t' ' ' | perl -ne '{chomp;s/\r//g;print $_,"\n";}' | ${EVAL} > ${TEST_FEAT}.SUMMARY
cat ${TEST_FEAT}.SUMMARY
