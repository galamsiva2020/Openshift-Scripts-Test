#!/bin/sh
# Usage:
#   compare_inventory source custom
# Return value: 0 = success, 1 = failure
# Prints output
# Status: Tested
#
function compare_inventory() {
  # Expects two absolute paths
  local source="${1}"
  local custom="${2}"
  local package='crudini'

  declare -a local groups=('OSEv3:children' 'OSEv3:vars' 'etcd' 'masters' 'nodes' 'nfs' )
  # A list of keys to exclude from the check
  declare -a local excludes=('openshift_master_htpasswd_users')

  if ! which ${package}; then
    install_crudini
  fi

  pad " · Detecting source"
  if stat ${source}; then
    print_PASS
  else
    print_FAIL
    exit 1
  fi

  pad " · Detecting student file"
  if stat ${custom}; then
    print_PASS
  else
    print_FAIL
    exit 1
  fi

  # We make sure that we use the right version of the crudini
  # package. Releases before 0.9 are not compatible with our
  # Ansible inventory files.
  cr_version=$(crudini --version | cut -d . -f 2)
  min_ver=9
  if [[ ${cr_version} -lt ${min_ver} ]]; then
    print_line
    pad " · Checking crudini version"
    print_FAIL
    print_line
    print_line 'Please update your crudini package and try again'
    print_line
    exit 1
  fi

  # We populate a group/ value set of variables that we
  # compare against the 'modified' file.
  # This gives the advantage of dynamically adjusting to new
  # variables added.
  for group in ${groups[@]}; do
    print_header "Comparing Entries in [${group}]"
    IFS=$'\n'

    for key in $(crudini --get ${source} "${group}"); do
      # We retrieve all the keys in the group
      local local_key="${key}"
      local local_value=$(crudini --format=lines --get ${source} ${group} "${local_key}")
      local modified_value=$(crudini --format=lines --get ${custom} ${group} "${local_key}")
      local key_display=$(echo ${local_key} | cut -f 2 -d "]" |  cut -c -45)

      # We skip the values defined in the array
      if echo ${excludes[@]} | grep ${local_key}; then
        pad " · Skipping ${key_display}"
        print_PASS
      else
        pad " · Checking ${key_display}"
        if [ "${local_value}" != "${modified_value}" ]; then
          print_FAIL
          run_diff ${modified_value} ${local_value}
          print_line
          echo " · The custom file does not match the original file." >&3
          echo " · Please review the inventory file and update the necessary variables" >&3
          return 1
        else
          print_PASS
        fi
      fi
    done
  done

  print_line
  pad " . Results: "
  if [[ ${fail_count} -eq 0 ]]; then
    print_PASS
    return 0
  else
    print_FAIL
    echo " · The custom file does not match the original file." >&3
    echo " · Please review the inventory file and update the necessary variables" >&3
    return 1
  fi
}

