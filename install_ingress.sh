
test -n "$1" && echo REGION is "$1" || "echo REGION is not set && exit"
test -n "$2" && echo CLUSTER is "$2" || "echo CLUSTER is not set && exit"
test -n "$3" && echo ACCOUNT is "$3" || "echo ACCOUNT is not set && exit"
test -n "$LBC_VERSION" && echo LBC_VERSION is "$LBC_VERSION" || "export LBC_VERSION=2.2.4"
helm repo add eks https://aws.github.io/eks-charts
rm -f crds.yaml*
wget https://raw.githubusercontent.com/aws/eks-charts/master/stable/aws-load-balancer-controller/crds/crds.yaml
# create the custom resource definition for the load balancer
kubectl apply -f crds.yaml

rm -f crds.yaml*

# install the load balancer controller using the helm chart
# Make sure to check and update to the latest image version. At the time of this writing, 2.2.4 is latest (28 Sep 2020)
helm upgrade -i aws-load-balancer-controller eks/aws-load-balancer-controller \
                -n kube-system \
                --set clusterName=$2 \
                --set serviceAccount.name=aws-load-balancer-controller \
                --set image.repository=961992271922.dkr.ecr.cn-northwest-1.amazonaws.com.cn/amazon/aws-load-balancer-controller \
                --set image.tag="v2.2.4"
