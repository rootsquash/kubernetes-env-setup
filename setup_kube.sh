#!/bin/bash

#--Source environment variables
. params.env

#-- Define vars
#CLUSTER_ENV="${CERTDIR}/${CLUSTER_NAME}.env"
CLUSTER_ENV="/root/.kube.env"
DATE=$( date "+%Y%m%d%H%M%S" )

#--Source function files
. include/build_and_deploy_certs
. include/create_cluster_env
. include/generate_ca_cert
. include/master_setup
. include/node_setup
. include/remote_run

#--Create the cluster environment
[[ -d ${CERTDIR} ]] || mkdir -p ${CERTDIR} 
Create_Cluster_Env
#for HOST in ${HOST_LIST}
#do
#	#ssh root@${HOST} "[[ -d '${CERTDIR}' ]] || mkdir -p '${CERTDIR}'" && break
#	scp -q ${CLUSTER_ENV} root@${HOST}:${CLUSTER_ENV}
#done

#--Source the cluster environment vars
. ${CLUSTER_ENV}

#--Genereate the CA certificate
echo "### Generating CA certificate ###"
Generate_the_CA_Cert

#--Generate master and node certificates for apiserver and etcd secure communication
echo "### Building and deploying client certificates ###"
Build_and_Deploy_Certs

#--Configure the kubernetes master(s)
for MASTER in ${MASTERS}
do
	echo "### Configuring kubernetes master: ${MASTER} ###"
	remote::run $MASTER Master_Setup Master_Setup
done

#--Start etcd on all masters
for MASTER in ${MASTERS}
do
	echo "### Starting etcd on master: ${MASTER} ###"
    ssh -o StrictHostKeyChecking=no -q root@${MASTER} "systemctl enable etcd; systemctl start etcd"
done

#--Wait on etcd
sleep 20

#--Set etcd network config on one (primary) master
AMASTERS=( `for MASTER in ${MASTERS}; do echo $MASTER; done | tac` )
echo "### Setting etcd network on ${MASTER[0]} ###"
ssh root@${AMASTERS[0]} ". /root/.kube.env;etcdctl set coreos.com/network/config < ${CERTDIR}/flannel/flannel.json"

#--Start remaining services on all masters
for MASTER in ${MASTERS}
do
	echo "### Starting services on ${MASTER} ###"
	ssh -o StrictHostKeyChecking=no -q root@${MASTER} "systemctl enable flanneld docker kube-apiserver kube-controller-manager kube-scheduler; systemctl start flanneld docker kube-apiserver kube-controller-manager kube-scheduler"
done

#--Configure the kubernetes nodes
for NODE in ${NODES}
do
	echo "### Configuring kubernetes node: ${NODE} ###"
	remote::run $NODE Node_Setup Node_Setup
done		

