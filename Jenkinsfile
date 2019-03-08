pipeline {
  agent{
      label 'maven'
  }
  stages {
    stage('Build openshift App') {
      steps {
        sh "mvn install"
        
      }
    }
    
    
    
    
    stage('Create Image Builder') {
      when {
        expression {
          def ocDir = tool "oc3.11"
                   withEnv(["PATH+OC=${ocDir}"]) {
          openshift.withCluster('mycluster') {
            openshift.withCredentials( '22448925-74c0-4b32-b90c-251e2753895e' ) {
              echo "In project: ${openshift.project()}"
            return !openshift.selector("bc", "mapit").exists();
            }
            }
          }
        }
      }
      steps {
        script {
          def ocDir = tool "oc3.11"
                   withEnv(["PATH+OC=${ocDir}"]) {
          openshift.withCluster('mycluster') {
            openshift.withCredentials( '22448925-74c0-4b32-b90c-251e2753895e' ) {
            openshift.newBuild("--name=mapit", "--image-stream=redhat-openjdk18-openshift:1.1", "--binary")
            }
          }
          }
        }
      }
    }
    stage('Build Image') {
      steps {
        script {
          def ocDir = tool "oc3.11"
                   withEnv(["PATH+OC=${ocDir}"]) {
          openshift.withCluster('mycluster') {
            openshift.withCredentials( '22448925-74c0-4b32-b90c-251e2753895e' ) {
            openshift.selector("bc", "mapit").startBuild("--from-file=target/mapit-spring.jar", "--wait")
            }
          }
          }
        }
      }
    }
    stage('Promote to DEV') {
      steps {
        script {
           def ocDir = tool "oc3.11"
                   withEnv(["PATH+OC=${ocDir}"]) {
          openshift.withCluster('mycluster') {
            openshift.withCredentials( '22448925-74c0-4b32-b90c-251e2753895e' ) {
            openshift.tag("mapit:latest", "mapit:dev")
            }
          }
          }
        }
      }
    }
    stage('Create DEV') {
      when {
        expression {
           def ocDir = tool "oc3.11"
                   withEnv(["PATH+OC=${ocDir}"]) {
          openshift.withCluster('mycluster') {
            openshift.withCredentials( '22448925-74c0-4b32-b90c-251e2753895e' ) {
            return !openshift.selector('dc', 'mapit-dev').exists()
            }
          }
          }
        }
      }
      steps {
        script {
           def ocDir = tool "oc3.11"
                   withEnv(["PATH+OC=${ocDir}"]) {
          openshift.withCluster('mycluster') {
            openshift.withCredentials( '22448925-74c0-4b32-b90c-251e2753895e' ) {
            openshift.newApp("mapit:latest", "--name=mapit-dev").narrow('svc').expose()
            }
          }
          }
        }
      }
    }
    stage('Promote STAGE') {
      steps {
        script {
           def ocDir = tool "oc3.11"
                   withEnv(["PATH+OC=${ocDir}"]) {
          openshift.withCluster('mycluster') {
            openshift.withCredentials( '22448925-74c0-4b32-b90c-251e2753895e' ) {
            openshift.tag("mapit:dev", "mapit:stage")
            }
          }
          }
        }
      }
    }
    stage('Create STAGE') {
      when {
        expression {
           def ocDir = tool "oc3.11"
                   withEnv(["PATH+OC=${ocDir}"]) {
          openshift.withCluster('mycluster') {
            openshift.withCredentials( '22448925-74c0-4b32-b90c-251e2753895e' ) {
            return !openshift.selector('dc', 'mapit-stage').exists()
            }
          }
          }
        }
      }
      steps {
        script {
           def ocDir = tool "oc3.11"
                   withEnv(["PATH+OC=${ocDir}"]) {
          openshift.withCluster('mycluster') {
            openshift.withCredentials( '22448925-74c0-4b32-b90c-251e2753895e' ) {
            openshift.newApp("mapit:stage", "--name=mapit-stage").narrow('svc').expose()
            }
          }
          }
        }
      }
    }
  }
}
