#!/bin/bash
catch() {
  retval=$?
  error_message="$(date) $(caller): $BASH_COMMAND"
  echo "$error_message" &> error.log
}
trap 'catch $? $LINENO' ERR
set -ex

# Reads go.sum and returns its contents with the following syntax:
# <module>:<version>
function getGoModules {
    cat go.sum | sed s:/go.mod:: | awk '{print "\""$1 ":" $2 "\","}'
}

# Returns the given amount of spaces, intended for JSON identation
function indent {
    for _ in $(seq 1 $1)
    do
        printf ' '
    done
}

# Gets the "components" elements for the Provenance JSON
function getComponents {
    rawGoModules=$(getGoModules)
    for module in $rawGoModules
    do
        indent 16
        echo "{"
        indent 20
        echo "\"name\": $module"
        indent 20
        echo "\"incorporated\": true"
        indent 16
        echo "},"
    done
}

# ---------------
# Script init
# ---------------

if [ $# != 2 ]
then
    echo "Usage: ./provenance.sh <PROJECT NAME> <BRANCH>"
    echo ""
    echo "PROJECT NAME: Either 'terraform-provider-vcd' or 'go-vcloud-director' or 'cluster-api-provider-cloud-director'"
    echo "BRANCH: Branch from which provenance data should be generated"
    exit 1
fi

project="$1"
branch="$2"

if [[ "$project" != 'terraform-provider-vcd' ]] && [[ "$project" != 'go-vcloud-director' ]] && [[ "$project" != 'cluster-api-provider-cloud-director' ]]
then
    echo "PROJECT NAME must be either 'terraform-provider-vcd' or 'go-vcloud-director' or 'cluster-api-provider-cloud-director'"
    exit 1
fi

tmpDir='tmp'
rm -rf $tmpDir
git clone https://github.com/vmware/$project.git $tmpDir
pushd $tmpDir
git checkout origin/$branch -b $branch

head=$(git log -1 --pretty=format:%H)
version=$(git describe --tags --abbrev=0)
identifier=$(git describe --tags)
components=$(getComponents)

provenanceJsonTemplate="
{
    \"id\": \"http://vmware.com/schemas/software_provenance-0.2.5.json\",
    \"tools\": {
        \"https://sp-taas-vcd-butler.svc.eng.vmware.com/view/CSE/job/capvcd-provenance-pipeline/\": null
    },
    \"root\": \"comp_id.build(target_name='$project', version='$version', sha1='$head')\",
    \"all_components\": {
        \"$project-$identifier\": {
            \"typename\": \"comp.build.golang\",
            \"name\": \"$project\",
            \"version\": \"$version\",
            \"build\": \"$head\",
            \"source_repositories\": [
                {
                    \"content\": \"source\",
                    \"branch\": \"$branch\",
                    \"host\": \"github.com\",
                    \"repo\": \"vmware/$project\",
                    \"ref\": \"$head\",
                    \"protocol\": \"git\",
                    \"paths\": [
                        \"/\"
                    ],
                }
            ],
            \"components\": [
                ${components%,}
            ]
        }
    }
}"

cd ..
rm -rf $tmpDir
echo "$provenanceJsonTemplate" > provenance-$project-$version.json
