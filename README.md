# USE AT OWN RISK
There are no guarantees with this script and you assume all risk and responsbility.

# Kubernetes Environment Setup
This script installs and configures a secure, highly available <a href="http://kubernetes.io">Kubernetes</a> cluster using etcd, flannel, HAproxy, and keepalived on RHEL7/CentOS7 based systems.  This installs and configures the Kubernetes master services -- apiserver, controller-manager, and scheduler -- on 1 to many master servers.  This also sets up the Kubernetes node services on 1 to many node servers.

# Pre-requisites
1. DNS resolution or existing host file entries for each master and node server.
2. RHEL7/CentOS7 is preinstalled on all master and node servers.
3. All systems are subscribed to the appriopriate channels/repos to download kubernetes, docker, flanneld, etcd, haproxy, and keepalived.
4. Script is run from a system that has SSH to all master and node servers with SSH key pair.

# Install
1. Edit the <b>params.env</b> file (you can edit any parameter listed in the file).  Below are required:

    CLUSTER_NAME
    
    MASTERS
    
    NODES
    
    DOMAIN
    
    CLUSTER_FQDN
    
    CLUSTER_VIP

2. *chmod 700 setup_kube.sh*

3. run *./setup_kube.sh*   
 
 
# Security Notes
This script will create certificate based authentication for each node to communicate to the apiserver and etcd.  This will also stop and disable firewalld on all master and node servers.

# Tested
This has been tested with the following versions:

    docker-1.12.6-11.el7.x86_64
  
    kubernetes-client-1.5.2-0.2.gitc55cf2b.el7.x86_64
  
    kubernetes-master-1.5.2-0.2.gitc55cf2b.el7.x86_64
  
    etcd-3.1.0-2.el7.x86_64
  
    flannel-0.7.0-1.el7.x86_64
  
    haproxy-1.5.18-3.el7_3.1.x86_64
  
    keepalived-1.2.13-8.el7.x86_64
  
  
# Validation
Once the setup script has completed, confirm you cluster is functioning.

    # kubectl get nodes
    NAME                STATUS    AGE
    node1.example.com   Ready     1m
    node2.example.com   Ready     1m
    node3.example.com   Ready     1m
    node4.example.com   Ready     1m
    

