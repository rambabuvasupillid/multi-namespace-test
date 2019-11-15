#### setup vault address and login as root
echo "
#################################################################
###         multinamespace test                               ###
### - Enable github authentication                            ###
### - Allow autheticated user access transit secret           ###
#################################################################
## Note:- Before you run the script, please set following     ### 
## parameters as per your requirement                         ### 
## -----------------------------------------------------------###
## root_token=""                                              ###   
## git_personal_token=""                                      ###
## git_user=""                                                ###     
## namespace=""                                               ###
## organization=""                                            ###
## root_policy=""                                             ### 
## namespace_policy=""                                        ### 
## root_policy_file=""                                        ###
## namespace_policy_file=""                                   ###
#################################################################
"

## Setup required variables
root_token=""
git_personal_token=""
git_user=""
namespace=""
organization=""
root_policy=""
namespace_policy=""
root_policy_file=""
namespace_policy_file=""
###

echo "##login to vault as rooti. Press enter to continue"
read $ans
export VAULT_ADDR='http://127.0.0.1:8200'
vault login $root_token

##Create namespace
echo "
##Creating Namespace $namespace
Press Enter to continue
"
read $ans
vault namespace create $namespace
vault namespace list


##Enable github authentication
echo "
##Enable Github Secret and map user for authentication for root namespace
Press Enter to continue
"
read $ans
vault auth enable github
vault write auth/github/config organization=$organization
vault write auth/github/map/users/$git_user value=$root_policy
vault auth list
echo "
Write policy for user inside root namespace
Press Enter
"
read $ans
vault policy write $root_policy $root_policy_file
#vault policy write $namespace_policy $namespace_policy_file
echo "
##list policies in root namespace
Press Enter ...
"
read $ans
vault policy list

echo "
##Enable github authentication for $git_user inside namespace $namespace
Press Enter"
read $ans
vault auth enable -namespace=$namespace  github
vault write -namespace=$namespace auth/github/config organization=$organization
vault write -namespace=$namespace auth/github/map/users/$git_user value=$namespace_policy
vault policy write -namespace=$namespace $namespace_policy $namespace_policy_file

echo "
##enable transit secret engine
Press Enter ...
"
read $ans
vault secrets enable transit
vault secrets list

echo "
##Post transit secret key
Press Enter ...
"
read $ans
curl \
    --header "X-Vault-Token:$root_token" \
    --request POST \
    --data '{"type": "rsa-2048"}'\
    http://127.0.0.1:8200/v1/transit/keys/db_rsa_key

vault read transit/keys/db_rsa_key

## authenticate user with git token
echo "
##Test user $gituser login in root namespace
Press Enter ...
"
read $ans
vault login -method=github token=$git_personal_token

## authenticate user with git token in side namespace
echo "
##Test $gituser login in $namespace
Press Enter ...
"
read $ans
vault login -method=github -namespace=$namespace token=$git_personal_token
