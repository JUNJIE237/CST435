FROM ubuntu:14.04

WORKDIR /root

# install openssh-server, openjdk and wget
RUN apt-get update && apt-get install -y openssh-server openjdk-7-jdk wget


#ENV LD_LIBRARY_PATH=/usr/lib/gcc/x86_64-linux-gnu/11:$LD_LIBRARY_PATH


# Install required packages
RUN apt-get update && apt-get install -y \
    build-essential \
    wget \
    gawk \
    bison \
    python3 \
    texinfo


#RUN wget http://ftp.gnu.org/gnu/libc/glibc-2.34.tar.gz && \
#    tar -xvzf glibc-2.34.tar.gz && \
#    cd glibc-2.34 && \
#    mkdir build && cd build && \
#    ../configure --prefix=/opt/glibc-2.34 && \
#    make -j$(nproc) && \
#    make install


# Configure repositories to use EOL mirrors


# Add PPA for newer GCC versions and install GCC 11
#RUN add-apt-repository -y ppa:ubuntu-toolchain-r/test && \
#    apt-get update && \
RUN apt-get install -y g++
RUN apt-get install -y libstdc++6
# Step 3: Configure the dynamic linker to use the new glibc
#ENV LD_LIBRARY_PATH="/opt/glibc-2.34/lib"
#ENV LD_LIBRARY_PATH=/opt/glibc-2.34/lib:$LD_LIBRARY_PATH

#RUN LD_LIBRARY_PATH= apt-get update && apt-get install -y gcc-9 g++-9


#RUN LD_LIBRARY_PATH= apt-get update && apt-get install -y software-properties-common && \
    #add-apt-repository -y ppa:ubuntu-toolchain-r/test && \
    #apt-get update && apt-get install -y gcc-9 g++-9

#RUN apt-get install -y gcc-9 g++-9

# Step 2: Update the alternatives to use the new version of GCC
#RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 100 \
    #--slave /usr/bin/g++ g++ /usr/bin/g++-9
#RUN update-alternatives --config gcc




# install hadoop 2.7.2
RUN wget https://github.com/kiwenlau/compile-hadoop/releases/download/2.7.2/hadoop-2.7.2.tar.gz && \
    tar -xzvf hadoop-2.7.2.tar.gz && \
    mv hadoop-2.7.2 /usr/local/hadoop && \
    rm hadoop-2.7.2.tar.gz

# set environment variable
ENV JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64 
ENV HADOOP_HOME=/usr/local/hadoop 
ENV PATH=$PATH:/usr/local/hadoop/bin:/usr/local/hadoop/sbin 

# ssh without key
RUN ssh-keygen -t rsa -f ~/.ssh/id_rsa -P '' && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

RUN mkdir -p ~/hdfs/namenode && \ 
    mkdir -p ~/hdfs/datanode && \
    mkdir $HADOOP_HOME/logs

COPY config/* /tmp/

RUN mv /tmp/ssh_config ~/.ssh/config && \
    mv /tmp/hadoop-env.sh /usr/local/hadoop/etc/hadoop/hadoop-env.sh && \
    mv /tmp/hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml && \ 
    mv /tmp/core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml && \
    mv /tmp/mapred-site.xml $HADOOP_HOME/etc/hadoop/mapred-site.xml && \
    mv /tmp/yarn-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml && \
    mv /tmp/slaves $HADOOP_HOME/etc/hadoop/slaves && \
    mv /tmp/start-hadoop.sh ~/start-hadoop.sh && \
    mv /tmp/run-wordcount.sh ~/run-wordcount.sh && \
    mv /tmp/mapper.cpp ~/mapper.cpp && \
    mv /tmp/reducer.cpp ~/reducer.cpp && \
    mv /tmp/weather_dataset.txt ~/weather_dataset.txt && \
    mv /tmp/run-average.sh ~/run-average.sh
    
RUN g++ -o ~/mapper ~/mapper.cpp
RUN g++ -o ~/reducer ~/reducer.cpp
RUN chmod +x ~/mapper 
RUN chmod +x ~/reducer 
RUN chmod +x ~/run-average.sh

RUN chmod +x ~/start-hadoop.sh && \
    chmod +x ~/run-wordcount.sh && \
    chmod +x $HADOOP_HOME/sbin/start-dfs.sh && \
    chmod +x $HADOOP_HOME/sbin/start-yarn.sh 

# format namenode
RUN /usr/local/hadoop/bin/hdfs namenode -format

CMD [ "sh", "-c", "service ssh start; bash"]