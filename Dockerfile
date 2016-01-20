FROM ubuntu:14.04
MAINTAINER Peter Belmann, pbelmann@cebitec.uni-bielefeld.de

RUN sudo apt-get update

RUN sudo apt-get install  -y --no-install-recommends ca-certificates wget curl jq python python-bs4 xz-utils

# Locations for biobox file validator
ENV VALIDATOR /bbx/validator/
ENV BASE_URL https://s3-us-west-1.amazonaws.com/bioboxes-tools/validate-biobox-file
ENV VERSION  0.x.y
RUN mkdir -p ${VALIDATOR}

# download the validate-biobox-file binary and extract it to the directory $VALIDATOR
RUN wget \
      --quiet \
      --output-document -\
      ${BASE_URL}/${VERSION}/validate-biobox-file.tar.xz \
    | tar xJf - \
      --directory ${VALIDATOR} \
      --strip-components=1

ENV PATH ${PATH}:${VALIDATOR}

ENV INSTALL_DIR /usr/local/bin

ENV CONVERT https://github.com/bronze1man/yaml2json/raw/master/builds/linux_386/yaml2json

RUN mkdir -p ${INSTALL_DIR} && cd ${INSTALL_DIR} && wget --quiet ${CONVERT} && chmod 700 yaml2json 

RUN wget http://sourceforge.net/projects/krona/files/latest/download -O ${INSTALL_DIR}/krona.tar

RUN tar xvf ${INSTALL_DIR}/krona.tar --directory ${INSTALL_DIR}  --strip-components=1

RUN wget "http://krona.sourceforge.net/src/krona-2.0.js" -O /krona.js

RUN cd ${INSTALL_DIR} && install.pl

ADD krona.pl ${INSTALL_DIR}/

ADD validate ${INSTALL_DIR}/

ADD profiletokrona.pl ${INSTALL_DIR}/

ADD Taskfile /

ADD htmlParser.py ${INSTALL_DIR}/

ADD schema.yaml /

ENV TERM xterm

ENTRYPOINT ["validate"]
