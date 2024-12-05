pipeline {
    agent any
    
    parameters {
        // Видалено параметр для вибору пакета, тепер завжди будуємо DEB
        // choice(name: 'PACKAGE_TYPE', choices: ['rpm', 'deb'], description: 'Choose package type to build and install')
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    docker.build('admsys-image:latest')
                }
            }
        }
        
        stage('Build DEB Package') {
            steps {
                script {
                    docker.image('admsys-image:latest').inside('--entrypoint=""') {
                        sh 'mkdir -p build'
                        sh '''
                            cd build
                            mkdir -p admsys_1.0-1/DEBIAN
                            echo "Package: admsys" > admsys_1.0-1/DEBIAN/control
                            echo "Version: 1.0-1" >> admsys_1.0-1/DEBIAN/control
                            echo "Section: base" >> admsys_1.0-1/DEBIAN/control
                            echo "Priority: optional" >> admsys_1.0-1/DEBIAN/control
                            echo "Architecture: all" >> admsys_1.0-1/DEBIAN/control
                            echo "Maintainer: Nesquick <nesquick@example.com>" >> admsys_1.0-1/DEBIAN/control
                            echo "Description: Sample admsys Package" >> admsys_1.0-1/DEBIAN/control
                            mkdir -p admsys_1.0-1/usr/local/bin
                            cp /usr/local/bin/counter.sh admsys_1.0-1/usr/local/bin/
                            dpkg-deb --build admsys_1.0-1
                        '''
                    }
                }
            }
        }
        
        stage('Install DEB Package') {
            steps {
                script {
                    docker.image('admsys-image:latest').inside('--entrypoint=""') {
                        sh '''
                            if [ -f ./build/admsys_1.0-1.deb ]; then
                                dpkg -i ./build/admsys_1.0-1.deb
                            else
                                echo "DEB file not found"
                                exit 1
                            fi
                        '''
                    }
                }
            }
        }
        
        stage('Execute Script') {
            steps {
                script {
                    docker.image('admsys-image:latest').inside('--entrypoint=""') {
                        sh 'ls -la /usr/local/bin'
                        sh 'cat /usr/local/bin/counter.sh'
                        sh '/usr/local/bin/counter.sh'
                    }
                }
            }
        }
    }
    
    post {
        always {
            cleanWs()
        }
    }
}
