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
# utilities
#
function get_relative() {
    local base="$(pwd)"
    local target="${1}"
    local answer="$(realpath "${target}" --relative-to="${base}")"
    echo $answer
}

function get_version() {
    local filename="$(ls *.[jw]ar)"
    local version="$(echo "${filename%.*}" | awk -F- '{print $NF}')"
    echo $version
}

function docker_build_and_push() {
    local wd="${1}"
    local name="$(basename "${wd}")"

    cd "${wd}"
    local version="$(get_version)"
    repo="${DOCKER_USER}/${DOCKER_REPO_PREFIX}${name}"

    docker build \
        --build-arg VERSION="${version}" \
        --tag "${repo}:${version}" \
        --tag "${repo}:latest" \
        .
    docker push "${repo}:${version}"
    docker push "${repo}:latest"
}

function prepare() {
    local wd="${1}"
    local docker_file="${2}"

    rm -rf "${wd}" && mkdir -p "${wd}"
    cd "${wd}" && cp "$(get_relative "${DIR_TOP}/${docker_file}")" Dockerfile
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

prepare "${DIR_OTA_WORKER}" "Dockerfile.ota"
prepare "${DIR_RMM_WORKER}" "Dockerfile.rmm"
prepare "${DIR_RMM_PORTAL}" "Dockerfile.portal"


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
docker_build_and_push "${DIR_OTA_WORKER}"
docker_build_and_push "${DIR_RMM_WORKER}"
docker_build_and_push "${DIR_RMM_PORTAL}"

