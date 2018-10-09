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
ENV PATH /root/.dotnet:$PATH
RUN rm -f ./dotnet-install.sh

# other build dependencies
RUN apt-get update
RUN apt-get install -y git
RUN apt-get install -y nodejs

# vsts agent
ADD https://vstsagentpackage.azureedge.net/agent/$VSTS_VERSION/vsts-agent-linux-x64-$VSTS_VERSION.tar.gz .
RUN tar xzf vsts-agent-linux-x64-$VSTS_VERSION.tar.gz \
  && ./bin/installdependencies.sh
RUN rm -f ./vsts-agent-linux-x64-$VSTS_VERSION.tar.gz

# HACK - getting access errors on the build tasks.
# see if i can do away with a user account altogether. it's cool to run as admin, right? right?!
RUN echo "Owning folders..."
RUN chown -R vsts:vsts /agent
RUN chown -R vsts:vsts /root
RUN chown -R vsts:vsts /home
RUN echo "...folders owned."

# cleanup
RUN rm -rf /var/lib/apt/lists/*

USER vsts

ENTRYPOINT ["/bin/bash", "-c", "./config.sh --unattended --replace && ./run.sh"]