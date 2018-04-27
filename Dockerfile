FROM ubuntu:latest AS aws

ENV \
  AWSCLI_BUNDLE_URL="https://s3.amazonaws.com/aws-cli" \
  AWSCLI_BUNDLE_FILENAME="awscli-bundle"

RUN apt-get update

RUN apt-get -qq install -y \
  curl \
  python \
  unzip

WORKDIR /tmp

RUN curl -O "${AWSCLI_BUNDLE_URL}/${AWSCLI_BUNDLE_FILENAME}.zip"

RUN \
  unzip $AWSCLI_BUNDLE_FILENAME && \
  ./$AWSCLI_BUNDLE_FILENAME/install -i /usr/local/aws -b /usr/local/bin/aws


FROM circleci/node:latest

COPY --from=aws ["/usr/local/aws", "/usr/local/aws/"]
COPY --from=aws ["/usr/local/bin/aws", "/usr/local/bin/"]

RUN sudo chmod -R a+x /usr/local/aws
