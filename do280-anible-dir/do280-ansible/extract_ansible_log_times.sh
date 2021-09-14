#!/bin/sh

#grep -A1 '  TASK \[' ansible.log | grep -v '  TASK \[' | cut -d ")" -f2 | grep -v '[-][-]' | awk '{print $1}'

#Script relies on STDIN
grep -A1 '  TASK \[' | \
  grep -v '  TASK \[' | \
  cut -d ")" -f2 | \
  grep -v '[-][-]' | \
  awk '{print $1}' | \
  nl | \
  awk '{print $1,$2}'

###############
#Sample output
###############
# 0:00:00.137
# 0:00:07.164
# 0:00:09.058
# 0:01:22.387
# 0:01:23.520
# 0:01:23.603
# 0:01:24.772
# 0:01:25.538
# 0:01:26.322


