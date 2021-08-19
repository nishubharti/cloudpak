# ibm-cp-applications

IBM Cloud Pak for Applications

# Introduction
The IBM Cloud Pak™ for Applications provides a complete and consistent experience to speed development of applications built for Kubernetes, using agile DevOps processes. You can easily modernize your existing applications with IBM’s integrated tools and develop new cloud-native applications faster for deployment on any cloud.

![](https://www.ibm.com/support/knowledgecenter/SSCSJL/images/icpa_overview.png)

Running on Red Hat® OpenShift®, IBM Cloud Pak for Applications provides a hybrid, multicloud foundation built on open standards, enabling workloads and data to run anywhere. A self-service environment combines open source tools with your existing middleware for continuous compliance and visibility across secure, hybrid, multicloud environments.

# CASE Details
## Prerequisites
### Resources Required
Minimum scheduling capacity:

| Software | Memory (GB) | CPU (cores) | Disk (GB) | Nodes |
| --- | --- | --- | --- | --- |
| Kabanero Enterprise | 20 | 8 | 25 | 2 |
| Transformation Advisor | 6 | 3 | 8 | |
| **Total** | **26** | **11**  | **33**  | **2** |


# Installing the CASE
For installation instructions, see https://cloud.ibm.com/docs/cloud-pak-applications?topic=cloud-pak-applications-getting-started .

## Configuration
There are no configuration options when installing this CASE.

## Storage
By default, Transformation Advisor is configured to use dynamic provisioning. If dynamic provisioning is not available or you choose not to use it, Transformation Advisor can bind to a suitable statically created PersistentVolume.

## Limitations
Only one installation of IBM Cloud Pak for Applications per cluster is supported at this time.

## Documentation
Documentation for IBM Cloud Pak for Applications can be found at https://cloud.ibm.com/docs/cloud-pak-applications?topic=cloud-pak-applications-about .
