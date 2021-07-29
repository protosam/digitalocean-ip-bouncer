FROM python:3-alpine

COPY ./src /usr/src
RUN apk add -U bash && \
    pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r /usr/src/requirements.txt

ENTRYPOINT bash /usr/src/entry.sh