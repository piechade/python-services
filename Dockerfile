FROM python:3

WORKDIR /usr/src

RUN apt-get update && apt-get install -y supervisor
RUN mkdir -p /var/log/supervisor
RUN mkdir -p /usr/src/log
COPY ./config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

COPY ./app/service-one/requirements.txt ./service-one/requirements.txt
COPY ./app/service-two/requirements.txt ./service-two/requirements.txt

WORKDIR /usr/src/service-one
RUN pip install --no-cache-dir -r requirements.txt

WORKDIR /usr/src/service-two
RUN pip install --no-cache-dir -r requirements.txt

COPY ./app/service-one/src /usr/src/service-one/src
COPY ./app/service-one/src /usr/src/service-two/src

WORKDIR /usr/src/service-one/src

# CMD [ "python", "./app.py" ]
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]