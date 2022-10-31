#!/bin/bash
# Need admin rights to see query all information
vm=$1

ids=$(grep $vm servers.csv|awk '{print $2}')
for id in $ids; do
    server_show_output=$(openstack server show $id -f json)
    virsh_name=$( echo "$server_show_output" | jq '."OS-EXT-SRV-ATTR:instance_name"' | tr -d '"')
    hypervisor=$( echo "$server_show_output" | jq '."OS-EXT-SRV-ATTR:hypervisor_hostname"' | tr -d '"')
    vols=$( echo "$server_show_output" | jq '."volumes_attached"' | tr -d '"')
    vm_name=$( echo "$server_show_output" | jq '."name"' | tr -d '"')
    #vols=$(grep $id volume_mapping.csv)
    iqn=$(ssh heat-admin@$hypervisor  cat /etc/iscsi/initiatorname.iscsi)
    echo "======================================================================="
    echo "         VM name: $vm_name"
    echo " hypervisor node: $hypervisor"
    echo "             iqn: $iqn"
    echo "           VM id: $id"
    echo "    Libvirt name: $virsh_name"
    echo "Volumes Attached:"
    echo -e "$vols"  | sed "s/^/  - /g"
done
