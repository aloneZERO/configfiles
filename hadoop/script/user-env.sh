# /etc/profile: system-wide .profile file for the Bourne shell (sh(1))
# and Bourne compatible shells (bash(1), ksh(1), ash(1), ...).

if [ "$PS1" ]; then
  if [ "$BASH" ] && [ "$BASH" != "/bin/sh" ]; then
    # The file bash.bashrc already sets the default PS1.
    # PS1='\h:\w\$ '
    if [ -f /etc/bash.bashrc ]; then
      . /etc/bash.bashrc
    fi
  else
    if [ "`id -u`" -eq 0 ]; then
      PS1='# '
    else
      PS1='$ '
    fi
  fi
fi

if [ -d /etc/profile.d ]; then
  for i in /etc/profile.d/*.sh; do
    if [ -r $i ]; then
      . $i
    fi
  done
  unset i
fi


# user env
export USER_HOME=/home/hadoop

# java env
export JAVA_HOME=${USER_HOME}/apps/java/jdk1.8
export JRE_HOME=${JAVA_HOME}/jre

# hadoop env
export HADOOP_HOME=${USER_HOME}/apps/hadoop/hadoop-2.6.0
export HADOOP_CONF_DIR=${HADOOP_HOME}/etc/hadoop
export HADOOP_COMMON_LIB_NATIVE_DIR=${HADOOP_HOME}/lib/native
export HADOOP_OPTS="$HADOOP_OPTS -Djava.library.path=${HADOOP_HOME}/lib/native"
export HADOOP_USER_CLASSPATH_FIRST=true
export HADOOP_LOG_DIR=${USER_HOME}/logs/hadoop
export YARN_LOG_DIR=${USER_HOME}/logs/yarn

# maven env
export M2_HOME=${USER_HOME}/apps/maven/maven-3.3.9

# hive env
export HIVE_HOME=${USER_HOME}/apps/hive/hive-1.2.2

# flume env
export FLUME_HOME=${USER_HOME}/apps/flume/flume-1.7.0

# zookeeper env
export ZOOKEEPER_HOME=${USER_HOME}/apps/zookeeper/zookeeper-3.4.10

# scala env
export SCALA_HOME=${USER_HOME}/apps/scala/scala-2.11.8

# spark env
export SPARK_HOME=${USER_HOME}/apps/spark/spark-2.0.0-bin-hadoop2.6

export CLASSPATH=.:${JAVA_HOME}/lib:${JRE_HOME}/lib:${HIVE_HOME}/lib:${SCALA_HOME}/lib

export PATH=.:$PATH:${JAVA_HOME}/bin:${SCALA_HOME}/bin:${HADOOP_HOME}/bin:${HADOOP_HOME}/sbin:${HIVE_HOME}/bin:${ZOOKEEPER_HOME}/bin:${FLUME_HOME}/bin:${SPARK_HOME}/bin:${SPARK_HOME}/sbin

