FROM nginx:latest
MAINTAINER korvinca@gmail.com

RUN echo "America/Los_Angeles" > /etc/timezone && \
    dpkg-reconfigure -f noninteractive tzdata 

RUN rm -v /etc/nginx/nginx.conf
ADD nginx.conf /etc/nginx/

COPY reload /usr/local/bin/reload
RUN chmod +x /usr/local/bin/reload

EXPOSE 80

CMD ["service nginx start"]