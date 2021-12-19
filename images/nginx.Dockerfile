ARG NGINX_VERSION
FROM nginx:${NGINX_VERSION}

# Set time
ENV TZ=Europe/Kiev
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
