#!/bin/sh

oc adm policy add-scc-to-user anyuid system:serviceaccount:${JOB_NAMESPACE}:default
oc adm policy add-cluster-role-to-user cluster-admin system:serviceaccount:${JOB_NAMESPACE}:default
oc adm policy add-cluster-role-to-user self-provisioner system:serviceaccount:${JOB_NAMESPACE}:default

echo "Script ran successfully"
