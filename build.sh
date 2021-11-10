#!/bin/bash

REPO_NAME=$1

have_repo_name() {
    if [[ -z "${REPO_NAME+set}" ]] || [[ -z "$REPO_NAME" ]] ; then
        return 1
    else
        return 0
    fi
}


# docker build -t pfring:latest -f Dockerfile.pfring .
# if have_repo_name ; then
#     docker tag pfring:latest ${REPO_NAME}/pfring:latest
#     docker tag pfring:latest ${REPO_NAME}/pfring:8.0.0
#     docker tag pfring:latest ${REPO_NAME}/pfring:8.0.0-ubuntu
#     docker push ${REPO_NAME}/pfring:latest
#     docker push ${REPO_NAME}/pfring:8.0.0
#     docker push ${REPO_NAME}/pfring:8.0.0-ubuntu
# fi

# for version in 7.8.0 7.6.0 7.5.0 7.2.0
# for version in 7.6.0 7.5.0 7.2.0
for version in 7.2.0 
do
    echo "building pfring:$version"
    docker build -t pfring:$version -f Dockerfile.pfring-src --build-arg PFRING_VERSION=$version .
    if [ $? -eq 0 ] && have_repo_name ; then
        "uploading to ${REPO_NAME}/"
        docker tag pfring:$version ${REPO_NAME}/pfring:$version
        docker tag pfring:$version ${REPO_NAME}/pfring:$version-ubuntu
        docker push ${REPO_NAME}/pfring:$version
        docker push ${REPO_NAME}/pfring:$version-ubuntu
    else 
        echo "skipping upload"
    fi
done
