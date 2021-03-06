pipeline {
    agent {
        docker {
            image 'py4x3g/dart_lcov_to_cobertura'
            args '-e PUB_CACHE=./.pub-cache'
        }
    }
    triggers {
        cron('@midnight')
    }
    stages {
        stage ('dependencies') {
            steps {
                sh 'pub get'
            }
        }
        stage('Test') {
            steps {
                sh "pub run test --no-color"
            }
        }
        stage('Coverage') {
            steps {
                sh "pub run test_coverage"
            }
            post {
                always {
                    sh "python3 /usr/bin/lcov_cobertura.py coverage/lcov.info --output coverage/coverage.xml"
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