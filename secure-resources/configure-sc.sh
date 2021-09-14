#!/bin/bash

# Actions for a project administrator
oc login -u user1 -p redhat
oc project proj-user1
oc create serviceaccount useroot

# Actions for a cluster administrator
oc login -u admin -p redhat
oc project proj-user1
oc adm policy add-scc-to-user anyuid -z useroot

# Actions for project a developer
oc login -u user2 -p redhat
oc project proj-user1
oc patch dc/nginx --patch \
    '{"spec":{"template":{"spec":{"serviceAccountName": "useroot"}}}}'

# Repeat to wait for pods to be ready and running
sleep 3
oc get pod
