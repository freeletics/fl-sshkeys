FROM python:2-alpine
LABEL maintainer="Freeletics GmbH <operations@freeletics.com>"

RUN pip install --upgrade pip
RUN pip install awscli
RUN apk add --update bash gawk
RUN adduser -D -u 500 core 
WORKDIR /

ENV IAM_GROUPS=""
USER core
ADD keys.sh /keys.sh
CMD ["/keys.sh"]
