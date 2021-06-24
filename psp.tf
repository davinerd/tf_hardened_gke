resource "kubernetes_pod_security_policy" "example" {
  count = var.enable_pod_security_policy ? 1 : 0 
  metadata {
    name = format("%s-psp", var.name)
  }
  spec {
    privileged                 = false
    allow_privilege_escalation = false

    volumes = [
      "configMap",
      "emptyDir",
      "projected",
      "secret",
      "downwardAPI",
      "persistentVolumeClaim",
    ]

    run_as_user {
      rule = "MustRunAsNonRoot"
    }

    se_linux {
      rule = "RunAsAny"
    }

    supplemental_groups {
      rule = "MustRunAs"
      range {
        min = 1
        max = 65535
      }
    }

    fs_group {
      rule = "MustRunAs"
      range {
        min = 1
        max = 65535
      }
    }

    required_drop_capabilities = [
        "NET_RAW"
    ]
    read_only_root_filesystem = true
  }
}
