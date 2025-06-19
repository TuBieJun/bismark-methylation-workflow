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

# 安装 Bowtie
WORKDIR /opt
RUN wget https://sourceforge.net/projects/bowtie-bio/files/bowtie/1.3.1/bowtie-1.3.1-linux-x86_64.zip && \
    unzip bowtie-1.3.1-linux-x86_64.zip && \
    rm bowtie-1.3.1-linux-x86_64.zip && \
    ln -s /opt/bowtie-1.3.1-linux-x86_64/bowtie /usr/local/bin/ && \
    ln -s /opt/bowtie-1.3.1-linux-x86_64/bowtie-build /usr/local/bin/ && \
    ln -s /opt/bowtie-1.3.1-linux-x86_64/bowtie-inspect /usr/local/bin/

# 安装 Samtools
RUN wget https://github.com/samtools/samtools/releases/download/1.15/samtools-1.15.tar.bz2 && \
    tar -xjf samtools-1.15.tar.bz2 && \
    rm samtools-1.15.tar.bz2 && \
    cd samtools-1.15 && \
    ./configure && \
    make && \
    make install

# 安装 Bismark
RUN wget https://github.com/FelixKrueger/Bismark/archive/refs/tags/0.24.0.tar.gz && \
    tar -xzf 0.24.0.tar.gz && \
    rm 0.24.0.tar.gz && \
    ln -s /opt/Bismark-0.24.0/bismark /usr/local/bin/ && \
    ln -s /opt/Bismark-0.24.0/bismark_genome_preparation /usr/local/bin/ && \
    ln -s /opt/Bismark-0.24.0/bismark_methylation_extractor /usr/local/bin/

# 设置工作目录
WORKDIR /data

# 验证安装
RUN bismark --version && \
    bowtie --version && \
    samtools --version