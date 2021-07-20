FROM php:alpine3.11

LABEL maintainer minostauros <6764739+minostauros@users.noreply.github.com>

ENV TINYFILEMANAGER_VERSION=2.4.3
ENV TNYF_ADMIN_NICK=A1SDAdmin
ENV TNYF_ADMIN_PWD=ADMNIM123890
ENV TNYF_USR_NICK=A1SDUser
ENV TNYF_USR_PWD=PWD123890

RUN apk --update add git less openssh && \
    mkdir /app && \
    cd /app && \
    git clone --branch ${TINYFILEMANAGER_VERSION} \
    				   https://github.com/prasathmani/tinyfilemanager.git && \
    sed -i.bak -e "s/\$root\_path = \$\_SERVER\['DOCUMENT_ROOT'\];/\$root_path = \'\/data\';/g" \
                  /app/tinyfilemanager/tinyfilemanager.php && \
    sed -i.bak -e "s/\$root\_path = \$\_SERVER\['DOCUMENT_ROOT'\];/\$root_path = \'\/data\';/g" \
                  /app/tinyfilemanager/config.php && \
    sed -i -e "s/'admin' /\$_ENV[\"TNYF_ADMIN_NICK\"] /" /app/tinyfilemanager/tinyfilemanager.php && \
    sed -i -e "s/'user' /\$_ENV[\"TNYF_USR_NICK\"] /" /app/tinyfilemanager/tinyfilemanager.php && \
    sed -i -e "s/'\$2y\$10\$\/K\.hjNr84lLNDt8fTXjoI\.DBp6PpeyoJ\.mGwrrLuCZfAwfSAGqhOW'/password_hash(\$_ENV[\"TNYF_ADMIN_PWD\"], PASSWORD_DEFAULT) /" /app/tinyfilemanager/tinyfilemanager.php && \
    sed -i -e "s/'\$2y\$10\$Fg6Dz8oH9fPoZ2jJan5tZuv6Z4Kp7avtQ9bDfrdRntXtPeiMAZyGO'/password_hash(\$_ENV[\"TNYF_USR_PWD\"], PASSWORD_DEFAULT) /" /app/tinyfilemanager/tinyfilemanager.php && \
    sed -i -e "s/'admin' /\$_ENV[\"TNYF_ADMIN_NICK\"] /" /app/tinyfilemanager/config.php && \
    sed -i -e "s/'user' /\$_ENV[\"TNYF_USR_NICK\"] /" /app/tinyfilemanager/config.php && \
    sed -i -e "s/'\$2y\$10\$\/K\.hjNr84lLNDt8fTXjoI\.DBp6PpeyoJ\.mGwrrLuCZfAwfSAGqhOW'/password_hash(\$_ENV[\"TNYF_ADMIN_PWD\"], PASSWORD_DEFAULT) /" /app/tinyfilemanager/config.php && \
    sed -i -e "s/'\$2y\$10\$Fg6Dz8oH9fPoZ2jJan5tZuv6Z4Kp7avtQ9bDfrdRntXtPeiMAZyGO'/password_hash(\$_ENV[\"TNYF_USR_PWD\"], PASSWORD_DEFAULT) /" /app/tinyfilemanager/config.php && \
    apk del git less openssh && \
    rm -rf /var/lib/apt/lists/* && \
    rm /var/cache/apk/*

RUN apk --update add zip libzip-dev && \
    docker-php-ext-install zip fileinfo

WORKDIR /app/tinyfilemanager

ENTRYPOINT ["php"]
CMD ["-S", "0.0.0.0:80", "tinyfilemanager.php"]
