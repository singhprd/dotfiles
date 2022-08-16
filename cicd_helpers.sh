#! /bin/bash

export GH_PAGER=
alias prc="gh pr create --fill --draft && gh pr view --web"
alias pr="gh pr view --web"

function delete_workflow_runs() {
  repo=$1
  # eg test.yml
  workflow_file=$2
  gh api /repos/fac/"$repo"/actions/workflows/"$workflow_file"/runs --jq '.workflow_runs[] | .id' | xargs -I _ -P0 gh api -X DELETE /repos/fac/"$repo"/actions/runs/_
}

function run_watch() {
  gh run watch $(gh run list -u singhprd --limit 1 --json databaseId | jq '.[0].databaseId')
}

function run_view() {
  gh run view $(gh run list -u singhprd --limit 1 --json databaseId | jq '.[0].databaseId')
}


function tgplan() {
  aws-vault exec fa-ci-prod -- terragrunt plan --terragrunt-source-map 'git::ssh://git@github.com/fac/infrastructure-modules.git=/Users/petersingh/dev/infra/infrastructure-modules'
}

function open_in_progress_runs() {
  gh api repos/fac/freeagent/actions/runners | jq -r ".runners[] | .labels[].name" | grep rid | sort | uniq | cut -c 4- | cut -c -10 | xargs -I_ -n1 open  https://github.com/fac/freeagent/actions/runs/_
}

function latest_cicd_run_id_for_branch() {
  getopts "branch:" branch
  gh run list --workflow cicd --branch $branch --limit 1 --json databaseId | jq '.[0].databaseId'
}

function instances_from_run {
  local run_id=$(latest_cicd_run_id)
  local repository='fac/freeagent'
  getopts "branch:" branch
  echo "Finding instances for run id: ${run_id} in ${repository}"

  gh api /repos/fac/freeagent/actions/runs/$run_id/jobs --jq '.jobs[] | {name:.name,id: .id}' \
    | jq 'select(.name | contains("run-spec")) | .id' \
    | xargs -I _ gh run view --log --repo $repository --job=_ \
    | grep -o 'RUNNER_NAME.*' | cut -d '=' -f 2
}

