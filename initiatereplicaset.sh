
#Creating config nodes
kubectl create -f  mongo_replicaset.yaml

#Waiting for containers
echo "Waiting config containers"
kubectl get pods | grep "mongocfg" | grep "ContainerCreating"
while [ $? -eq 0 ]
do
  sleep 1
  echo -e "\n\nWaiting the following containers:"
  kubectl get pods | grep "mongoreplicaset" | grep "ContainerCreating"
done


#Initializating configuration nodes
POD_NAME=$(kubectl get pods | grep "mongoreplicaset1" | awk '{print $1;}')
echo "Initializating config replica set... connecting to: $POD_NAME"
CMD='rs.initiate({ _id : "rs1", members: [{ _id : 0, host : "mongoreplicaset1:27017" },{ _id : 1, host : "mongoreplicaset2:27017" },{ _id : 2, host : "mongoreplicaset3:27017" },{ _id : 3, host : "mongoreplicaset4:27017" },{ _id : 4, host : "mongoreplicaset5:27017" }]})'
kubectl exec -it $POD_NAME -- bash -c "mongosh --port 27017 --eval '$CMD'"
