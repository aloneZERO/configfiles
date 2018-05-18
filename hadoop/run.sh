#!/bin/bash

VER=2.6.0
TIMEOUT=5
THREADS=2

COMMON_VERSION=${COMMON_VERSION:-${VER}}
HDFS_VERSION=${HDFS_VERSION:-${VER}}
YARN_VERSION=${YARN_VERSION:-${VER}}

SPARK_HADOOP_VERSION=2.0.0
SPARK_BENCH_VERSION=0.4.0

HIVE_VERSION=${HIVE_VERSION:-1.2.1}
TEZ_VERSION=${TEZ_VERSION:-0.7.1-SNAPSHOT-minimal}

ENV="JAVA_HOME=/usr/lib/jvm/jdk8 \
  YARN_CONF_DIR=/home/hadoop/conf \
  YARN_LOG_DIR=/home/hadoop/logs/hadoop \
  YARN_HOME=/home/hadoop/software/hadoop-${YARN_VERSION} \
  HADOOP_LOG_DIR=/home/hadoop/logs/hadoop \
  HADOOP_CONF_DIR=/home/hadoop/conf \
  HADOOP_USER_CLASSPATH_FIRST=1 \
  HADOOP_COMMON_HOME=/home/hadoop/software/hadoop-${COMMON_VERSION} \
  HADOOP_HDFS_HOME=/home/hadoop/software/hadoop-${HDFS_VERSION} \
  HADOOP_YARN_HOME=/home/hadoop/software/hadoop-${YARN_VERSION} \
  HADOOP_HOME=/home/hadoop/software/hadoop-${COMMON_VERSION} \
  HADOOP_BIN_PATH=/home/hadoop/software/hadoop-${COMMON_VERSION}/bin \
  HADOOP_SBIN=/home/hadoop/software/hadoop-${COMMON_VERSION}/bin \
  HIVE_HOME=/home/hadoop/software/hive-${HIVE_VERSION} \
  HIVE_LOG_DIR=/home/hadoop/logs/hive \
  TEZ_CONF_DIR=/home/hadoop/conf \
  TEZ_JARS=/home/hadoop/software/tez-${TEZ_VERSION} \
  SPARK_HOME=/home/hadoop/software/spark-${SPARK_HADOOP_VERSION}-bin-hadoop2.6 \
  SPARK_CONF_DIR=/home/hadoop/conf \
  SPARK_MASTER_IP=2.3.3.3 \
  SPARK_MASTER_HOST=hadoop-vm1 \
  SPARK_LOCAL_DIRS=/home/hadoop/storage/data/spark/rdds_shuffle \
  SPARK_LOG_DIR=/home/hadoop/logs/spark \
  SPARK_WORKER_DIR=/home/hadoop/logs/apps_spark \
  SPARK_BENCH_HOME=/home/hadoop/software/spark-bench_${SPARK_BENCH_VERSION} \
  ZEPPELIN_HOME=/home/hadoop/zeppelin"

case "$1" in
  (-q|--quiet)
    for i in ${ENV}
    do
      export $i
    done
    ;;
  (*)
    echo "setting variables:"
    for i in $ENV
    do
      echo $i
      export $i
    done
    ;;
esac

