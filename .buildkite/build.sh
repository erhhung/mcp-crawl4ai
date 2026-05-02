set -euo pipefail

buildah_login
buildah_build $IMAGE_NAME --no-cache -f ./Dockerfile .
buildah_push  $IMAGE_NAME $GIT_COMMIT_SHORT_SHA
