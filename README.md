# Helm chart for pipeline-operator provided by k-pipe.cloud

This branch contains the definition of the helm chart for the pipeline operator.

The file [Chart.yaml](./charts/pipeline/Chart.yaml) is automically updated using the [current version](./version). The [custom resource definitions](./charts/crds) are 
supposed to be pushed automatically into this repo from the build process of the controller (in [this github repo](https://github.com/k-pipe/pipeline-operator/)). Files under [templates](./charts/pipeline/templates) contain the additional 
chart files which are created manually.

Before releasing the helm chart, a set of [integration tests](./tests) will be executed (on a local [kind](https://kind.sigs.k8s.io/) kubernetes cluster).
The chart is only released if all tests pass. The release process is a predefined github action which pushes into branch [gh-pages](https://github.com/k-pipe/pipeline-operator-helm-chart/tree/gh-pages).
From there the chart gets published automatically (as [github pages](https://github.com/k-pipe/pipeline-operator-helm-chart/settings/pages)) as
github [web site](https://k-pipe.github.io/pipeline-operator-helm-chart/). This is made accessible from the domain [helm.kpipe.cloud/operator](https://helm.kpipe.cloud/operator).

