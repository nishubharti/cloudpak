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
printf "%s" "$KUBECONFIG_PEM_VALUE" > ./ca.pem
