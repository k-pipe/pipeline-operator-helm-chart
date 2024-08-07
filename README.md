# Helm chart for pipeline-operator

This repository contains the definition of the helm chart for the kubernetes pipeline operator provided by k-pipe.cloud under [helm.kpipe.cloud/operator](https://helm.kpipe.cloud/operator).

## Organization of repository 

The following elements (found in the main branch of the repo) are required:

 - the chart definition [Chart.yaml](./charts/pipeline/Chart.yaml)
 - text file holding [current version](./version) tag
 - the [custom resource definitions](./charts/pipeline/crds) for setting up the pipeline CRDs  
 - kubernetes manifest templates are placed in folder [templates](./charts/pipeline/templates)

## CICD process

Updates to the following files 
 - [charts/pipeline/Chart.yaml](./charts/pipeline/Chart.yaml)
 - [version](./version)
 - [charts/pipeline/crds/*](./charts/pipeline/crds)
 - [charts/pipeline/templates/values.yaml](./charts/pipeline/templates/values.yaml) 
 - [charts/pipeline/templates/NOTES.txt](./charts/pipeline/templates/NOTES.txt)
are supposed to get pushed automatically into this repo from the build process of the controller (in [this github repo](https://github.com/k-pipe/pipeline-operator/)). 

Before releasing the helm chart, a set of [integration tests](./tests) will be executed (on a local [kind](https://kind.sigs.k8s.io/) kubernetes cluster).

The chart is only released if all tests pass. The release process is a predefined github action which pushes into branch [gh-pages](https://github.com/k-pipe/pipeline-operator-helm-chart/tree/gh-pages).
From there the chart gets published automatically (as [github pages](https://github.com/k-pipe/pipeline-operator-helm-chart/settings/pages)) as
github [web site](https://k-pipe.github.io/pipeline-operator-helm-chart/). 

This website is made accessible from the domain [helm.kpipe.cloud/operator](https://helm.kpipe.cloud/operator) by means of A/AAAA mapping of DNS entries for the domain to 
one of the the github IP4/IP6 addresses.

