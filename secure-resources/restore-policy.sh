#!/bin/bash

oc login -u admin -p redhat
oc adm policy add-cluster-role-to-group \
    self-provisioner system:authenticated system:authenticated:oauth

