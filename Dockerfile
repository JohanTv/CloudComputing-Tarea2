FROM ubuntu:latest

ARG spark_tmp="/spark_tmp/"

RUN set -ex; \
    apt-get update; \ 
    apt install -y wget openjdk-8-jdk python2; \
 	mkdir -p /opt/spark; \
    mkdir /opt/spark/python; \
    mkdir -p /opt/spark/examples; \
    mkdir -p /opt/spark/work-dir; \
    touch /opt/spark/RELEASE; \
    rm -rf /var/lib/apt/lists/*; \
    rm -rf /var/cache/oracle-jdk8-installer;

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/
RUN export JAVA_HOME

ENV PYSPARK_PYTHON python2
RUN export PYSPARK_PYTHON

ENV SPARK_TGZ_URL=https://archive.apache.org/dist/spark/spark-1.3.0/spark-1.3.0-bin-hadoop2.4.tgz 

RUN set -ex; \
    mkdir ${spark_tmp}; \
    cd ${spark_tmp}; \
    wget -nv -O spark.tgz "$SPARK_TGZ_URL"; \
    tar -xf spark.tgz --strip-components=1; \
    mv RELEASE /opt/spark/; \
    mv bin /opt/spark/; \
    mv lib /opt/spark/; \
    mv sbin /opt/spark/; \
    mv examples /opt/spark/; \
    mv data /opt/spark/; \
    mv python/pyspark /opt/spark/python/pyspark/; \
    mv python/lib /opt/spark/python/lib/; \
    cd ..; \
    rm -rf ${spark_tmp};

ENV SPARK_HOME /opt/spark
ENV PATH $SPARK_HOME/bin:$PATH
RUN export PATH

RUN mkdir -p /home/app
ENV APP_HOME=/home/app

WORKDIR ${APP_HOME}

COPY App/WordCount.py ${APP_HOME}

CMD [ "/bin/bash" ]