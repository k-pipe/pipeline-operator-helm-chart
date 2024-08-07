# Helm chart for pipeline-operator

This repository contains the definition of the helm chart for the kubernetes pipeline operator provided by k-pipe.cloud under [helm.kpipe.cloud/operator](https://helm.kpipe.cloud/operator).

## Organization of repository 

The following elements (found in the main branch of the repo) are required:

 - the chart definition [Chart.yaml](./charts/pipeline/Chart.yaml)
 - text file holding [current version](./version) tag
 - the [custom resource definitions](./charts/pipeline/crds) for setting up the pipeline CRDs  
 - the charts default settings [charts/pipeline/values.yaml](./charts/pipeline/values.yaml)
 - kubernetes manifest templates are placed in folder [templates](./charts/pipeline/templates)
   - deployment: [charts/pipeline/templates/deployment.yaml](./charts/pipeline/templates/deployment.yaml)
   - service account: [charts/pipeline/templates/serviceaccount.yaml](./charts/pipeline/templates/serviceaccount.yaml)
   - granting operator access to various resources: [charts/pipeline/templates/rbac.yaml](./charts/pipeline/templates/rbac.yaml)
   - predefined roles for tenants: [charts/pipeline/templates/tenantroles.yaml](./charts/pipeline/templates/tenantroles.yaml)


## CICD process

Updates to the following files 
 - [charts/pipeline/Chart.yaml](./charts/pipeline/Chart.yaml)
 - [version](./version)
 - [charts/pipeline/crds/*](./charts/pipeline/crds)
 - [charts/pipeline/templates/NOTES.txt](./charts/pipeline/templates/NOTES.txt)

are supposed to get pushed automatically into this repo from the build process of the pipeline controller docker image (which is done in [this github repo](https://github.com/k-pipe/pipeline-operator/)). 


Before releasing the helm chart, a set of [integration tests](./tests) will be executed (on a local [kind](https://kind.sigs.k8s.io/) kubernetes cluster).

The chart is only released if all tests pass. The release process is a predefined github action which pushes into branch [gh-pages](https://github.com/k-pipe/pipeline-operator-helm-chart/tree/gh-pages).
From there the chart gets published automatically (as [github pages](https://github.com/k-pipe/pipeline-operator-helm-chart/settings/pages)) as
web site under  [k-pipe.github.io/pipeline-operator-helm-chart](https://k-pipe.github.io/pipeline-operator-helm-chart). 

This website is made accessible from the domain [helm.k-pipe.cloud](https://helm.k-pipe.cloud) by means of A/AAAA mapping of DNS entries for the domain to 
one of the the github IP4/IP6 addresses.

## Documentation location

The [getting started page](https://helm.k-pipe.cloud) in the toot of the helm web site is defined by the [README.md in branch gh-pages](https://github.com/k-pipe/pipeline-operator-helm-chart/blob/gh-pages/README.md).
The sources of the [full documentation](https://helm.k-pipe.cloud/doc) can be found in the [subdirectory doc](https://github.com/k-pipe/pipeline-operator-helm-chart/tree/gh-pages/doc) of the branch gh-pages.

