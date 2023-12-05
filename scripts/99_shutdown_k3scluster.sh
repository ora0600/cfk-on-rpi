#!/bin/bash
# usage ./99_shutdown_k3sclustersh cpmaster 
# usage ./99_shutdown_k3sclustersh cpworker1
# usage ./99_shutdown_k3sclustersh cpworker2 
# usage ./99_shutdown_k3sclustersh cpworker3
# all 
# usage ./99_shutdown_clustersh cpworker1 cpworker2 cpworker3 cpmaster

for server; do ssh -i ~/keys/k3s-key ubuntu@$server 'sudo shutdown -h now; exit'; done