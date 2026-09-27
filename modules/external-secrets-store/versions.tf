terraform {
  required_version = ">= 1.13"

  required_providers {
    # kubectl_manifest (not hashicorp/kubernetes' kubernetes_manifest) is used
    # here deliberately: kubernetes_manifest requires every attribute of a
    # CRD's schema-derived object type to be explicitly present, and setting
    # an optional nested field to `null` gets serialized as an empty object
    # rather than being omitted — which broke ESO's parsing of an unused
    # sessionTokenSecretRef. kubectl_manifest applies raw YAML, so a field
    # that's simply absent from the HCL object stays absent in the manifest.
    kubectl = {
      source  = "alekc/kubectl"
      version = "~> 2.4"
    }
  }
}
