FROM mcr.microsoft.com/mssql/server:2017-latest

# Create app directory
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# Bundle app source
COPY . /usr/src/app

# Grant permissions for the import-data script to be executable
RUN chmod +x /usr/src/app/*.sh

# Switch back to mssql user and run the entrypoint script
ENTRYPOINT /bin/bash ./entrypoint.sh
