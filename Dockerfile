FROM openjdk:8

# 安装maven
RUN curl https://docker-1252933230.cos.ap-shanghai.myqcloud.com/soft/apache-maven-3.9.3-bin.tar.gz -o /tmp/apache-maven-3.9.3-bin.tar.gz \
    && tar -zxvf /tmp/apache-maven-3.9.3-bin.tar.gz -C /usr/local/ \
    && rm -rf /tmp/apache-maven-3.9.3-bin.tar.gz
ENV MAVEN_HOME /usr/local/apache-maven-3.9.3
ENV PATH $PATH:$MAVEN_HOME/bin
RUN mvn -v

# 需改maven镜像为阿里云镜像
RUN mkdir -p /root/.m2 && touch /root/.m2/settings.xml \
    && echo '<?xml version="1.0" encoding="UTF-8"?>\n\
<settings>\n\
  <mirrors>\n\
    <mirror>\n\
        <id>aliyunmaven</id>\n\
        <mirrorOf>*</mirrorOf>\n\
        <name>阿里云公共仓库</name>\n\
        <url>https://maven.aliyun.com/repository/public</url>\n\
    </mirror>\n\
  </mirrors>\n\
</settings>' > /root/.m2/settings.xml

WORKDIR /usr/src/app
ADD . .

RUN mvn package -Dmadoven.test.skip=true

