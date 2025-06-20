FROM ubuntu:20.04

# 设置非交互式安装
ENV DEBIAN_FRONTEND=noninteractive

RUN cp /etc/apt/sources.list /etc/apt/sources.list.backup && \
    echo "deb http://mirrors.163.com/ubuntu/ focal main restricted universe multiverse" > /etc/apt/sources.list && \
    echo "deb http://mirrors.163.com/ubuntu/ focal-security main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb http://mirrors.163.com/ubuntu/ focal-updates main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb http://mirrors.163.com/ubuntu/ focal-backports main restricted universe multiverse" >> /etc/apt/sources.list

# 安装基本依赖
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    gcc \
    make \
    perl \
    python3 \
    zlib1g-dev \
    libbz2-dev \
    liblzma-dev \
    libncurses5-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt
# 安装 Bowtie2
RUN wget https://sourceforge.net/projects/bowtie-bio/files/bowtie2/2.5.4/bowtie2-2.5.4-linux-x86_64.zip && \
    unzip bowtie2-2.5.4-linux-x86_64.zip && \
    rm bowtie2-2.5.4-linux-x86_64.zip

# 安装 Bismark
RUN wget https://github.com/FelixKrueger/Bismark/archive/refs/tags/v0.24.2.tar.gz && \
    tar -xzf v0.24.2.tar.gz && \
    rm v0.24.2.tar.gz && \
    mv Bismark-0.24.2 Bismark

# install samtools
RUN wget https://github.com/samtools/samtools/releases/download/1.15/samtools-1.15.tar.bz2 && \
    tar -xjf samtools-1.15.tar.bz2 && \
    rm samtools-1.15.tar.bz2 && \
    cd samtools-1.15 && \
    ./configure && \
    make && \
    make install

ENV PATH="/opt/Bismark/:$PATH"
ENV PATH="/opt/bowtie2-2.5.4-linux-x86_64/:$PATH"

# 安装 Samtools
#RUN wget https://github.com/samtools/samtools/releases/download/1.15/samtools-1.15.tar.bz2 && \
#    tar -xjf samtools-1.15.tar.bz2 && \
#    rm samtools-1.15.tar.bz2 && \
#    cd samtools-1.15 && \
#    ./configure && \
#    make && \
#    make install