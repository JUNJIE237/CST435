#!/bin/bash

# test the hadoop cluster by running wordcount

# create input files 

# create input directory on HDFS
hadoop fs -mkdir -p input

# put input files to HDFS
hdfs dfs -put ./weather_dataset.txt input

# run wordcount 
hadoop jar $HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming-*.jar \
    -input input \
    -output output \
    -mapper "$(pwd)/mapper" \
    -reducer "$(pwd)/reducer"
    

# print the output of wordcount
echo -e "\nAverage Temperature:"
hdfs dfs -cat output/part-00000