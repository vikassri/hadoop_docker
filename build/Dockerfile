FROM openjdk:8-jdk
MAINTAINER Vikas Srivastava

USER root

# Install sbt
ENV SBT_VERSION 0.13.15
RUN wget http://dl.bintray.com/sbt/debian/sbt-${SBT_VERSION}.deb -O /tmp/sbt.deb && \
    dpkg -i /tmp/sbt.deb && \
    rm -f /tmp/sbt.deb

RUN apt-get update \
  && apt-get install -y python3-pip python3-dev vim curl openssh-server\
  && cd /usr/local/bin \
  && ln -s /usr/bin/python3 python \
  && pip3 install --upgrade pip


### Installing pip packages ###
ENV prequirements="pymysql requests numpy pandas"
RUN pip install $prequirements

# passwordless ssh
RUN rm /etc/ssh/ssh_host_rsa_key \
&& ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key \
&& ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key \
&& ssh-keygen -q -N "" -t rsa -f /root/.ssh/id_rsa
RUN cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys

# Install Hadoop
ENV HADOOP_VERSION=2.7.3
ENV HADOOP_HOME /opt/hadoop-$HADOOP_VERSION
ENV HADOOP_CONF_DIR=$HADOOP_HOME/conf
ENV PATH $PATH:$HADOOP_HOME/bin 
ENV PATH $PATH:$HADOOP_HOME/sbin  
RUN curl -sL \
  "https://archive.apache.org/dist/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz" \
    | gunzip \
    | tar -x -C /opt/ \
  && rm -rf $HADOOP_HOME/share/doc \
  && chown -R root:root $HADOOP_HOME \
  && mkdir -p $HADOOP_HOME/logs \
  && mkdir -p $HADOOP_CONF_DIR \
  && chmod 777 $HADOOP_CONF_DIR \
  && chmod 777 $HADOOP_HOME/logs 

# pseudo distributed = connects to "remote" server @ localhost
RUN cp $HADOOP_HOME/etc/hadoop/* $HADOOP_CONF_DIR && rm  $HADOOP_CONF_DIR/core-site.xml $HADOOP_CONF_DIR/hdfs-site.xml
ADD files/core-site.xml.template $HADOOP_CONF_DIR/core-site.xml.template
RUN sed s/HOSTNAME/localhost/ $HADOOP_CONF_DIR/core-site.xml.template > $HADOOP_CONF_DIR/core-site.xml

ADD files/hdfs-site.xml $HADOOP_CONF_DIR/hdfs-site.xml
ADD files/slaves $HADOOP_CONF_DIR/slaves

#   Formats the namenode
RUN $HADOOP_HOME/bin/hdfs namenode -format

#   Add ssh config, setting permissions as well
ADD files/ssh_config /root/.ssh/config
RUN chmod 600 /root/.ssh/config
RUN chown root:root /root/.ssh/config

#   Remove references to edcsa / ed25519 keys -- we're only going to ssh from localhost
RUN sed -i.backup -e '/^HostKey.*\(ecdsa\|ed25519\)/s/^/#/' /etc/ssh/sshd_config

# Install Hive
ENV HIVE_VERSION=2.0.1
ENV HIVE_HOME=/opt/apache-hive-$HIVE_VERSION-bin
ENV HIVE_CONF_DIR=$HIVE_HOME/conf
ENV PATH $PATH:$HIVE_HOME/bin
RUN curl -sL \
  "https://archive.apache.org/dist/hive/hive-$HIVE_VERSION/apache-hive-$HIVE_VERSION-bin.tar.gz" \
    | gunzip \
    | tar -x -C /opt/ \
  && chown -R root:root $HIVE_HOME \
  && mkdir -p $HIVE_HOME/hcatalog/var/log \
  && mkdir -p $HIVE_HOME/var/log \
  && mkdir -p /data/hive/ \
  && mkdir -p $HIVE_CONF_DIR \
  && chmod 777 $HIVE_HOME/hcatalog/var/log \
  && chmod 777 $HIVE_HOME/var/log 

# Configure
ADD files/hive-site.xml $HIVE_CONF_DIR/

# creating required folder and adding files 
RUN mkdir -p /home/scripts
ADD weather /home/scripts
RUN mkdir /home/data
RUN chmod 755 -R /home/scripts


ADD files/init.sh /

EXPOSE 22
EXPOSE 4040
EXPOSE 9083
EXPOSE 50070
EXPOSE 8020
EXPOSE 8088
EXPOSE 10000

ENTRYPOINT ["/init.sh"]