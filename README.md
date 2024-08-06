
This page provides provides a helm chart for a kubernetes operator to define, run and schedule pipelines. 

## Getting started 

### Installation 

On a kubernetes cluster of your choice (e.g. locally using [kind](https://kind.sigs.k8s.io/docs/user/quick-start/)) install the operator with the following commands:

```
helm repo add k-pipe https://k-pipe.github.io/pipeline-operator/
helm install k-pipe k-pipe/pipeline-controller -n k-pipe
```

### Define a pipeline

Create the file `pipeline.yaml`:

```
apiVersion: pipeline.k-pipe.cloud/v1
kind: PipelineDefinition
metadata:
  name: "demo-pipeline-1.0.0"
spec:
  name: "demo-pipeline"
  version: "1.0.0"
  pipelineStructure:
    jobSteps:
    - id: stepa
      jobSpec:
        image: busybox
    - id: stepb
      jobSpec:
        image: busybox
    pipes:
    - from:
        stepId: stepa
        name: name1
      to:
        stepId: stepb
        name: name2
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
  name: "test-run"
spec:
  pipelineName: "demo-pipeline"
  versionPattern: "1.0.0"
```

Start the pipeline run:

```
kubectl apply -f run.yaml
```

Observe how the pipeline is executed:

```
kubectl get pods -w
```

You might also observe the state of the pipeline run change:

```
kubectl get pr test-run -w
```

### Schedule a pipeline


Create the file `schedule.yaml`:

```
apiVersion: pipeline.k-pipe.cloud/v1
kind: PipelineSchedule
...
spec:
  pipeline: "demo-pipeline"
  schedules:
    - cronSpec: "0 * * * *"
      versionPattern: "1.0.0"
```

Schedule the pipeline to be run automatically every full hour:

```
kubectl apply -f run.yaml
```

## Further information

For more examples and details of the setup and a specification to all functionality provided by the k-pipe operator have a look at the [documentation](https://k-pipe.github.io/pipeline-operator/doc).

The code for the operator can be found in this [github project](https://github.com/k-pipe/pipeline-operator).

## Licensing

TBD.

