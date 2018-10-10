FROM debian:stretch

ARG VSTS_VERSION=2.140.2

WORKDIR /agent
RUN useradd vsts

# base packages
RUN apt-get update \
    && apt-get install -y wget libicu-dev gnupg curl

# dotnet
RUN curl -sL https://dot.net/v1/dotnet-install.sh -o dotnet-install.sh \
    && chmod +x ./dotnet-install.sh \
    && ./dotnet-install.sh -c Current
ENV PATH /root/.dotnet:$PATH

# git
RUN apt-get install -y git

# node
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - \
    && apt-get install -y nodejs

# vsts agent
RUN curl -sL https://vstsagentpackage.azureedge.net/agent/$VSTS_VERSION/vsts-agent-linux-x64-$VSTS_VERSION.tar.gz -o agent.tar.gz \
    && tar xzf agent.tar.gz \
    && ./bin/installdependencies.sh \
# HACK - getting access errors on the build tasks.
# see if i can do away with a user account altogether. it's cool to run as admin, right? right?!
    && echo "Owning folders..." \
    && chown -R vsts:vsts /agent \
    && chown -R vsts:vsts /root \
    && chown -R vsts:vsts /home \
    && echo "...folders owned."

# cleanup
RUN rm -f ./dotnet-install.sh \
    && rm -f ./vsts-agent-linux-x64-$VSTS_VERSION.tar.gz \
    && rm -rf /var/lib/apt/lists/*

# verify -- uncomment this for troubleshooting
# RUN dotnet --version \
#     && node --version \
#     && npm --version

USER vsts

ENTRYPOINT ["/bin/bash", "-c", "./config.sh --unattended --replace && ./run.sh"]