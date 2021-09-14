#!/bin/bash

oc adm policy remove-cluster-role-from-group \
    self-provisioner system:authenticated system:authenticated:oauth

