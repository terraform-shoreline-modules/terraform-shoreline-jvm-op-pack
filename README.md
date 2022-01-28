# Shoreline Terraform JVM Op Packs

This repository contains a collection of [Shoreline Op Packs](#what-are-shoreline-op-packs) for Java Virtual Machine (JVM) remediation and debugging.

## About Shoreline

The Shoreline platform provides real-time monitoring and incident automation for cloud operations. Use Shoreline to debug and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline [Agents](https://docs.shoreline.io/platform/agents) are efficient and non-intrusive processes running in the background of all your monitored hosts. [Agents](https://docs.shoreline.io/platform/agents) act as the secure link between Shoreline and your environment's [Resources](https://docs.shoreline.io/platform/resources), providing real-time monitoring and metric collection across your fleet. [Agents](https://docs.shoreline.io/platform/agents) can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted [Resources](https://docs.shoreline.io/platform/resources).

Since [Agents](https://docs.shoreline.io/platform/agents) receive commands from Shoreline's backend, they also take automatic remediation steps based on the [Alarms](https://docs.shoreline.io/alarms), [Actions](https://docs.shoreline.io/actions), [Bots](https://docs.shoreline.io/bots), and other Shoreline objects that you've configured. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong.

### What are Shoreline Op Packs?

Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the [Shoreline Terraform Provider](https://registry.terraform.io/providers/shorelinesoftware/shoreline/latest/docs) to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

## JVM Op Packs

### JVM Trace

- **[Submodule](https://registry.terraform.io/modules/terraform-shoreline-modules/jvm-op-pack/shoreline/latest/submodules/jvm-trace)**
- **[Example](https://registry.terraform.io/modules/terraform-shoreline-modules/jvm-op-pack/shoreline/latest/examples/jvm-trace)**

The [JVM Trace Op Pack](https://registry.terraform.io/modules/terraform-shoreline-modules/jvm-op-pack/shoreline/latest/submodules/jvm-trace) monitors JVM resources (nodes/pods/containers). If the monitored Java processes exceed the defined memory limit, data is automatically collected and pushed to remote storage for more thorough investigation.

Collected data includes:

- Stack traces
- Heap dumps
- Garbage collection statistics
- Any detected deadlocks

## Additional resources

Find more detailed documentation on Shoreline and Terraform Op Packs below:

- [Shoreline Documentation](https://docs.shoreline.io/)
- [Op Packs Overview](https://docs.shoreline.io/op/packs)
- [Op Packs Tutorial](https://docs.shoreline.io/op/packs/tutorial)
