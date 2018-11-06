# devops-agent
![Docker Build](https://img.shields.io/docker/build/jrottenberg/ffmpeg.svg)

A bare-bones Azure DevOps agent supporting .NET Core and Node.

While trying to use to use Azure Container Instances as build agents, I found that the supplied microsoft/vsts-agent image takes so long to download that the Azure Function that provisions the ACI times out. I couldn't find a small image that supports the tools I need (`dotnet` and `npm`), so here it is.

[On Docker Hub](https://hub.docker.com/r/skipleam/devops-agent)

## Usage
### Local
```bash
docker run --rm \
    -e VSTS_AGENT_INPUT_URL=https://dev.azure.com/<your-devops-project> \
    -e VSTS_AGENT_INPUT_AUTH=pat \
    -e VSTS_AGENT_INPUT_TOKEN=<your-token> \
    -e VSTS_AGENT_INPUT_POOL=<pool-name> \
    -e VSTS_AGENT_INPUT_AGENT=<agent-name> \
    -it skipleam/devops-agent
```

### As an Azure Container Instance
More info _eventually™_.

Read [this article](https://www.noelbundick.com/posts/serverless-vsts-build-agents-with-azure-container-instances/) corresponding to repo [noelbundick/vsts-aci-build-agent](https://github.com/noelbundick/vsts-aci-build-agent).
