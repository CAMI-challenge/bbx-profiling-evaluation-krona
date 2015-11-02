FROM ubuntu:14.04
MAINTAINER Peter Belmann, pbelmann@cebitec.uni-bielefeld.de

RUN sudo apt-get update

RUN sudo apt-get install -y wget curl jq

ENV INSTALL_DIR /usr/local/bin

ENV CONVERT https://github.com/bronze1man/yaml2json/raw/master/builds/linux_386/yaml2json

RUN cd ${INSTALL_DIR} && wget --quiet ${CONVERT} && chmod 700 yaml2json 

RUN wget http://sourceforge.net/projects/krona/files/latest/download -O ${INSTALL_DIR}/krona.tar

RUN tar  xvf  ${INSTALL_DIR}/krona.tar --directory ${INSTALL_DIR}  --strip-components=1

RUN cd ${INSTALL_DIR} && install.pl

ADD krona.pl ${INSTALL_DIR}/

ADD krona.sh ${INSTALL_DIR}/

ADD validate ${INSTALL_DIR}/

ADD profiletokrona.pl ${INSTALL_DIR}/

ADD Taskfile /

ENV TERM xterm

ENTRYPOINT ["validate"]
