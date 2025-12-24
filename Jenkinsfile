// pipeline {
//     agent any
//     environment {
//         TF_IN_AUTOMATION = 'true'
//         AWS_DEFAULT_REGION = 'us-east-1'
//     }
//     stages {
//         stage('Task 1: Provision & Output Capture') {
//             steps {
//                 withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'AWS_Aadii']]) {
//                     bat "terraform init -upgrade"
//                     bat "terraform apply -var-file=main.tfvars -auto-approve -no-color"
//                     script {
//                         def ipRaw = bat(script: "terraform output -raw instance_public_ip", returnStdout: true).trim()
//                         env.INSTANCE_IP = ipRaw.replaceAll(/\u001B\[[;\\d]*m/, "").split('\n')[-1].trim()
//                         def idRaw = bat(script: "terraform output -raw instance_id", returnStdout: true).trim()
//                         env.INSTANCE_ID = idRaw.replaceAll(/\u001B\[[;\\d]*m/, "").split('\n')[-1].trim()
//                     }
//                 }
//             }
//         }
//         stage('Task 2: Dynamic Inventory') {
//             steps {
//                 // Ensure no spaces around the IP for Ansible compatibility
//                 bat "echo [splunk]>dynamic_inventory.ini"
//                 bat "echo ${env.INSTANCE_IP}>>dynamic_inventory.ini"
//             }
//         }
//         stage('Task 3: AWS Health Status Verification') {
//             steps {
//                 withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'AWS_Aadii']]) {
//                     bat "aws ec2 wait instance-status-ok --instance-ids ${env.INSTANCE_ID} --region us-east-1"
//                 }
//             }
//         }
//         stage('Task 4: Splunk Installation & Testing') {
//             steps {
//                 script {
//                     bat """
//                         wsl cp Aadii_new.pem /tmp/Aadii_new.pem
//                         wsl chmod 400 /tmp/Aadii_new.pem
//                         wsl ansible-playbook -i dynamic_inventory.ini playbooks/splunk.yml --private-key /tmp/Aadii_new.pem -u ubuntu --ssh-common-args='-o StrictHostKeyChecking=no'
//                         wsl ansible-playbook -i dynamic_inventory.ini playbooks/test-splunk.yml --private-key /tmp/Aadii_new.pem -u ubuntu --ssh-common-args='-o StrictHostKeyChecking=no'
//                     """
//                 }
//             }
//         }
//         stage('Task 5: Infrastructure Cleanup') {
//             steps {
//                 script {
//                     def destroy = input(message: 'Do you want to destroy?', ok: 'Yes')
//                     if(destroy) {
//                         withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'AWS_Aadii']]) {
//                             bat "terraform destroy -var-file=main.tfvars -auto-approve -no-color"
//                         }
//                     }
//                 }
//             }
//         }
//     }
// }
pipeline {
    agent any
    environment {
        TF_IN_AUTOMATION = 'true'
        AWS_DEFAULT_REGION = 'us-east-1'
    }
    stages {
        stage('Task 1: Provision & Output Capture') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'AWS_Aadii']]) {
                    bat "terraform init -upgrade"
                    bat "terraform apply -var-file=main.tfvars -auto-approve -no-color"
                    script {
                        def ipRaw = bat(script: "terraform output -raw instance_public_ip", returnStdout: true).trim()
                        env.INSTANCE_IP = ipRaw.replaceAll(/\u001B\[[;\\d]*m/, "").split('\n')[-1].trim()
                        def idRaw = bat(script: "terraform output -raw instance_id", returnStdout: true).trim()
                        env.INSTANCE_ID = idRaw.replaceAll(/\u001B\[[;\\d]*m/, "").split('\n')[-1].trim()
                    }
                }
            }
        }
        stage('Task 2: Dynamic Inventory') {
            steps {
                bat "echo [splunk]>dynamic_inventory.ini"
                bat "echo ${env.INSTANCE_IP}>>dynamic_inventory.ini"
            }
        }
        stage('Task 3: AWS Health Status Verification') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'AWS_Aadii']]) {
                    bat "aws ec2 wait instance-status-ok --instance-ids ${env.INSTANCE_ID} --region us-east-1"
                }
            }
        }
        stage('Task 4: Splunk Installation & Testing') {
            steps {
                // Binding specifically for 'SSH Username with private key'
                withCredentials([sshUserPrivateKey(credentialsId: 'Aadii_new', keyFileVariable: 'SECURE_KEY')]) {
                    script {
                        echo "Deploying Splunk using SSH User Private Key credentials..."
                        bat """
                            @echo off
                            :: Convert Windows temp path to WSL path and copy key
                            wsl cp \$(wslpath '${env.SECURE_KEY}') /tmp/Aadii_new.pem
                            wsl chmod 400 /tmp/Aadii_new.pem
                            
                            :: Run Ansible Playbooks
                            wsl ansible-playbook -i dynamic_inventory.ini playbooks/splunk.yml --private-key /tmp/Aadii_new.pem -u ubuntu --ssh-common-args='-o StrictHostKeyChecking=no'
                            wsl ansible-playbook -i dynamic_inventory.ini playbooks/test-splunk.yml --private-key /tmp/Aadii_new.pem -u ubuntu --ssh-common-args='-o StrictHostKeyChecking=no'
                            
                            :: Cleanup WSL temp key
                            wsl rm /tmp/Aadii_new.pem
                        """
                    }
                }
            }
        }
        stage('Task 5: Infrastructure Cleanup') {
            steps {
                script {
                    def destroy = input(message: 'Do you want to destroy?', ok: 'Yes')
                    if(destroy) {
                        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'AWS_Aadii']]) {
                            bat "terraform destroy -var-file=main.tfvars -auto-approve -no-color"
                        }
                    }
                }
            }
        }
    }
}