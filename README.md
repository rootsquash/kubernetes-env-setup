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
    
2. run *./setup_kube.sh*   
 
 
# Security Notes
This script will create certificate based authentication for each node to communicate to the apiserver and etcd.  This will also stop and disable firewalld on all master and node servers.

# Tested
This has been tested with the following versions:

    docker-1.10.3-46.el7.14.x86_64
  
    kubernetes-client-1.3.0-0.2.gitc5ee292.el7.x86_64
  
    kubernetes-master-1.3.0-0.2.gitc5ee292.el7.x86_64
  
    etcd-2.3.7-4.el7.x86_64
  
    flannel-0.5.3-9.el7.x86_64
  
    haproxy-1.5.18-3.el7.x86_64
  
    keepalived-1.2.13-8.el7.x86_64
  
  


