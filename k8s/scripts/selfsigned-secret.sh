#!/bin/sh
##
# Generates a self-signed cert and pushes
# result to Kubernetes as a secret.
#
# Make sure you have curl built with LibreSSL (OSX)
# curl --version | grep LibreSSL
##

# Variables
COMPANY="Example Inc."
ORG="Example"
ROOT="example.com"
DOMAIN="www.example.com"
SECRET="example-selfsigned-cert"
NAMESPACE="default"

# Delete secret if it exists.
kubectl delete secret ${SECRET} -n ${NAMESPACE}

# Generate root cert and private key to signt he new crt
openssl req -x509 -sha256 -nodes -days 365 -newkey rsa:2048 -subj "/O=${COMPANY}/CN=${ROOT}" -keyout tls-root.key -out tls-root.crt

# Create certificate and private key for domain
openssl req -out tls.csr -newkey rsa:2048 -nodes -keyout tls.key -subj "/CN=${DOMAIN}/O=${ORG}"
openssl x509 -req -days 365 -CA tls-root.crt -CAkey tls-root.key -set_serial 0 -in tls.csr -out tls.crt

# Create the tls secret
kubectl create -n ${NAMESPACE} secret tls ${SECRET} --key tls.key --cert tls.crt

# Verify the secret has been mounted in the ingress gateway pod
kubectl exec -it -n ${NAMESPACE} $(kubectl -n ${NAMESPACE} get pods -l istio=ingressgateway -o jsonpath='{.items[0].metadata.name}') -- ls -al /etc/istio/ingressgateway-certs

# Cleanup
rm -rf tls.crt tls.csr tls.key tls-root.crt tls-root.key
