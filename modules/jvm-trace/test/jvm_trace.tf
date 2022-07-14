 
terraform {
  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.0.7"
    }
  }
}

locals {
  prefix             = "testjvm_"
}

module "jvm_autotrace_eat" {
  source             = "../"
  prefix          = "${local.prefix}"
  jvm_process_regex  = "EatResources"
  mem_threshold      = 30
  # check more frequently to speed up test
  check_interval     = 10
  resource_query     = "host | pod | app='jvm-test'"
  script_path        = "/tmp"
  bucket             = "s3://shore-oppack-test"
}

# a second instance of the module watching different processes
module "jvm_autotrace_gnaw" {
  source             = "../"
  prefix          = "${local.prefix}2_"
  jvm_process_regex  = "GnawResources"
  mem_threshold      = 30
  # check more frequently to speed up test
  check_interval     = 10
  resource_query     = "host | pod | app='jvm-test'"
  script_path        = "/tmp"
  bucket             = "s3://shore-oppack-test"
}

# Push the source that eats resources
resource "shoreline_file" "jvm_test_java_src" {
  name = "${local.prefix}jvm_test_java_src"
  description = "Java source to use resources."
  input_file = "${path.module}/EatResources.java"
  destination_path = "/tmp/EatResources.java"
  resource_query = "host | pod | app='jvm-test'"
  enabled = true
}

# Push a second source that eats resources
resource "shoreline_file" "jvm_test2_java_src" {
  name = "${local.prefix}jvm_test2_java_src"
  description = "Java source (alt) to use resources."
  input_file = "${path.module}/ChewResources.java"
  destination_path = "/tmp/ChewResources.java"
  resource_query = "host | pod | app='jvm-test'"
  enabled = true
}

# Push a third source that eats resources
resource "shoreline_file" "jvm_test3_java_src" {
  name = "${local.prefix}jvm_test3_java_src"
  description = "Java source (alt) to use resources."
  input_file = "${path.module}/GnawResources.java"
  destination_path = "/tmp/GnawResources.java"
  resource_query = "host | pod | app='jvm-test'"
  enabled = true
}

resource "shoreline_file" "jvm_test_yaml" {
  name = "${local.prefix}jvm_test_yaml"
  description = "k8s yaml config to create test pod."
  input_file = "${path.module}/jvm_test.yaml"
  destination_path = "/tmp/jvm_test.yaml"
  resource_query = "pods | app='shoreline'"
  enabled = true
}

