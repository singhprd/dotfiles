export AWS_VAULT_KEYCHAIN_NAME=login
export AWS_SDK_LOAD_CONFIG=1

function bw_session () {
  bw unlock $(security find-generic-password -w -a peter-normal -s normal) --raw
}

function totp () {
  BW_SESSION=$(bw_session) bw get totp 7cf11216-2ade-49b7-8c43-ac3900adcdf6 | pbcopy
}

function totp_raw () {
  bw get --session=$(bw_session) totp 7cf11216-2ade-49b7-8c43-ac3900adcdf6
}

function awsc () {
  aws-vault login --mfa-token=$(totp_raw) $1
}

# function awse () {
#   aws-vault exec --mfa-token=$(totp_raw) $1 -- $2
# }

function sslogin () {
  aws-vault exec --mfa-token=$(totp_raw) shared-services -- aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin 486229364833.dkr.ecr.eu-west-1.amazonaws.com/freeagent/base
}

function tgplan() {
  aws-vault exec fa-ci-prod -- terragrunt plan --terragrunt-source-map 'git::ssh://git@github.com/fac/infrastructure-modules.git=/Users/petersingh/dev/infra/infrastructure-modules'
}
