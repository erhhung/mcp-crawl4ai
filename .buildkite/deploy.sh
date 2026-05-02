set -euo pipefail

IMAGE="$CI_REGISTRY_PATH/$IMAGE_NAME:$GIT_COMMIT_SHORT_SHA"

component='mcpo'
set_k8s_image Deployment $NAMESPACE $component container crawl4ai $IMAGE
kubectl rollout restart Deployment -n $NAMESPACE $component
