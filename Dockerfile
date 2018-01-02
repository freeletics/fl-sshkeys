FROM python:2-alpine
LABEL maintainer="Freeletics GmbH <operations@freeletics.com>"

RUN pip install awscli==1.14.17
RUN apk add --update bash gawk
RUN adduser -D -u 500 core 
WORKDIR /

ENV IAM_GROUPS=""
USER core
COPY keys.sh /keys.sh
CMD ["/keys.sh"]
