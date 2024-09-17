
This page constitutes the documentation of the [k-pipe operator](https://helm.k-pipe.cloud), which provides 
an extension of kubernetes to define, execute and schedule processing pipelines as native K8s resources.

## Table of contents

- [1 - Introduction](#1---introduction)
- [2 - Getting Started](#2---getting-started)
- [3 - Reference](#3---reference)
  - [3.1 - Helm variables](#31---helm-variables)
    - [3.1.1 - Kubernetes settings](#311---kubernetes-settings)
    - [3.1.2 - Image repository classification](#312---image-repository-classification)
    - [3.1.3 - Init container](#313---init-container)
    - [3.1.4 - Resource estimation](#314---resource-estimation)

## 1 - Introduction

This helm chart deploys custom resource definitions (CRD) and a pipeline operator (plus a few additional ressources)
in kubernetes. Using those, the definition of workflows/pipelines/directed acyclic graphs (all synonyms for the same
concept) and their execution becomes possible on a plain kubernetes cluster (in a native fashion,
i.e. without running any additional services).

## 2 - Getting Started

For a first tour and a hands-on experience, we recommend to follow the examples in the 
[helm chart's top level README.md](..)

## 3 - Reference

### 3.1 - Helm variables

The following subsections document the helm variables that can be set when installing the k-pipe operator in order to customize  
according to your needs (or to match the requirements of your kubernetes provider).

The tables give the name of the variable, its type, the default setting which is used if the variable is not set and a description
of the purpose of the variable.

In some cases "string(map)" is specified as type. This means that a string to string map is supposed to be provided 
as string in the format "key1=value1;key2=value2;...". An empty string will be interpreted as empty map. The 
sequence of map entries is preserved and the implementation of the operator guarantees that map entries 
will be processed in the same order as they occur in the string (there are some cases where the order of the entries matters).

### 3.1.1 - Kubernetes settings

The following variables control certain generic aspects of kubernetes resources created when executing pipeline runs:

| Variable        | Type        | Default    | Description                                              |
|-----------------|-------------|------------|----------------------------------------------------------|
| nodeSelectorMap | string(map) | ""         | will be used as nodeSelector entry in the job spec       |
| storageClass    | string(map) | "standard" | will be used to set storage class of persistent volumes  |

### 3.1.2 - Image repository classification

The k-pipe operator allows restriction of docker repositories from which images for job step payloads will be accepted.
It also allows the assignment of a label depending on the origin of a docker image. These labels can then be used 
for various purposes in pod selectors.

| Variable            | Type        | Default | Description                                                    |
|---------------------|-------------|---------|----------------------------------------------------------------|
| imageRepoClassLabel | string      | ""      | the label key to be used for assigning repo class labels       |
| imageRepoClassesMap | string(map) | ""      | map from regex expressions to label values                     |
| jobImagePrefix      | string      | ""      | a prefix that will be added to all payload docker image specs  |

If `imageRepoClassesMap` is not empty, only docker images that match any of the regex expressions in the key set will
be accepted. The value of the first matching map entry will be used as value to be assigned to the label 
`imageRepoClassLabel`.

If `imageRepoClassLabel` is empty, no label will be assigned. However the map `imageRepoClassesMap` may still 
be set, in order to restrict the allowable docker images (the labels of the map are then irrelevant).

The variable `jobImagePrefix` can be used to shorten the docker image specs in pipeline definitions (and to avoid the impression
that arbitrary docker images might be specified). The prefix will be added before regex evaluation with the
keys of `imageRepoClassesMap` takes place.


### 3.1.3 - Init container

A kubernetes job issue by a PipelineJob consists of two containers: 
 - init container (to setup paths to mounted volumes)
 - main container (the pipeline job payload)

The actions of the init container are specified by the following helm variables:

| Variable            | Type   | Default                               | Description                                                                                 |
|---------------------|--------|---------------------------------------|---------------------------------------------------------------------------------------------|
| initContainerImage  | string | "bash"                                | docker image to be used for init container                                                  |
| initWorkdir         | string | "/workdir"                            | working directory in init containter                                                        |
| initCommand         | string | "bash -c"                             | shell command used to execute init script (will be split on spaces into a string array)     |
| initScriptStart     | string | "mkdir input"                         | commands to be issued in initContainer (before pipe specific commands)                      |
| initScriptPipe      | string | "ln -s {vol}/{source} input/{target}" | added for each pipe, {vol}=mounted volume, {source}/{target}=filename at in/out end of pipe |
| initScriptOutput    | string | "ln -s {vol} output"                  | commands to set path to output volume (after pipe specific commands), {vol}=mounted volume  |
| initScriptEnd       | string | "echo Initialization done"            | final commands to be issued in initContainer (after output command)                         |
| initScriptSeparator | string | " && "                                | separator string to be used for joining the init script                                     |

The init script will be joined into one string (using the specified separator) that will be passed as one argument in the pod spec.

### 3.1.4 - Resource estimation

Resource estimation is a feature that relies on external service that provides recommendations 
on how to set resource requests in the pipeline step jobs. It tries to minimize the 
footprint of pods to reduce energy consumption (and thus at the same time costs and CO2 production)
without jeopardizing the successful execution of jobs. 

Resource estimation is also required to allow GPU use in pipeline steps (because availability 
of GPU types depends on multiple factors and is not stable). 

There is (currently) only one helm parameter relevant for resource estimation (because, at this moment,
resource estimation does nothing else than requesting the specified maximal values):

| Variable                  | Type   | Default                           | Description                                                                                                  |
|---------------------------|--------|-----------------------------------|--------------------------------------------------------------------------------------------------------------|
| resourceEstimationService | string | ""                                | set this to "https://europe-west3-k-pipe-server.cloudfunctions.net/resource-estimation" ton enable GPU usage |

