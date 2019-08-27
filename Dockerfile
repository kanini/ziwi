FROM gitpod/workspace-dotnet-vnc:latest

USER gitpod

# Our dotfiles improve Vim and sqlite3.
COPY ["dotfiles/*","/home/gitpod/"]

# Default to production:
# https://github.com/nodejs/docker-node/blob/master/docs/BestPractices.md
# Set NODE_PATH so globally installed modules will be found:
# https://nodejs.org/api/modules.html#modules_loading_from_the_global_folders
ENV NODE_ENV=production NODE_PATH=/usr/local/lib/node_modules

# Use .nvmrc then install global Node packages
COPY [".nvmrc","/home/gitpod"]
RUN /bin/bash -c "cd /home/gitpod && source /home/gitpod/.nvm/nvm.sh && nvm install && yes | npm install --global @angular/cli prettier"

# Give back control
USER root
