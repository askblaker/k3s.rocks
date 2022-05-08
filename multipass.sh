#!/bin/bash

multipass launch --name testvm  --mem 4G --disk 10G --cpus 2 focal
read TESTVMIP < <(multipass info testvm | grep IPv4 | grep -o '[0-9]\+[.][0-9]\+[.][0-9]\+[.][0-9]\+')
echo "TESTVMPIP=${TESTVMIP}"

COMMAND="$(cat ./scripts/install_update_open_scsi_wireguard.txt)"
multipass exec testvm -- bash -c "${COMMAND}"

COMMAND="$(cat ./scripts/install_arkade_helm_kubectl.txt)"
#multipass exec testvm -- bash -c "${COMMAND}"

COMMAND="$(cat ./scripts/git_clone_k3s.rocks.txt)"
#multipass exec testvm -- bash -c "${COMMAND}"

multipass mount ${PWD} testvm:./k3s.rocks

COMMAND="$(cat ./scripts/install_k3s_regular.txt)"
multipass exec testvm -- bash -c "${COMMAND}"

multipass exec testvm -- bash -c "KUBECONFIG=/etc/rancher/k3s/k3s.yaml bash ./k3s.rocks/scripts/whoami_deployment.txt"
multipass exec testvm -- bash -c "KUBECONFIG=/etc/rancher/k3s/k3s.yaml bash ./k3s.rocks/scripts/whoami_service.txt"
multipass exec testvm -- bash -c "KUBECONFIG=/etc/rancher/k3s/k3s.yaml bash ./k3s.rocks/scripts/whoami_ingress.txt"

echo "Give services some time to start..."
sleep 60
echo "Continuing..."

if [[ $(curl ${TESTVMIP}/fy) != "404 page not found" ]]; then exit 1; fi

if [ $( curl ${TESTVMIP}/foo | grep -c whoami ) != 0 ]; then echo "Whoami service found"; else exit 1; fi

