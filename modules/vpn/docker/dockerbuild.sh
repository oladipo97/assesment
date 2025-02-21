aws ecr get-login-password --region us-east-2 | docker login --username AWS --password-stdin 126106299275.dkr.ecr.us-east-2.amazonaws.com
docker build -f GenerateConfigDockerfile -t vpn-generate-config:latest .
docker tag vpn-generate-config:latest 126106299275.dkr.ecr.us-east-2.amazonaws.com/vpn-generate-config:latest
docker push 126106299275.dkr.ecr.us-east-2.amazonaws.com/vpn-generate-config:latest
