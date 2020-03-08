pipeline {
    agent {
        docker {
            image 'google/dart'
            args '-e PUB_CACHE=./.pub-cache'
        }
    }
    stages {
        stage ('Prepare lcov converter') {
            steps {
                sh "curl -O https://raw.githubusercontent.com/eriwen/lcov-to-cobertura-xml/master/lcov_cobertura/lcov_cobertura.py"
            }
        }
        stage ('dependencies') {
            steps {
                sh 'pub get'
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
            post {
                always {
                    sh "python3 lcov_cobertura.py coverage/lcov.info --output coverage/coverage.xml"
                    step([$class: 'CoberturaPublisher', coberturaReportFile: 'coverage/coverage.xml'])
                }
            }
        }
        stage('Run Analyzer') {
            steps {
                sh 'dartanalyzer . --fatal-warnings lib'
            }
        }
    }
}