# Confluent Cloud Topic Deployment with CFK

I followed the examples github repo fo Confluent: [Hybrid ccloud topic](https://github.com/confluentinc/confluent-kubernetes-examples/tree/master/hybrid/ccloud-topic)

Download CFK examples and install it or use samples in `resourcefiles`:
```bash
wget https://github.com/confluentinc/confluent-kubernetes-examples/archive/refs/heads/master.zip
unzip master.zip
export TUTORIAL_HOME="<YOURPATH>confluent-kubernetes-examples-master/hybrid/ccloud-topic"
ll $TUTORIAL_HOME
```

Now, we need create access to our confluent cloud environment:
* create cluster in Confluent Cloud: k3s_cluster
* create API key for global access in cluster add key into $TUTORIAL_HOME/creds-kafka-sasl-user.txt
* Change the $TUTORIAL_HOME/topic.yaml file with Admin Rest and cluster ID

Create a Secret with Confluent Cloud Credentials:
```bash
kubectl create secret generic cloud-rest-access \
 --from-file=basic.txt=$TUTORIAL_HOME/creds-kafka-sasl-user.txt --namespace confluent
kubectl get secrets
```
Create a topic in Confluent Cloud:
```bash
# one topic
kubectl apply -f $TUTORIAL_HOME/topic.yaml
# delete the topic
kubectl delete -f $TUTORIAL_HOME/topic.yaml
# three topics
kubectl apply -f $TUTORIAL_HOME/multipletopics.yaml
# delete all three topics
kubectl delete -f $TUTORIAL_HOME/multipletopics.yaml
# Show all resources in namespace confluent
kubectl api-resources --verbs=list --namespaced -o name \
  | xargs -n 1 kubectl get --show-kind --ignore-not-found  -n confluent kafkatopics.platform.confluent.io
```

Topics are depoyed to Confluent Cloud. 
The CFK examples do have so much examples. try them all.

Go back to [Startpage](README.md)