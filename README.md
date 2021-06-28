# Private GKE Cluster
A customized version based on [https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/tree/master/modules/beta-private-cluster](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/tree/master/modules/beta-private-cluster
)
## Features
- Outbound internet access flag (`outbound_access = true`)
- Automatic add your public IP to the authorized master networks
- Security Groups RBAC on by default (must be passed to `authenticator_security_group` and the format is `gke-security-groups@YOUR_DOMAIN`. More information [here](https://cloud.google.com/kubernetes-engine/docs/how-to/role-based-access-control#groups-setup-gsuite))
- Pod Security Policy via `enable_pod_security_policy` variable (default to `false`). Please check deprecation notes [here](https://kubernetes.io/blog/2021/04/06/podsecuritypolicy-deprecation-past-present-and-future/). If you want to enable it, have a look and tweak the `psp.tf` file to your needs.
- If `ingress_nginx_enabled` is set to `true`, a firewall rule is automatically created to facilitate ingress-nginx deployment (and `http_load_balancer` is set to `false`).

## Inputs
It takes all the inputs from the [GKE Beta Private Cluster module](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/tree/master/modules/beta-private-cluster) mentioned above. Please refer to that page for detailed information.
This module uses version `15.0.0` of the aforementioned module.

The followings are mandatory and need to be specified:
- `project_id`
- `region`
- `zones`
- `name`
- `authenticator_security_group`

## Outputs
```
- endpoint (sensitive)
- get_credentials
```

## Example
The following example will create a GKE zonal cluster with a initial nodes count of 3. Nodes will not have public IP addresses but still be able to communicate to the internet via outbound connections. Finally, access to Google Registry is granted, in order to pull images during a k8s deployment.

```
module "priv_gke" {
    source = "github.com/davinerd/tf_hardened_gke"

    project_id = "test-new-project-301409"

    region = "europe-west1"

    zones = ["europe-west1-c"]

    regional = false

    name = "test-terraform"

    # To disable Groups RBAC just type authenticator_security_group = null (unquoted)
    # Create the Group before running this module.
    authenticator_security_group = "gke-security-groups@YOUR_DOMAIN"

    # Cluster is private by default, which means nodes will not have public IPs.
    # Bear in mind that the cluster can be accessed via the authorized_master_networks.
    # To completely make your cluster private, set enable_private_entpoint = true

    # To create a public cluster, uncomment the following variable.
    # private = true

    # Nodes will have outbound internet access.
    outbound_access = true

    # Granting access to Google Registry.
    grant_registry_access = true
}
```