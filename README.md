# devops-agent
A bare-bones Azure Devops agent supporting .NET Core and Node.

While trying to use to use Azure Container Instances as build agents, I found that the supplied microsoft/vsts-agent image takes so long to download that the Azure Function that provisions the ACI times out. I couldn't find a small image that supports the tools I need (`dotnet` and `npm`), so here it is.

[On Docker Hub](https://hub.docker.com/r/skipleam/devops-agent)
