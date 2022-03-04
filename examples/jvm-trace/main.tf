terraform {
  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.1.3"
    }
  }
}

provider "shoreline" {
  # provider configuration here
  debug   = true
  retries = 2
}

module "jvm_trace" {
  # Location of the module
  source = "terraform-shoreline-modules/jvm-op-pack/shoreline//modules/jvm-trace"

  # S3 or GCS storage bucket for heap dumps and stack traces
  bucket = "s3://jvm_trace_example_bucket"

  # Frequency to evaluate alarm conditions in seconds
  check_interval = 60

  # Regular expression to select the monitored JVM processes
  jvm_process_regex = "tomcat"

  # Maximum memory usage, in Mb, before the JVM process is traced
  mem_threshold = 1000

  # Prefix to allow multiple instances of the module, with different params
  prefix = "jvm_example_"

  # Resource query to select the affected resources
  resource_query = "pods | app='jvm-test'"

  # Destination of the memory-check, and trace scripts on the selected resources
  script_path = "/tmp"
}
