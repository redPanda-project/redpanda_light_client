pipeline {
    agent {
        docker {
            image 'google/dart-runtime'
            //todo: add caching? args '-v volume:path in docker instance'
        }
    }
    stages {
        stage ('Install dependencies') {
            steps {
                sh "pub get"
            }
        }
        stage('Test') {
            steps {
                sh "pub run test"
            }
        }
        stage('Coverage') {
            steps {
                sh "pub run test_coverage"
            }
        }
        stage('Run Analyzer') {
            steps {
                sh 'dartanalyzer . --fatal-warnings lib'
            }
        }
    }
}