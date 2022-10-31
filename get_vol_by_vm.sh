#!/usr/bin/env sh
#Purpose: Query iSCSI volume information of a VM
#Usage: ./$0 <vm_name>
# Need admin rights to see query all information
vm=$1

ids=$(grep $vm servers.csv|awk '{print $2}')
for id in $ids; do
    virsh_name=$(openstack server show  $id -f json | jq '."OS-EXT-SRV-ATTR:instance_name"' | tr -d '"')
    vols=$(grep $id volume_mapping.csv)
    hypervisor=$(echo "$vols" | head -n1 | awk '{print $1}')
    iqn=$(ssh heat-admin@$hypervisor  cat /etc/iscsi/initiatorname.iscsi)
    echo "======================================================================="
    echo "compute=$hypervisor"
    echo "iqn=$iqn"
    echo "VM name=$vm"
    echo "VM id=$id"
    echo "Libvirt name=$virsh_name"
    echo "Volumes Attached:"
    echo "$vols" | awk '{print $NF}'
done
