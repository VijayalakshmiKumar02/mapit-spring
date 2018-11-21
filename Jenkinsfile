pipeline {
  agent{
      label 'maven'
  }
  stages {
    stage('Build App') {
      steps {
        sh "mvn install"
      }
    }
    stage('preamble') {
        steps {
            script {
                openshift.withCluster('mycluster') {
                  openshift.withCredentials( '22448925-74c0-4b32-b90c-251e2753895e' ) {
                    openshift.withProject() {
                        echo "Using project: ${openshift.project()}"
                         echo "Hello from ${openshift.cluster()}'s default project: ${openshift.project()}"
                       def saSelector = openshift.selector( 'serviceaccount' )
                      saSelector.describe()
                    }
                    }
                }
            }
        }
    }
    
    
    
    stage('Create Image Builder') {
      when {
        expression {
          openshift.withCluster('mycluster') {
            openshift.withCredentials( '22448925-74c0-4b32-b90c-251e2753895e' ) {
            return !openshift.selector("bc", "mapit").exists();
            }
          }
        }
      }
      steps {
        script {
          openshift.withCluster('mycluster') {
            openshift.newBuild("--name=mapit", "--image-stream=redhat-openjdk18-openshift:1.1", "--binary")
          }
        }
      }
    }
    stage('Build Image') {
      steps {
        script {
          openshift.withCluster('mycluster') {
            openshift.selector("bc", "mapit").startBuild("--from-file=target/mapit-spring.jar", "--wait")
          }
        }
      }
    }
    stage('Promote to DEV') {
      steps {
        script {
          openshift.withCluster('mycluster') {
            openshift.tag("mapit:latest", "mapit:dev")
          }
        }
      }
    }
    stage('Create DEV') {
      when {
        expression {
          openshift.withCluster('mycluster') {
            return !openshift.selector('dc', 'mapit-dev').exists()
          }
        }
      }
      steps {
        script {
          openshift.withCluster('mycluster') {
            openshift.newApp("mapit:latest", "--name=mapit-dev").narrow('svc').expose()
          }
        }
      }
    }
    stage('Promote STAGE') {
      steps {
        script {
          openshift.withCluster('mycluster') {
            openshift.tag("mapit:dev", "mapit:stage")
          }
        }
      }
    }
    stage('Create STAGE') {
      when {
        expression {
          openshift.withCluster('mycluster') {
            return !openshift.selector('dc', 'mapit-stage').exists()
          }
        }
      }
      steps {
        script {
          openshift.withCluster('mycluster') {
            openshift.newApp("mapit:stage", "--name=mapit-stage").narrow('svc').expose()
          }
        }
      }
    }
  }
}
