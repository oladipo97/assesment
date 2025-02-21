# AWS-Infra

## How to create a users vpn configuration

    You will need ability to pull docker images from AWS ECR

    1.  cd to directory scripts
    2.  run command vpn_generate_config.sh $USERNAME $LAST_IP_OCTLET
        The USERNAME should be in the form of "FirstName LastName"
        The LAST_IP_OCTLET is found by looking in the tfvars/dev.tfvars file and last_ip_octet in vpn_peers 
        find biggest number and increment it by 1
    3.  This wil create a zip file of VPN Config - USERNAME.zip
    4.  The outpur of this docker also gives the lines for dev staging and production to add to tfvars
    5.  Find vpn_peers in .tfvars file and add corresponding line to end of vpn peers list
    6.  checking files and verify terraform runs in Gitlab
    7.  Share zip file with user to setupo their vpn



##  How to Create/Recreate vpn_generate_config Docker Image

    You will need ability to pull and push docker images to AWS ECR

    1.  cd to directory modules/vpn/docker
    2.  run dockerbuild.sh

    This will create/overwrite the latest version of vpn-generate-config docker in AWS ECR



