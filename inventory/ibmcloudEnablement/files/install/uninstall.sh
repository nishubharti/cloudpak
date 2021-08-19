#!/bin/bash
#******************************************************************************
# Licensed Materials - Property of IBM
# (c) Copyright IBM Corporation 2019. All Rights Reserved.
#
# Note to U.S. Government Users Restricted Rights:
# Use, duplication or disclosure restricted by GSA ADP Schedule
# Contract with IBM Corp.
#******************************************************************************

# LOGIN
printf "%s" "$KUBECONFIG_VALUE" > ./kubeconfig.json

# Arguments
export NAMESPACE=${JOB_NAMESPACE}
export DOCKER_USERNAME="${DOCKER_USERNAME:-ekey}"
if [ "${ENVIRONMENT}" == "STAGING" ]; then
  export DOCKER_REGISTRY="cp.stg.icr.io"
else
  export DOCKER_REGISTRY="cp.icr.io"
fi
export DOCKER_REGISTRY_PASS=${DOCKER_REGISTRY_PASS}
export CONSOLE_ROUTE_PREFIX=${consoleRoutePrefix}

# create pull secret
oc create secret docker-registry icpa-anyuid-docker-pull -n ${NAMESPACE} --docker-server=${DOCKER_REGISTRY} --docker-username=${DOCKER_USERNAME} --docker-password=${DOCKER_REGISTRY_PASS} --docker-email=unused
oc secrets -n ${NAMESPACE} link default icpa-anyuid-docker-pull --for=pull

cat << EOF | kubectl apply --namespace ${NAMESPACE} -f -
---
apiVersion: batch/v1
kind: Job
metadata:
  name: icpa-uninstaller
  labels:
    app: icpa-uninstaller
spec:
  backoffLimit: 0
  template:
    metadata:
      labels:
        app: icpa-uninstaller
    spec:
      restartPolicy: Never
      containers:
      - env:
        - name: NAMESPACE
          value: ${NAMESPACE}
        - name: ENTITLED_REGISTRY
          value: ${DOCKER_REGISTRY}
        - name: ENTITLED_REGISTRY_USER
          value: ${DOCKER_USERNAME}
        - name: ENTITLED_REGISTRY_KEY
          value: ${DOCKER_REGISTRY_PASS}
        - name: CONSOLE_ROUTE_PREFIX
          value: ${CONSOLE_ROUTE_PREFIX}
        - name: LICENSE
          value: "accept"
        name: installer
        image: ${DOCKER_REGISTRY}/cp/icpa/icpa-installer:3.0.0.0
        imagePullPolicy: Always
        resources:
          limits:
            memory: "200Mi"
            cpu: 1
        args: [ "uninstall", "--skip-tags", "cluster-login" ]
        volumeMounts:
          - name: logs
            mountPath: /installer/data/logs
      securityContext:
        runAsUser: 1001
      volumes:
        - name: logs
          emptyDir: {}
      securityContext:
        runAsUser: 1001
      imagePullSecrets:
      - name: icpa-anyuid-docker-pull
EOF

if [ "$?" != "0" ]; then
  echo "Error starting uninstaller."
  exit 1
fi

wait_for_pod() {
  for i in {1..30}
  do
    POD_ENTRY=$(oc get pods -n ${NAMESPACE} -l app=icpa-uninstaller -o jsonpath="{.items[0].metadata.name}:{.items[0].status.phase}")
    if [[ -z "$POD_ENTRY" ]]; then
      echo "Waiting for uninstaller pod to start."
      sleep 2
    else
      POD=$(echo $POD_ENTRY | cut -d ':' -f1)
      STATUS=$(echo $POD_ENTRY | cut -d ':' -f2)
      if [ "$STATUS" = "Pending" ]; then
        echo "Uninstaller $POD pod is pending."
        sleep 2
      else
        echo "Uninstaller $POD pod is running."
        return 0
      fi
    fi
  done

  echo "Timeout waiting for uninstaller pod to start."
  exit 1
}

wait_for_pod

oc logs -n ${NAMESPACE} --follow $POD
sleep 10
exit $(oc get pods -n ${NAMESPACE} ${POD} -o jsonpath="{.status.containerStatuses[0].state.terminated.exitCode}")
