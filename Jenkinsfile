pipeline {
    agent {
        docker {
            image 'py4x3g/dart_lcov_to_cobertura:v0.0.6'
            args '-e PUB_CACHE=./.pub-cache'
        }
    }
    options {
        timeout(time: 5, unit: 'MINUTES')
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
                timeout(40) {
                    sh "pub run test_coverage"
                }
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