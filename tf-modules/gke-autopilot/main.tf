# The service account to run the cluster
resource "google_service_account" "service-account" {
  project      = var.project_id
  account_id   = var.cluster_id // use identical name for service account, same as cluster
}

# minimally required roles, see https://cloud.google.com/kubernetes-engine/docs/how-to/hardening-your-cluster#permissions
variable "roles" {
  description = "List of roles to be assigned"
  type        = list(string)
  default     = [
    "roles/monitoring.viewer",
    "roles/monitoring.metricWriter",
    "roles/logging.logWriter",
    "roles/stackdriver.resourceMetadata.writer",
    "roles/autoscaling.metricsWriter",
  ]
}

# assign the required roles to the service account
resource "google_project_iam_member" "member" {
  for_each = { for role in var.roles : role => role }

  project = var.project_id
  role    = each.value
  member  = join(":", ["serviceAccount", google_service_account.service-account.email])
}

# The GKE cluster
resource "google_container_cluster" "k8s-cluster" {
  project      = var.project_id
  name         = var.cluster_id
  location     = var.region
  network      = var.network
  subnetwork   = var.subnetwork

  # Enabling Autopilot for this cluster
  enable_autopilot = true

  # Disallow accidental deletion of cluster
  deletion_protection = false

  # see https://github.com/hashicorp/terraform-provider-google/issues/9505
  cluster_autoscaling {
    auto_provisioning_defaults {
      service_account = google_service_account.service-account.email
      oauth_scopes = [
          # https://cloud.google.com/kubernetes-engine/docs/how-to/access-scopes
          "https://www.googleapis.com/auth/cloud-platform",
          "https://www.googleapis.com/auth/devstorage.read_only",
          "https://www.googleapis.com/auth/bigquery",
      ]
    }
  }
}

# helm chart for kubernetes operator
resource "helm_release" "pipeline-operator" {
  name             = "k-pipe"
  chart            = "operator"
  repository       = "https://helm.k-pipe.cloud"
  namespace        = "k-pipe"
  version          = var.operator_version
  create_namespace = true
  recreate_pods    = true

  set {
    name  = "nodeSelectorMap"
    value = "topology.kubernetes.io/zone=${var.zone}"
  }
  set {
    name  = "storageClass"
    value = "standard-${var.zone}"
  }
  set {
    name  = "fixedInitCommands"
    value = "mkdir input && ln -s /etc/config/config.json input/config.json"
  }
}