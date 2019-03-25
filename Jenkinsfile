pipeline {
  agent{
      label 'maven'
  }
  stages {
    stage('Build openshift App1ication') {
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
            openshift.withCredentials( '634c0960-83cf-4004-9298-41d887aa19aa' ) {
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
            openshift.withCredentials( '634c0960-83cf-4004-9298-41d887aa19aa' ) {
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
            openshift.withCredentials( '634c0960-83cf-4004-9298-41d887aa19aa' ) {
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
            openshift.withCredentials( '634c0960-83cf-4004-9298-41d887aa19aa' ) {
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
            openshift.withCredentials( '634c0960-83cf-4004-9298-41d887aa19aa' ) {
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
            openshift.withCredentials( '634c0960-83cf-4004-9298-41d887aa19aa' ) {
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
            openshift.withCredentials( '634c0960-83cf-4004-9298-41d887aa19aa' ) {
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
            openshift.withCredentials( '634c0960-83cf-4004-9298-41d887aa19aa' ) {
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
            openshift.withCredentials( '634c0960-83cf-4004-9298-41d887aa19aa' ) {
            openshift.newApp("mapit:stage", "--name=mapit-stage").narrow('svc').expose()
            }
          }
          }
        }
      }
    }
  }
}
