/////////////////////////////////////////////////////////
// Input variables: coordinates of gcp infrastructure  //
/////////////////////////////////////////////////////////

variable "project_id" {
  type = string
  description = "the gcp project in which the k8s cluster will reside"
}

variable "region" {
  type = string
  description = "the gcp region into which the k8s cluster will be placed"
}

variable "zone" {
  type = string
  description = "the gcp zone in which the execution pods will be running (must be in provided region)"
}

variable "cluster_id" {
  type = string
  description = "name of the k8s cluster"
}

variable "operator_version" {
  type = string
  description = "version of the pipeline operator to be used"
}

variable "network" {
  type = string
  description = "network to be used for k8s cluster"
}

variable "subnetwork" {
  type = string
  description = "subnetwork to be used for k8s cluster"
}