export HADOOP_CLASSPATH=$HADOOP_HOME:$HADOOP_CONF_DIR:$HIVE_HOME:$TEZ_JARS/*:$TEZ_JARS/lib/*:/home/hadoop/cora-hadoop-plugin/lib/*:
export HADOOP_HEAPSIZE=10240

export PATH=$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$HIVE_HOME/bin:$SPARK_HOME/bin:$SPARK_HOME/sbin:$SPARK_BENCH_HOME/bin:$PATH
export LD_LIBRARY_PATH=${HADOOP_COMMON_HOME}/share/hadoop/common/lib/native/:${LD_LIBRARY_PATH}
export JAVA_LIBRARY_PATH=${LD_LIBRARY_PATH}

export PYSPARK_PYTHON=python3
export PYTHONPATH=$SPARK_HOME/python:$SPARK_HOME/python/lib/py4j-0.10.1-src.zip:$PYTHONPATH
export PYTHONHASHSEED=0

start_hdfs(){
    printf "\n==== START HDFS daemons ! ====\n"
    hadoop-daemon.sh start namenode
    pdsh -R exec -f $THREADS -w ^machines ssh -o ConnectTimeout=$TIMEOUT %h '( . /home/hadoop/run.sh -q ; hadoop-daemon.sh start datanode;)'
    hadoop dfsadmin -safemode leave
}
stop_hdfs(){
    printf "\n==== STOP HDFS daemons ! ====\n"
    pdsh -R exec -f $THREADS -w ^machines ssh -o ConnectTimeout=$TIMEOUT %h '( . /home/hadoop/run.sh -q ; hadoop-daemon.sh stop datanode;)'
    hadoop-daemon.sh stop namenode
}

start_yarn(){
    printf "\n===== START YARN daemons ! ====\n"
    yarn-daemon.sh start resourcemanager
    pdsh -R exec -f $THREADS -w ^machines ssh -o ConnectTimeout=$TIMEOUT %h '( . /home/hadoop/run.sh -q ; yarn-daemon.sh start nodemanager;)'
}
stop_yarn(){
    printf "\n==== STOP YARN daemons ! ====\n"
    pdsh -R exec -f $THREADS -w ^machines ssh -o ConnectTimeout=$TIMEOUT %h '( . /home/hadoop/run.sh -q ; yarn-daemon.sh stop nodemanager;)'
    yarn-daemon.sh stop resourcemanager
}

start_history_mr(){
    printf "\n==== START M/R history server ! ====\n"
    mr-jobhistory-daemon.sh start historyserver
}
stop_history_mr(){
    printf "\n==== STOP M/R history server ! ====\n"
    mr-jobhistory-daemon.sh stop historyserver
}

start_timeline_server(){
    printf "\n==== START timelineserver ! ====\n"
    yarn-daemon.sh start timelineserver
}
stop_timeline_server(){
    printf "\n==== STOP timelineserver ! ====\n"
    yarn-daemon.sh stop timelineserver
}

start_spark(){
    printf "\n==== START SPARK daemons ! ====\n"
    $SPARK_HOME/sbin/start-master.sh
    pdsh -R exec -f $THREADS -w ^machines ssh -o ConnectTimeout=$TIMEOUT %h '( . /home/hadoop/run.sh -q ; $SPARK_HOME/sbin/start-slave.sh spark://$SPARK_MASTER_HOST:7077;)'
}
stop_spark(){
    printf "\n==== STOP SPARK daemons ! ====\n"
    $SPARK_HOME/sbin/stop-all.sh
}

start_history_spark(){
    printf "\n==== Star Spark History Server ! ====\n"
    $SPARK_HOME/sbin/start-history-server.sh
}
stop_history_spark(){
    printf "\n==== Stop Spark History Server ! ====\n"
    $SPARK_HOME/sbin/stop-history-server.sh
}

start_hive(){
    printf "\n==== START Hive metastore ! ====\n"
    nohup $HIVE_HOME/bin/hive --service metastore >> $HIVE_LOG_DIR/metastore.log 2>&1 &
    echo $! > /home/hadoop/logs/hive/hive-metastore.pid
    printf "\n==== START Hive server ! ====\n"
    nohup $HIVE_HOME/bin/hive --service hiveserver2 >> $HIVE_LOG_DIR/hiveserver.log 2>&1 &
    echo $! > /home/hadoop/logs/hive/hive-server.pid
}

start_zeppelin(){
    printf "\n==== START Zeppelin server ! ====\n"
    $ZEPPELIN_HOME/bin/zeppelin-daemon.sh start
}
stop_zeppelin(){
    printf "\n==== STOP Zeppelin server ! ====\n"
    $ZEPPELIN_HOME/bin/zeppelin-daemon.sh stop
}

start_all(){
    start_hdfs
    start_yarn
    start_timeline_server
    start_history_mr
    start_spark
    start_history_spark
    start_hive
    start_zeppelin
}
stop_all(){
    stop_zeppelin
    stop_history_spark
    stop_spark
    stop_hdfs
    stop_yarn
    stop_timeline_server
    stop_history_mr
}

start_pyspark(){
    $SPARK_HOME/bin/pyspark --master spark://$SPARK_MASTER_HOST:7077
}
start_pyspark_yarn(){
    $SPARK_HOME/bin/pyspark --master yarn
}

export -f start_hdfs
export -f stop_hdfs
export -f start_yarn
export -f stop_yarn
export -f start_history_mr
export -f stop_history_mr
export -f start_timeline_server
export -f stop_timeline_server
export -f start_spark
export -f stop_spark
export -f start_history_spark
export -f stop_history_spark
export -f start_zeppelin
export -f stop_zeppelin
export -f start_all
export -f stop_all
export -f start_pyspark
export -f start_pyspark_yarn
