# Notebook for pvc-autoscale module
resource "shoreline_notebook" "jvm_notebook" {
  name = "${var.prefix}jvm_notebook"
  description = "Notebook for checking JVM memory usage."
  data = file("${path.module}/data/jvm_notebook.json")
}
