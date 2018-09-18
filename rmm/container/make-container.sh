#!/bin/bash
set -o xtrace
set -o errexit


#
# directories
#
GIT_URL="http://alex.shao@advgitlab.eastasia.cloudapp.azure.com"
DIR_TOP="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DIR_SRC="${DIR_TOP}/src"
DIR_OTA_WORKER="${DIR_TOP}/ota-worker"
DIR_RMM_WORKER="${DIR_TOP}/rmm-worker"
DIR_RMM_PORTAL="${DIR_TOP}/rmm-portal"


#
# ensure where we are
#
[ "$(pwd)" != "${DIR_TOP}" ] && cd "${DIR_TOP}"


#
# pre-conditions
#
[ -d "${DIR_SRC}" ] || (
    mkdir -p "${DIR_SRC}"
    git clone ${GIT_URL}/EI-PaaS-RMM/RMM-EI-Server.git ${DIR_SRC}
    chmod +x "${DIR_SRC}/gradlew"
)
[ -d "${DIR_OTA_WORKER}" ] && rm -f "${DIR_OTA_WORKER}"/*.jar || (
    mkdir -p "${DIR_OTA_WORKER}"
    cd "${DIR_OTA_WORKER}"
    ln -s ../Dockerfile.ota Dockerfile
)
[ -d "${DIR_RMM_WORKER}" ] && rm -f "${DIR_RMM_WORKER}"/*.jar || (
    mkdir -p "${DIR_RMM_WORKER}"
    cd "${DIR_RMM_WORKER}"
    ln -s ../Dockerfile.rmm Dockerfile
)
[ -d "${DIR_RMM_PORTAL}" ] && rm -f "${DIR_RMM_PORTAL}"/*.war || (
    mkdir -p "${DIR_RMM_PORTAL}"
    cd "${DIR_RMM_PORTAL}"
    ln -s ../Dockerfile.portal Dockerfile
)


#
# source build
#
(
    cd ${DIR_SRC}
    ./gradlew clean fatJar war
    cp OTAWorker/build/libs/ota-worker-*.jar "${DIR_OTA_WORKER}"
    cp Worker/build/libs/worker-*.jar "${DIR_RMM_WORKER}"
    cp WebApp/build/libs/portal-*.war "${DIR_RMM_PORTAL}"
)



