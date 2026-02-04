// groovylint-disable CompileStatic
// groovylint-disable NestedBlockDepth
// groovylint-disable GStringExpressionWithinString

// global shared library functions: defaultCheckout, withHarbor, bash
// https://github.com/erhhung/homelab-k8s/tree/main/files/jenkins/sharedlib

pipeline {
  agent { label 'builder' }

  options {
    skipDefaultCheckout()
  }
  environment {
    IMAGE_NAME = 'mcp-crawl4ai'
    NAMESPACE  = 'open-webui'
  }

  stages {
    stage('Setup') {
      steps {
        defaultCheckout()

        // inject Harbor credential
        // vars for `buildah_login`
        withHarbor {
          bash '''
          sys_info
          env_vars
          identities
          init_certs
          buildah_login
          '''
        }
      }
    }

    stage('Build') {
      steps {
        bash '''
        # `buildah_*` functions will emit section markers
        buildah_build $IMAGE_NAME --no-cache -f ./Dockerfile .
        buildah_push  $IMAGE_NAME $GIT_COMMIT_SHORT_SHA
        '''
      }
    }

    stage('Deploy') {
      steps {
        bash '''
        IMAGE="$CI_REGISTRY_PATH/$IMAGE_NAME:$GIT_COMMIT_SHORT_SHA"

        component='mcpo'
        section_start deploy "Deploy $component"
        set_k8s_image Deployment $NAMESPACE $component container crawl4ai $IMAGE
        kubectl rollout restart Deployment -n $NAMESPACE $component
        section_end deploy
        '''
      }
    }
  }
}
