#!/bin/bash
#set -x 

if [ -z ${PLUGIN_ACTION} ]; then
    PLUGIN_ACTION="check"
fi

if [ -z ${PLUGIN_MAX_NR_COMMITS} ]; then
    PLUGIN_MAX_NR_COMMITS=30
fi

if [ -z ${PLUGIN_MAIN_BRANCH} ]; then
    echo "Error: please set the MAIN_BRANCH parameter to your used main/master branch."
    exit 255
fi


ACTION=${PLUGIN_ACTION}
LAST_NR_COMMITS_TO_CHECK=${PLUGIN_MAX_NR_COMMITS}
MAIN_BRANCH=${PLUGIN_MAIN_BRANCH}

BRANCH_TERM="";

BRANCH=$(git branch --show-current)

export GNUPGHOME=/home/gpg/


hasSignature() {
    local commit=$1

    NR=$(git cat-file commit $commit | grep -c "gpgsig -----BEGIN")

    if [ ${NR} -gt 0 ]; then
        return 1
    else
        return 0
    fi
}

COMMITS=$(git log HEAD --no-merges --oneline --not origin/${MAIN_BRANCH} -n ${LAST_NR_COMMITS_TO_CHECK}| awk '{print $1}')

NO_SIG=0
VERIFY_FAILED=0

for c in $COMMITS; do
    hasSignature $c
    if [ $? -eq 1 ]; then
        git verify-commit "$c" >/dev/null 2>&1
        if [ $? -ne 0 ]; then
            VERIFY_FAILED=1
            echo "Commit: ${c} Verification failed"
        fi
    else
        NO_SIG=1
        echo "Commit: ${c} no signature at all"
    fi
done


if [ "${ACTION}" == "check" ]; then

    if [ ${NO_SIG} -eq 1 ]; then
        echo "Check failed because at least one commit is not signed"
        exit 1
    fi

else if [ "${ACTION}" == "verify" ]; then

    if [ ${NO_SIG} -eq 1 ]; then
        echo "Check failed because at least one commit is not signed"
        exit 1
    fi

    if [ ${VERIFY_FAILED} -eq 1 ]; then
        echo "Check failed because at least one commit failed signature verification"
        exit 1
    fi

else 
    echo "Unknown Command: ${ACTION}"
fi
fi
