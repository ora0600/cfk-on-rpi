#!/bin/bash
# usage ./98_start_k3scluster.sh

echo "reload systemctl properties on all nodes"
ssh -i ~/keys/k3s-key ubuntu@cpmaster 'sudo systemctl daemon-reload; exit'
ssh -i ~/keys/k3s-key ubuntu@cpworker1 'sudo systemctl daemon-reload; exit'
ssh -i ~/keys/k3s-key ubuntu@cpworker2 'sudo systemctl daemon-reload; exit'
ssh -i ~/keys/k3s-key ubuntu@ccpworker3 'sudo systemctl daemon-reload; exit'
echo "finished: reload systemctl properties on all nodes"

ssh -i ~/keys/k3s-key ubuntu@cpmaster 'sudo systemctl start k3s; exit'
echo "cpmaster k3s started"
ssh -i ~/keys/k3s-key ubuntu@cpworker1 'sudo systemctl start k3s-agent; exit'
echo "cpworker1 k3s Agent started"
ssh -i ~/keys/k3s-key ubuntu@cpworker2 'sudo systemctl start k3s-agent; exit'
echo "cpworker2 k3s Agent started"
ssh -i ~/keys/k3s-key ubuntu@cpworker3 'sudo systemctl start k3s-agent; exit'
echo "cpworker3 k3s Agent started"

echo "k3s cluster started"
