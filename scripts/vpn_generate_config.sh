aws ecr get-login-password --region us-east-2 | docker login --username AWS --password-stdin 126106299275.dkr.ecr.us-east-2.amazonaws.com
USERNAME=$1
LAST_IP_OCTET=$2
docker run -e USERNAME="${USERNAME}" -e LAST_IP_OCTET=$LAST_IP_OCTET -v $(pwd):/data 126106299275.dkr.ecr.us-east-2.amazonaws.com/vpn-generate-config:latest