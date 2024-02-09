def registry = 'https://shubhamgaikwad.jfrog.io'
def imageName = 'shubhamgaikwad.jfrog.io/shubham-docker-local/tweettrend'
def version   = '2.1.3'

pipeline {
    agent {
        node {
            label 'maven'
        }
    }
environment{
	PATH = "/opt/apache-maven-3.9.6/bin:$PATH"
}
    stages {
        stage('build') {
            steps {
                sh 'mvn clean deploy'
           }
       }

         stage("Jar Publish") {
        steps {
            script {
                    echo '<--------------- Jar Publish Started --------------->'
                     def server = Artifactory.newServer url:registry+"/artifactory" ,  credentialsId:"jfrog-artifact-cred"
                     def properties = "buildid=${env.BUILD_ID},commitid=${GIT_COMMIT}";
                     def uploadSpec = """{
                          "files": [
                            {
                              "pattern": "jarstaging/(*)",
                              "target": "shubham-libs-release-local/{1}",
                              "flat": "false",
                              "props" : "${properties}",
                              "exclusions": [ "*.sha1", "*.md5"]
                            }
                         ]
                     }"""
                     def buildInfo = server.upload(uploadSpec)
                     buildInfo.env.collect()
                     server.publishBuildInfo(buildInfo)
                     echo '<--------------- Jar Publish Ended --------------->'

            }
        }
    }

    stage(" Docker Build ") {
      steps {
        script {
           echo '<--------------- Docker Build Started --------------->'
           app = docker.build(imageName+":"+version)
           echo '<--------------- Docker Build Ends --------------->'
        }
      }
    }

            stage (" Docker Publish "){
        steps {
            script {
               echo '<--------------- Docker Publish Started --------------->'
                docker.withRegistry(registry, 'jfrog-artifact-cred'){
                    app.push()
                }
               echo '<--------------- Docker Publish Ended --------------->'
            }
        }
    }

    stage ("Deploy"){
    steps {
        script {
            sh './deploy.sh'
               }
         }
     }	

    }
}
