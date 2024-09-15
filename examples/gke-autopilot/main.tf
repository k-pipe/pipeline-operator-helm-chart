//////////////////////////////////////////////////////////////////////////////////////////////////
// This is an example terraform file to setup two GKE clusters for dev/prod pipeline processing //
//////////////////////////////////////////////////////////////////////////////////////////////////

#################
#  dev cluster  #
#################
module "dev-cluster" {

  // user specified parameters
  cluster_id       = "processing-dev"    // choose a name for the kubernetes cluster
  operator_version = "0.9.47"            // version of k-pipe controller to use, might differ in dev/prod

  // predefined parameters
  source           = "git@github.com:k-pipe/terraform-module-gke-autopilot.git"
  project_id       = var.project_id
  zone             = var.zone
  region           = var.region
  network          = var.network
  subnetwork       = var.subnetwork
}

##################
#  prod cluster  #
##################
# uncomment code below to use prod cluster
#module "prod-cluster" {
#
#  // user specified parameters
#  cluster_id       = "processing-prod"    // choose a name for the kubernetes cluster
#  operator_version = "0.9.47"            // version of k-pipe controller to use, might differ in dev/prod
#
#  // predefined parameters
#  source           = "git@github.com:k-pipe/terraform-module-gke-autopilot.git"
#  project_id       = var.project_id
#  zone             = var.zone
#  region           = var.region
#  network          = var.network
#  subnetwork       = var.subnetwork
#}
