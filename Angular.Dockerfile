FROM skipleam/devops-agent

RUN mkdir ng2
USER root
RUN chown -R vsts:vsts ng2
USER vsts

RUN mkdir ng \
    && cd ng \
    && npm install -g @angular/cli \
    && ng new installer \
    && cd installer \
    && npm i \
    && cd .. \
    && cd .. \
    && rm -rf ng

COPY package.json ./ng2/

RUN npm install -g node-sass

RUN cd ng2 \
  && npm i \
  && cd .. \
  && rm -rf ng2

USER vsts