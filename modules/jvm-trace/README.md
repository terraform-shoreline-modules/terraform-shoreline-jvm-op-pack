# Shoreline JVM Trace Op Pack

<table role="table" style="vertical-align: middle;">
  <thead>
    <tr style="background-color: #fff">
      <th style="padding: 6px 13px; border: 1px solid #B1B1B1; text-align: center;" colspan="3">Provider Support</th>
    </tr>
  </thead>
  <tbody>
    <tr style="background-color: #E2E2E2">
      <td style="padding: 6px 13px; border: 1px solid #B1B1B1; text-align: center;">AWS</td>
      <td style="padding: 6px 13px; border: 1px solid #B1B1B1; text-align: center;">Azure</td>
      <td style="padding: 6px 13px; border: 1px solid #B1B1B1; text-align: center;">GCP</td>
    </tr>
    <tr>
      <td style="padding-top: 6px; vertical-align: bottom; border: 1px solid #B1B1B1; text-align: center;"><svg xmlns="http://www.w3.org/2000/svg" style="width: 1.5rem; height: 1.5rem;" fill="none" viewBox="0 0 24 24" stroke="#6CB169"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" /></svg></td>
      <td style="padding-top: 6px; vertical-align: bottom; border: 1px solid #B1B1B1; text-align: center;"><svg xmlns="http://www.w3.org/2000/svg" style="width: 1.5rem; height: 1.5rem;" fill="none" viewBox="0 0 24 24" stroke="#6CB169"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" /></svg></td>
      <td style="padding-top: 6px; vertical-align: bottom; border: 1px solid #B1B1B1; text-align: center;"><svg xmlns="http://www.w3.org/2000/svg" style="width: 1.5rem; height: 1.5rem;" fill="none" viewBox="0 0 24 24" stroke="#6CB169"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" /></svg></td>
    </tr>  
  </tbody>
</table>

The JVM Trace Op Pack monitors JVM resources (nodes/pods/containers). Whenever monitored Java processes exceed the defined memory limit, data is automatically collected and pushed to remote storage for more thorough investigation.

Collected data includes:

1. Stack traces
1. Heap dumps
1. Garbage collection statistics
1. Any detected deadlocks

## Requirements

The following tools are required on the monitored resources, with appropriate permissions:

1. Java tools: jcmd, jps, jmap, jstat, jstack.
1. The [AWS CLI](https://aws.amazon.com/cli/) (for AWS S3) or the [gsutil CLI](https://cloud.google.com/storage/docs/gsutil) (for GCS).

## Usage

The following example monitors all pod resources with an app label of `jvm-test`. Whenever a targeted pod's `tomcat` process exceeds the `mem_threshold` of `1000` MB, the debug data is dumped and pushed to the `jvm_trace_example_bucket` AWS S3 bucket.

```hcl
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
  url     = "<SHORELINE_CLUSTER_API_ENDPOINT>"
}

module "jvm_trace" {
  # Location of the module
  source             = "terraform-shoreline-modules/jvm-op-pack/shoreline//modules/jvm-trace"

  # S3 or GCS storage bucket for heap dumps and stack traces
  bucket             = "s3://jvm_trace_example_bucket"

  # Frequency to evaluate alarm conditions in seconds
  check_interval     = 60

  # Regular expression to select the monitored JVM processes
  jvm_process_regex  = "tomcat"

  # Maximum memory usage, in Mb, before the JVM process is traced
  mem_threshold      = 1000

  # Namespace to allow multiple instances of the module, with different params
  op_prefix          = "jvm_example"

  # Resource query to select the affected resources
  resource_query     = "pods | app='jvm-test'"

  # Destination of the memory-check, and trace scripts on the selected resources
  script_path        = "/tmp"
}
```

-> See the [examples](../../examples/jvm_trace) directory for additional examples.

## Manual command examples

These commands use Shoreline's expressive [Op language](https://docs.shoreline.io/op) to retrieve fleet-wide data using the generated actions from the JVM trace module.

-> These commands can be executed within the [Shoreline CLI](https://docs.shoreline.io/installation#cli) or [Shoreline Notebooks](https://docs.shoreline.io/ui/notebooks).

### Force data collection for a given set of processes

```
op> pods | app = "tomcat" | jvm_trace_jvm_dump_stack("tomcat", "s3://jvm_trace_example_bucket")
```

-> See the [shoreline_action resource](https://registry.terraform.io/providers/shorelinesoftware/shoreline/latest/docs/resources/action) and the [Shoreline Actions](https://docs.shoreline.io/actions) documentation for details.

### Force data collection for a given set of processes, on a single (arbitrary) pod

```
op> pods | app = "tomcat" | limit=1 | jvm_trace_jvm_dump_stack("tomcat", "s3://jvm_trace_example_bucket")
```

### Manually check memory usage on a set of pods

```
op> pods | name =~ 'jvm' | jvm_trace_jvm_check_heap('ChewResources')

 ID | TYPE      | NAME                                        | REGION    | AZ         | STATUS | STDOUT
 70 | CONTAINER | jvm-test-bcc5cf748-xd54m.jvm-test-container | us-west-2 | us-west-2b |   1    | heap memory 1165 MB > threshold 30 MB
    |           |                                             |           |            |        |
```

### List triggered JVM Alarms

```
op> events | alarm_name =~ 'jvm'

 RESOURCE_NAME  | RESOURCE_TYPE | ALARM_NAME               | STATUS   | STEP_TYPE   | TIMESTAMP                 | DESCRIPTION
 jvm-test-xd54m | POD           | jvm_trace_jvm_heap_alarm | resolved |             |                           | Alarm on JVM heap usage growing larger than a threshold.
                |               |                          |          | ALARM_FIRE  | 2022-01-10T17:16:58-08:00 | JVM heap usage exceeded memory threshold.
                |               |                          |          | ALARM_CLEAR | 2022-01-10T18:20:02-08:00 | JVM heap usage below memory threshold.
```

-> See the [Shoreline Events documentation](https://docs.shoreline.io/op/events) for details.
