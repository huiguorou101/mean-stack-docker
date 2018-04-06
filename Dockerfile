FROM ubuntu:16.04

MAINTAINER Yu Niu, niuyu@me.com

# Set up system users
RUN groupadd -g 1000 user
RUN useradd -r -u 1000 -g user user
RUN adduser user sudo
RUN echo "root:use4Tst!" | chpasswd
RUN echo "user:use4Tst!" | chpasswd
RUN mkdir -p /home/user
RUN chmod 777 /home/user
RUN touch /home/user/.sudo_as_admin_successful

# Set up system tools
RUN apt-get update
RUN apt-get install -y sudo
RUN apt-get install -y git
RUN apt-get install -y wget
RUN apt-get install -y bzip2
RUN apt-get install -y curl
RUN apt-get install -y vim

# Install Python 3
RUN apt-get install -y python3
RUN wget https://bootstrap.pypa.io/get-pip.py
RUN python3 get-pip.py
RUN rm -rf get-pip.py
RUN pip3 install numpy scipy matplotlib ipython jupyter pandas sympy nose
RUN pip3 install scikit-learn
RUN pip3 install pandas
RUN pip3 install pika
RUN pip3 install requests
RUN pip3 install tables
RUN pip3 install pymongo

# Set up Erlang 20.3-1
RUN wget http://packages.erlang-solutions.com/site/esl/esl-erlang/FLAVOUR_1_general/esl-erlang_20.3-1~ubuntu~xenial_amd64.deb
RUN dpkg -i esl-erlang_20.3-1~ubuntu~xenial_amd64.deb; exit 0
RUN apt-get install -y -f
RUN rm -rf esl-erlang_20.3-1~ubuntu~xenial_amd64.deb

# Set up RabbitMQ Latest
RUN curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.deb.sh | bash
RUN apt-get install -y rabbitmq-server

# Set up MongoDB Latest
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2930ADAE8CAF5059EE73BB4B58712A2291FA4AD5
RUN echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.6 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.6.list
RUN apt-get update
RUN apt-get install -y mongodb-org
RUN mkdir -p /data/db
RUN chmod 777 /data/db

# Set up NodeJS 8.x
RUN curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
RUN apt-get install -y nodejs

# Set up Gulp Latest
RUN npm uninstall -g gulp
RUN npm install -g gulp
WORKDIR /srv/one-dash
RUN npm install gulp -D

ENTRYPOINT (mongod --quiet > /dev/null) & (rabbitmq-server > /dev/null) & (su user); bash
