#!/bin/sh

########################
# Function Definitions
########################
function full_install() {
  sudo yum install -y ansible atomic-openshift-utils
  echo -e "\n\nFull classroom Install can take 20-30 minutes."
  echo -e "Beginning OCP install...\n"
  ansible-playbook -v playbooks/full_classroom_install.yml
}


#An S2I "build, deploy, curl" is the simple smoke test below.
function smoke_test() {
  local user=$1
  local project="smoke-test-${user}"
  local imagestream="$2"

   oc login -u ${user} -p redhat https://master.lab.example.com --insecure-skip-tls-verify=true
   oc new-project ${project}
   oc new-app -i ${imagestream} http://services.lab.example.com/php-helloworld --name hello
   oc logs -f bc/hello
   oc expose svc hello

   echo "Waiting 20 seconds for application pod to deploy"
   sleep 20
   local state=$(oc get pods | grep -v build | tail -n 1 | awk '{print $3}')
   if [ "$state" != "Running" ]; then
     echo "Pods have not started after 20 seconds... Failing the test."
     return 1
   fi

   local curl_output="$(curl -s hello-${project}.apps.lab.example.com)"
   local result="$(echo $curl_output | grep "Hello, World" | wc -l)"
   if [ "$result" != "1" ]; then
      echo "***********************************"
      echo "* TEST FAILED for ${user}/${imagestream}"
      echo "* CURL OUTPUT:"
      echo "* ${curl_output}"
      echo "* ${result}"
      echo "***********************************"
      oc delete project ${project}
      return 1
   fi
   echo "TEST SUCCESSFUL: ${curl_output}"
   oc delete project ${project}
   return 0
}

#Smoke Tests for the cluster
#################################
# Actual script execution below:
#################################
full_install

#User with cluster-admin rights.
#smoke_test admin "php:5.6"

#Developer user with different image.
#smoke_test developer "php:7.0"


