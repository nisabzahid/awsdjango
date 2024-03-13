#pull official base image
FROM python:3.10-alpine3.16

ENV PYTHONUNBUFFERED 1
COPY requirements.txt /requirements.txt
RUN apk add --upgrade --no-cache build-base linux-headers && \
    pip install --upgrade pip && \
    pip install -r /requirements.txt 

COPY . .
WORKDIR /
RUN adduser --disabled-password --no-create-home django
RUN python manage.py migrate

USER django 
CMD ["uwsgi", "--socket", ":9000", "--workers", "4", "--master", "--enable-threads","--module", "app.wsgi"]