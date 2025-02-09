FROM python:latest

COPY waf-mock-reqs.txt r.txt
RUN pip install -r r.txt

ADD . /app
WORKDIR /app
