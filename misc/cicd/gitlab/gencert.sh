#/bin/bash
mkdir -p certs
echo "Create Signing Key and CSR"
openssl req -nodes -newkey rsa:2048 -keyout certs/registry-auth.key -out certs/registry-auth.csr -subj "/CN=gitlab"

echo "Self-Sign Certificate"
openssl x509 -in certs/registry-auth.csr -out certs/registry-auth.crt -req -signkey certs/registry-auth.key -days 3650
docker build -t qnib/data-selfsigned-cert certs/.
