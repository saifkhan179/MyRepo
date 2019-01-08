variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "region" {
    default = ""
}
variable "namespace_name" {
    default = "jumpstart"
}

variable "compartment_ocid" {}

variable "deployment_short_id" {}


provider "oci" {
  tenancy_ocid = "${var.tenancy_ocid}"
  user_ocid = "${var.user_ocid}"
  fingerprint = "${var.fingerprint}"
  private_key_path = "${var.private_key_path}"
  region = "${var.region}"
}

resource "oci_objectstorage_bucket" "t" {
  compartment_id = "${var.compartment_ocid}"
  name = "BucketOne${var.deployment_short_id}"
  access_type = "ObjectRead" // or NoPublicAccess
  namespace = "${var.namespace_name}"
  metadata = {
    "foo" = "bar"
  }
}

output "Bucket_name" {
  value = ["${oci_objectstorage_bucket.t.name}"]
}

