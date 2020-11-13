#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset
set -o xtrace
# set -eox pipefail #safety for script

# https://www.keycloak.org/getting-started/getting-started-kube
echo "=============================deploy keycloak============================================================="

# have the Ingress addon enabled 
minikube addons list

# enable Ingress addon
minikube addons enable ingress

# start with creating the Keycloak deployment and service
# create an initial admin user with username admin and password admin
kubectl create -f https://raw.githubusercontent.com/keycloak/keycloak-quickstarts/latest/kubernetes-examples/keycloak.yaml

# Access Keycloak with Ingress addon enabled
# Start by creating an Ingress for Keycloak
wget -q -O - https://raw.githubusercontent.com/keycloak/keycloak-quickstarts/latest/kubernetes-examples/keycloak-ingress.yaml | \
sed "s/KEYCLOAK_HOST/keycloak.$(minikube ip).nip.io/" | \
kubectl create -f -

# find out the URLs of Keycloak
KEYCLOAK_URL=https://keycloak.$(minikube ip).nip.io/auth &&
echo "" &&
echo "Keycloak:                 $KEYCLOAK_URL" &&
echo "Keycloak Admin Console:   $KEYCLOAK_URL/admin" &&
echo "Keycloak Account Console: $KEYCLOAK_URL/realms/myrealm/account" &&
echo ""
