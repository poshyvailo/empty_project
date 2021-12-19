ARG MYSQL_VERSION
FROM mysql:${MYSQL_VERSION}

ENV TZ=Europe/Kiev
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
