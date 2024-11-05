
This page provides provides a helm chart for a Kubernetes operator to define, run and schedule pipelines. 

## Getting Started 

### Installation 

On a K8s cluster of your choice (simplest way is to run one locally using [kind](https://kind.sigs.k8s.io/docs/user/quick-start/))
install the operator using the following commands:

```
helm repo add k-pipe https://helm.k-pipe.cloud
kubectl create namespace k-pipe
helm install k-pipe k-pipe/operator -n k-pipe
```

Wait for an operator pod to go live in the `k-pipe' namespace:
```
kubectl wait deployment -n k-pipe k-pipe-operator --for condition=Available=True --timeout=300s
```

### Define a pipeline

Create the file `pipeline.yaml`:

```
apiVersion: pipeline.k-pipe.cloud/v1
kind: PipelineDefinition
metadata:
  name: "hello-world-1.0.0"
spec:
  pipelineName: "hello-world"
  version: "1.0.0"
  pipelineStructure:
    jobSteps:
    - id: step1
      image: busybox
      command: ["sh", "-c", "echo hello world && sleep 30"]
```

Create the pipeline:

```
kubectl apply -f pipeline.yaml
```

Check that the pipeline was created:

```
kubectl get pipelinedefinitions
```

### Run a pipeline

Create the file `run.yaml`:

```
apiVersion: pipeline.k-pipe.cloud/v1
kind: PipelineRun
metadata:
  name: "my-first-run"
spec:
  pipelineName: "hello-world"
  versionPattern: "1.0.0"
```

Start the pipeline run:

```
kubectl apply -f run.yaml
```

Observe the operator spinning up a pod:

```
kubectl get pods -w
```

When the pod has reached state `Terminating` you may stop pressing `Ctrl-c`.

Alternatively, restart the run and now follow the state of the pipeline execution looking at the run resource (`pr` is an
abbreviation for `pipelinerun`):

```
kubectl delete -f run.yaml
kubectl apply -f run.yaml
kubectl get pr my-first-run -w
```

If you interrupt (with `CTRL-c`) **while** the pod is still *running*, you may check the logs:

```
kubectl logs job/my-first-run-step1 -c main
```

If you wait too long, the pod will be gone (the operator cleans up succeeded jobs/pods after termination), 
but in the full documentation we will describe a better way to access the logs, anyway... 

### Schedule a pipeline

Create the file `schedule.yaml`:

```
apiVersion: pipeline.k-pipe.cloud/v1
kind: PipelineSchedule
metadata:
  name: "my-first-schedule"
spec:
  pipelineName: "hello-world"
  schedules:
    - cronSpec: "* * * * *"
      versionPattern: "1.0.0"
```

After applying this, you may observe your pipeline being executed every minute:

```
kubectl apply -f schedule.yaml
```

### Cleanup resources

First as an exercise try to find out which other kubernetes ressources are involved when defining/running/scheduling a 
pipeline (HINT: cm,sa,cj,job,pod,pvc,pv).

However, instances of those resources are marked with an `ownership reference` and will thus be cleaned up 
together with the owning resources. To get back to a clean state (in your current namespace), it suffices
to remove all created pipeline definitions/runs/schedules:

```
kubectl delete pd,pr,ps --all
```

## Run operator in GKE autopilot

For production use, running the cluster locally is obviously not a good idea. 
In order to run workloads with autoscaling of required resources, we recommend 
using a Google Kubernetes Engine (GKE) cluster in autopilot mode.

The setup of one or multiple GKE autopilot clusters with the pipeline operator 
already deployed is greatly simplified [using this terraform module](https://github.com/k-pipe/terraform-module-gke-autopilot).

To try it out follow the instructions given in [this example](https://github.com/k-pipe/terraform-module-gke-autopilot/blob/main/example/README.md).

### Limitations ok GKE

Due to lack of permissions, the scheduling of pipelines is not working in GKE clusters. One of the coming releases will 
fix this.

## Further information

For more examples and details of the setup and a specification to all functionality provided by the k-pipe operator have a look at the [documentation](https://helm.k-pipe.cloud/doc).


