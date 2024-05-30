FROM elixir:1.16.2

# Update default packages
RUN apt-get update

# Get Ubuntu packages
RUN apt-get install -y \
    build-essential \
    curl \
    libssl-dev \
    libdb-dev \
    unixodbc-dev

# install db2 cli
RUN wget https://public.dhe.ibm.com/ibmdl/export/pub/software/data/db2/drivers/odbc_cli/linuxx64_odbc_cli.tar.gz
RUN tar xvzf linuxx64_odbc_cli.tar.gz
RUN mkdir -p /opt/ibm/
RUN mv clidriver /opt/ibm/cli
RUN cp -r /opt/ibm/cli/lib /opt/ibm/cli/lib64
RUN echo "export DB2_CLI_DRIVER_HOME=/opt/ibm/cli" >> /etc/profile
RUN echo "export DB2CLIINIPATH=/opt/ibm/cli/cfg" >> /etc/profile
RUN echo "export PATH=\$PATH:/opt/ibm/cli/bin" >> /etc/profile
RUN echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:/opt/ibm/cli/lib64" >> /etc/profile
RUN echo "export IBM_DB_HOME=/opt/ibm/cli" >> /etc/profile
RUN echo "/opt/ibm/cli/lib64" >> /etc/ld.so.conf.d/db2.conf
RUN ldconfig

# Get Rust
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y

ENV PATH="/root/.cargo/bin:${PATH}"

RUN mix local.hex --force && mix local.rebar --force
