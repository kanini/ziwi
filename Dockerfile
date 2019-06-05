FROM gitpod/workspace-dotnet-vnc:latest

# Install PostgreSQL
# See https://github.com/gitpod-io/workspace-images/blob/master/postgres/Dockerfile
RUN sudo apt-get update \
 && sudo apt-get install -y postgresql postgresql-contrib \
 && sudo apt-get clean \
 && sudo rm -rf /var/cache/apt/* /var/lib/apt/lists/* /tmp/*

# Setup PostgreSQL server for user gitpod
USER gitpod
ENV PATH="$PATH:/usr/lib/postgresql/10/bin"
ENV PGDATA="/home/gitpod/.pg_ctl/data"
RUN mkdir -p ~/.pg_ctl/bin ~/.pg_ctl/data ~/.pg_ctl/sockets \
 && initdb -D ~/.pg_ctl/data/ \
 && printf "#!/bin/bash\npg_ctl -D ~/.pg_ctl/data/ -l ~/.pg_ctl/log -o \"-k ~/.pg_ctl/sockets\" start\n" > ~/.pg_ctl/bin/pg_start \
 && printf "#!/bin/bash\npg_ctl -D ~/.pg_ctl/data/ -l ~/.pg_ctl/log -o \"-k ~/.pg_ctl/sockets\" stop\n" > ~/.pg_ctl/bin/pg_stop \
 && chmod +x ~/.pg_ctl/bin/*
ENV PATH="$PATH:$HOME/.pg_ctl/bin"
ENV DATABASE_URL="postgresql://gitpod@localhost"

# This is a bit of a hack. At the moment we have no means of starting background
# tasks from a Dockerfile. This workaround checks, on each bashrc eval, if the
# PostgreSQL server is running, and if not starts it.
RUN printf "\n# Auto-start PostgreSQL server.\n[[ \$(pg_ctl status | grep PID) ]] || pg_start > /dev/null\n" >> ~/.bashrc

# Default to production:
# https://github.com/nodejs/docker-node/blob/master/docs/BestPractices.md
# Set NODE_PATH so globally installed modules will be found:
# https://nodejs.org/api/modules.html#modules_loading_from_the_global_folders
ENV NODE_ENV=production NODE_PATH=/usr/local/lib/node_modules

# Install Node Version Manager
COPY ["install-nvm.sh","/home/gitpod"]
RUN cd /home/gitpod \
 && chmod +x install-nvm.sh \
 && ./install-nvm.sh

# Use .nvmrc then global Node packages
COPY [".nvmrc","/home/gitpod"]
RUN cd /home/gitpod \
 && nvm install \
 && npm install --global @angular/cli prettier

# Give back control
USER root
