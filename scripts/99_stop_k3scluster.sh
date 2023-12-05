#!/bin/bash
# usage ./99_stop_k3scluster.sh

echo "reload systemctl properties on all nodes"
ssh -i ~/keys/k3s-key ubuntu@cpmaster 'sudo systemctl daemon-reload; exit'
ssh -i ~/keys/k3s-key ubuntu@cpworker1 'sudo systemctl daemon-reload; exit'
ssh -i ~/keys/k3s-key ubuntu@cpworker2 'sudo systemctl daemon-reload; exit'
ssh -i ~/keys/k3s-key ubuntu@ccpworker3 'sudo systemctl daemon-reload; exit'
echo "finished: reload systemctl properties on all nodes"

ssh -i ~/keys/k3s-key ubuntu@cpworker1 'sudo systemctl stop k3s-agent; exit'
echo "cpworker1 k3s Agent stopped"
ssh -i ~/keys/k3s-key ubuntu@cpworker2 'sudo systemctl stop k3s-agent; exit'
echo "cpworker2 k3s Agent stopped"
ssh -i ~/keys/k3s-key ubuntu@cpworker3 'sudo systemctl stop k3s-agent; exit'
echo "cpworker3 k3s Agent stopped"
ssh -i ~/keys/k3s-key ubuntu@cpmaster 'sudo systemctl stop k3s; exit'
echo "cpmaster k3s stopped"

echo "k3s cluster stopped"
