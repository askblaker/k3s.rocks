FROM python:3.8-slim-buster

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

WORKDIR /app/

RUN apt-get -y update && \
    apt-get -y upgrade && \
    apt-get -y dist-upgrade

COPY ./app/requirements.txt ./

RUN pip install --no-cache-dir -r /app/requirements.txt && \
    rm requirements.txt

COPY ./app ./
RUN chmod +x ./start.sh

ENV PYTHONPATH /app

CMD ["./start.sh"]