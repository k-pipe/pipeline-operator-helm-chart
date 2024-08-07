# Helm chart for pipeline-operator provided by k-pipe.cloud

This branch contains the definition of the helm chart for the pipeline operator.

The file [Chart.yaml](./charts/pipeline/Chart.yaml) is automically updated using the [current version](./version). The custom resource definitions are 
automatically pushed from the build process of the controller (in [this github repo]()). Files under [templates](./charts/pipeline/templates) contain the additional 
chart files which are created manually.

The chart is being released into branch [gh-pages](https://github.com/k-pipe/pipeline-operator-helm-chart/tree/gh-pages) 
from which it gets published automatically (as [github pages](https://github.com/k-pipe/pipeline-operator-helm-chart/settings/pages)) as
github [web site](https://k-pipe.github.io/pipeline-operator-helm-chart/). This is made accessible from the domain [helm.kpipe.cloud/operator](https://helm.kpipe.cloud/operator).

