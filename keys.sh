#!/bin/bash
# Script to pull ssh keys from iam user corresponding to the group supplied by the env
# variable IAM_GROUP. This defaults to global-operations

if [ -z ${IAM_GROUPS+x} ];
  then
    echo "No groups specified in the environment settings! Exiting!";
    exit 1
fi
function get_keys_from_users_in_group () {
  for user in $(aws iam get-group --group-name $1 --query "Users[*].UserName" --output text);
    do
      for keyid in $(aws iam list-ssh-public-keys --user-name $user --query "SSHPublicKeys[*].SSHPublicKeyId" --output text);
        do
          echo $(aws iam get-ssh-public-key --user-name $user --ssh-public-key-id $keyid --encoding SSH --query 'SSHPublicKey.SSHPublicKeyBody' --output text)
          echo $(aws iam get-ssh-public-key --user-name $user --ssh-public-key-id $keyid --encoding SSH --query 'SSHPublicKey.SSHPublicKeyBody' --output text) >> ~/.ssh/authorized_keys.d/freeletics-iam
      done
  done
}
function run_get_keys () {
  echo > ~/.ssh/authorized_keys.d/freeletics-iam
  chmod 0600 ~/.ssh/authorized_keys.d/freeletics-iam
  iam_groups=(${IAM_GROUPS//,/ })
  for each in $iam_groups;
    do
      get_keys_from_users_in_group $each
  done
  /usr/bin/update-ssh-keys
}

echo "$(date) Retrieve keys and apply changes if needed"
run_get_keys
if [[ -z ${RUNONCE+x} ]]; then
  while true
  do 
      echo "$(date) Retrieve keys and apply changes if needed"
      run_get_keys
      sleep 300
  done
fi
exit 0
