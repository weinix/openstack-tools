#!/usr/bin/env sh
#Purpose Collect VM/Volume data for auditing purpose
#Useage: ./vol_vm_audit.sh
#Note: Need admin rights

openstack volume list -f json --all-projects > volumes.json
openstack server list --all-projects  -f json  > servers.json
openstack hypervisor list --all-projects  -f json  > hypervisors.json
cat volumes.json  | jq '.[] | .ID+ " " + .Name + " " + .Status + " " + (.Size|tostring) ' | tr -d '"' | tee  volumes.csv
cat volumes.json | jq ' .[] | ."Attached to" | .[] |.host_name + " " + .server_id + " " + .volume_id' | tr -d '"' | tee volume_mapping.csv
cat servers.json | jq '.[] | .Name + " " + .ID + " " + .Status + " " + .Flavor' | tr -d '"' > servers.csv
