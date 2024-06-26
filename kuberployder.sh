pwd
ls
echo "Trying to launche the pipeline"
#cd conf
#mvn clean install
#mvn package spring-boot:repackage
if [ "$?" -eq "1" ]
then
  echo "fallo"
  exit 1
fi
imageRepository="10.168.131.38:5000"
projectName="angularapp"

docker build --no-cache . -t "$imageRepository/$projectName"
docker push "$imageRepository/$projectName"

kubectl delete -f deploy.yaml && true
kubectl apply -f deploy.yaml

nService=$(kubectl get services | grep "$projectName-service" | wc -l)

if [ $nService -lt 1 ]
then
  kubectl expose deployment $projectName --type=LoadBalancer --name="$projectName-service" && true
fi
echo $(kubectl get services | grep "$projectName-service")
