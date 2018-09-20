#!/bin/bash
set -o xtrace
set -o errexit


#
# constants
#
# docker
DOCKER_USER="ecgwc"
DOCKER_REPO_PREFIX="helm-"

# git
GIT_URL="http://advgitlab.eastasia.cloudapp.azure.com"

# directories
DIR_TOP="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DIR_BUILD="${DIR_TOP}/.build"
DIR_SRC="${DIR_BUILD}/src"
DIR_OTA_WORKER="${DIR_BUILD}/ota-worker"
DIR_RMM_WORKER="${DIR_BUILD}/rmm-worker"
DIR_RMM_PORTAL="${DIR_BUILD}/rmm-portal"


#
# functions
#
function docker_build_and_push() {
    local wd="${1}"
    local dockerfile="${2}"
    local name="$(basename "${wd}")"

    cd "${wd}"

    local filename="$(ls *.[jw]ar)"
    local version="$(echo "${filename%.*}" | awk -F- '{print $NF}')"
    local repo="${DOCKER_USER}/${DOCKER_REPO_PREFIX}${name}"

    docker build \
        --build-arg VERSION="${version}" \
        --tag "${repo}:${version}" \
        --tag "${repo}:latest" \
        --file "${dockerfile}" \
        .
    docker push "${repo}:${version}"
    docker push "${repo}:latest"
}


#
# ensure where we are
#
[ "$(pwd)" != "${DIR_TOP}" ] && cd "${DIR_TOP}"


#
# pre-conditions
#
if [ -d "${DIR_SRC}" ]; then
    cd "${DIR_SRC}"
    git pull
else
    mkdir -p "${DIR_SRC}"
    git clone "${GIT_URL}/EI-PaaS-RMM/RMM-EI-Server.git" "${DIR_SRC}"
    chmod +x "${DIR_SRC}/gradlew"
fi

rm -rf "${DIR_OTA_WORKER}" && mkdir -p "${DIR_OTA_WORKER}"
rm -rf "${DIR_RMM_WORKER}" && mkdir -p "${DIR_RMM_WORKER}"
rm -rf "${DIR_RMM_PORTAL}" && mkdir -p "${DIR_RMM_PORTAL}"


#
# source build
#
(
    cd "${DIR_SRC}"
    ./gradlew clean fatJar war
    cp OTAWorker/build/libs/ota-worker-*.jar "${DIR_OTA_WORKER}"
    cp Worker/build/libs/worker-*.jar "${DIR_RMM_WORKER}"
    cp WebApp/build/libs/portal-*.war "${DIR_RMM_PORTAL}"
)


#
# create container image
#
docker_build_and_push "${DIR_OTA_WORKER}" "${DIR_TOP}/Dockerfile.ota"
docker_build_and_push "${DIR_RMM_WORKER}" "${DIR_TOP}/Dockerfile.rmm"
docker_build_and_push "${DIR_RMM_PORTAL}" "${DIR_TOP}/Dockerfile.portal"

