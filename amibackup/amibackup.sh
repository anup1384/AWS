#!/bin/bash
#Script to create AMI of server on daily basis and deleting AMI older than n no of days
#By Anup Dubey

echo -e "----------------------------------\n   `date`   \n----------------------------------"

#To create a unique AMI name for this script
echo "instance-`date +%d%b%y`" > /tmp/aminame.txt

echo -e "Starting the Daily AMI creation: `cat /tmp/aminame.txt`\n"

#To create AMI of defined instance
aws ec2 create-image --instance-id i-0fddb9446a53bb9f3 --name "`cat /tmp/aminame.txt`"  --region us-east-1 --description "Test server Daily auto AMI creation" --no-reboot | grep -i ami | awk '{print $4}' > /tmp/amiID.txt

#Showing the AMI name created by AWS
echo -e "AMI ID is: `cat /tmp/amiID.txt`\n"

echo -e "Looking for AMI older than 3 days:\n "

#Finding AMI older than 3 days which needed to be removed
echo "instance-`date +%d%b%y --date '4 days ago'`" > /tmp/amidel.txt

#Finding Image ID of instance which needed to be Deregistered
aws ec2 describe-images --filters --region us-east-1 "Name=name,Values=`cat /tmp/amidel.txt`" | grep -i ImageId | awk '{ print  $2 }' > /tmp/imageid.txt
sed -i 's/\"//g' /tmp/imageid.txt
sed -i 's/\,//g' /tmp/imageid.txt
if [[ -s /tmp/imageid.txt ]];
then

echo -e "Following AMI is found : `cat /tmp/imageid.txt`\n"

#Find the snapshots attached to the Image need to be Deregister
aws ec2 describe-images  --image-ids `cat /tmp/imageid.txt` --region us-east-1 | grep snap | awk ' { print $2 }' > /tmp/snap.txt
sed -i 's/\"//g' /tmp/snap.txt
echo -e "Following are the snapshots associated with it : `cat /tmp/snap.txt`:\n "
 
echo -e "Starting the Deregister of AMI... \n"

#Deregistering the AMI 
aws ec2 deregister-image --image-id `cat /tmp/imageid.txt` --region us-east-1

echo -e "\nDeleting the associated snapshots.... \n"

#Deleting snapshots attached to AMI
for i in `cat /tmp/snap.txt`;do aws ec2 delete-snapshot --snapshot-id $i --region us-east-1 ; done

else

echo -e "No AMI found older than minimum required no of days"
fi

