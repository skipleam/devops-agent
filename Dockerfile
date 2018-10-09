FROM debian:stretch

ARG VSTS_VERSION=2.140.2

WORKDIR /agent
RUN useradd vsts

# base packages
RUN apt-get update
RUN apt-get install -y wget
RUN apt-get install -y libicu-dev

# dotnet
ADD https://dot.net/v1/dotnet-install.sh .
RUN chmod +x ./dotnet-install.sh
RUN ./dotnet-install.sh -c Current
ENV PATH "$PATH:/root/.dotnet/dotnet"
RUN rm -f ./dotnet-install.sh

# other build dependencies
RUN apt-get update
RUN apt-get install -y git
RUN apt-get install -y nodejs

# vsts agent
ADD https://vstsagentpackage.azureedge.net/agent/$VSTS_VERSION/vsts-agent-linux-x64-$VSTS_VERSION.tar.gz .
RUN tar xzf vsts-agent-linux-x64-$VSTS_VERSION.tar.gz \
  && ./bin/installdependencies.sh \
  && chown -R vsts:vsts /agent
RUN rm -f ./vsts-agent-linux-x64-$VSTS_VERSION.tar.gz

# cleanup
RUN rm -rf /var/lib/apt/lists/*

USER vsts

ENTRYPOINT ["/bin/bash", "-c", "./config.sh --unattended --replace && ./run.sh"]