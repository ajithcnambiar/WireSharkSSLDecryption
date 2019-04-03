FROM ubuntu:latest

RUN apt-get update && apt-get install nginx -y && apt-get install libssl-dev -y

COPY localhost.crt /etc/ssl/certs/localhost.crt

COPY localhost.key /etc/ssl/private/localhost.key

COPY nginx.conf /etc/nginx/nginx.conf

COPY default /etc/nginx/sites-available/default

RUN nginx -t

RUN service nginx reload

CMD service nginx start && tail -f /var/log/nginx/access.log