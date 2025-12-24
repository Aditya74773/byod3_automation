


// // pipeline {
// //     agent any
    
// //     environment {
// //         // Disables Terraform color codes and enables automation mode
// //         TF_IN_AUTOMATION = 'true'
// //         // Ensures AWS CLI uses the correct region for the health check
// //         AWS_DEFAULT_REGION = 'us-east-1'
// //     }

// //     stages {
// //         // TASK 1: Provisioning & Output Capture
// //         stage('Task 1: Provision & Output Capture') {
// //             steps {
// //                 withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'AWS_Aadii']]) {
// //                     // Apply infrastructure without messy color codes
// //                     bat "terraform apply -var-file=${env.BRANCH_NAME}.tfvars -auto-approve -no-color"
                    
// //                     script {
// //                         // Capture public IP safely
// //                         def ipOut = bat(script: "terraform output -raw instance_public_ip", returnStdout: true).trim()
// //                         env.INSTANCE_IP = ipOut.split("\n")[-1].trim() 
                        
// //                         // Capture Instance ID safely
// //                         def idOut = bat(script: "terraform output -raw instance_id", returnStdout: true).trim()
// //                         env.INSTANCE_ID = idOut.split("\n")[-1].trim()
                        
// //                         echo "======================================"
// //                         echo "TASK 1: SUCCESSFUL CAPTURE"
// //                         echo "IP ADDRESS: ${env.INSTANCE_IP}"
// //                         echo "INSTANCE ID: ${env.INSTANCE_ID}"
// //                         echo "======================================"
// //                     }
// //                 }
// //             }
// //         }

// //         // TASK 2: Dynamic Inventory Management
// //         stage('Task 2: Dynamic Inventory') {
// //             steps {
// //                 // Create the INI file for Ansible (no spaces around > ensures clean formatting)
// //                 bat "echo [splunk]>dynamic_inventory.ini"
// //                 bat "echo ${env.INSTANCE_IP}>>dynamic_inventory.ini"
                
// //                 echo "--- VERIFYING DYNAMIC INVENTORY FILE ---"
// //                 bat "type dynamic_inventory.ini"
// //             }
// //         }

// //         // TASK 3: AWS Health Status Verification
// //         stage('Task 3: AWS Health Status Verification') {
// //             steps {
// //                 withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'AWS_Aadii']]) {
// //                     script {
// //                         echo "Waiting for instance ${env.INSTANCE_ID} to pass health checks (2/2)..."
// //                         echo "Note: This may take 2-5 minutes. Please wait."
                        
// //                         // Polling AWS until the instance status is 'ok'
// //                         bat "aws ec2 wait instance-status-ok --instance-ids ${env.INSTANCE_ID} --region us-east-1"
                        
// //                         echo "======================================"
// //                         echo "TASK 3: SUCCESS"
// //                         echo "Instance ${env.INSTANCE_ID} is now HEALTHY"
// //                         echo "======================================"
// //                     }
// //                 }
// //             }
// //         }
// //     }
// // }

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
//                     bat "terraform apply -var-file=${env.BRANCH_NAME}.tfvars -auto-approve -no-color"
//                     script {
//                         // Capture output and strip ANSI color characters
//                         def ipRaw = bat(script: "terraform output -raw instance_public_ip", returnStdout: true).trim()
//                         env.INSTANCE_IP = ipRaw.replaceAll(/\u001B\[[;\\d]*m/, "").split('\n')[-1].trim()
                        
//                         def idRaw = bat(script: "terraform output -raw instance_id", returnStdout: true).trim()
//                         env.INSTANCE_ID = idRaw.replaceAll(/\u001B\[[;\\d]*m/, "").split('\n')[-1].trim()
                        
//                         echo "======================================"
//                         echo "CLEANED IP: ${env.INSTANCE_IP}"
//                         echo "CLEANED ID: ${env.INSTANCE_ID}"
//                         echo "======================================"
//                     }
//                 }
//             }
//         }

//         stage('Task 2: Dynamic Inventory') {
//             steps {
//                 bat "echo [splunk]>dynamic_inventory.ini"
//                 bat "echo ${env.INSTANCE_IP}>>dynamic_inventory.ini"
//                 bat "type dynamic_inventory.ini"
//             }
//         }

//         stage('Task 3: AWS Health Status Verification') {
//             steps {
//                 withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'AWS_Aadii']]) {
//                     script {
//                         echo "Waiting for instance ${env.INSTANCE_ID} to pass health checks..."
//                         bat "aws ec2 wait instance-status-ok --instance-ids ${env.INSTANCE_ID} --region us-east-1"
//                         echo "TASK 3: Instance is HEALTHY"
//                     }
//                 }
//             }
//         }

//         stage('Task 4: Splunk Installation & Testing') {
//             steps {
//                 script {
//                     echo "Starting Ansible Configuration via WSL..."
//                     // We use /tmp/ in WSL because the home directory (~/) has restricted permissions
//                     bat """
//                         wsl cp Aadii_new.pem /tmp/Aadii_new.pem
//                         wsl chmod 400 /tmp/Aadii_new.pem
//                         wsl ansible-playbook -i dynamic_inventory.ini playbooks/splunk.yml --private-key /tmp/Aadii_new.pem -u ubuntu --ssh-common-args='-o StrictHostKeyChecking=no'
//                         wsl ansible-playbook -i dynamic_inventory.ini playbooks/test-splunk.yml --private-key /tmp/Aadii_new.pem -u ubuntu --ssh-common-args='-o StrictHostKeyChecking=no'
//                     """
                    
//                     echo "======================================"
//                     echo "TASK 4: SUCCESS"
//                     echo "======================================"
//                 }
//             }
//         }

//         stage('Task 5: Infrastructure Cleanup') {
//             steps {
//                 script {
//                     def destroy = input(message: 'Do you want to destroy the infrastructure?', ok: 'Yes, Destroy')
//                     if(destroy) {
//                         withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'AWS_Aadii']]) {
//                             bat "terraform destroy -var-file=${env.BRANCH_NAME}.tfvars -auto-approve -no-color"
//                             echo "TASK 5: CLEANUP COMPLETE"
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
                    bat "terraform apply -var-file=${env.BRANCH_NAME}.tfvars -auto-approve -no-color"
                    script {
                        def ipRaw = bat(script: "terraform output -raw instance_public_ip", returnStdout: true).trim()
                        env.INSTANCE_IP = ipRaw.replaceAll(/\u001B\[[;\\d]*m/, "").split('\n')[-1].trim()
                        
                        def idRaw = bat(script: "terraform output -raw instance_id", returnStdout: true).trim()
                        env.INSTANCE_ID = idRaw.replaceAll(/\u001B\[[;\\d]*m/, "").split('\n')[-1].trim()
                        
                        echo "======================================"
                        echo "CLEANED IP: ${env.INSTANCE_IP}"
                        echo "CLEANED ID: ${env.INSTANCE_ID}"
                        echo "======================================"
                    }
                }
            }
        }

        stage('Task 2: Dynamic Inventory') {
            steps {
                bat "echo [splunk]>dynamic_inventory.ini"
                bat "echo ${env.INSTANCE_IP}>>dynamic_inventory.ini"
                bat "type dynamic_inventory.ini"
            }
        }

        stage('Task 3: AWS Health Status Verification') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'AWS_Aadii']]) {
                    script {
                        echo "Waiting for instance ${env.INSTANCE_ID} to pass health checks..."
                        bat "aws ec2 wait instance-status-ok --instance-ids ${env.INSTANCE_ID} --region us-east-1"
                        echo "TASK 3: Instance is HEALTHY"
                    }
                }
            }
        }

        stage('Task 4: Splunk Installation & Testing') {
            steps {
                // Task 4 is neglected (skipped)
                echo "Skipping Splunk Installation and Testing as requested."
            }
        }

        stage('Task 5: Infrastructure Cleanup') {
            steps {
                script {
                    def destroy = input(message: 'Do you want to destroy the infrastructure?', ok: 'Yes, Destroy')
                    if(destroy) {
                        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'AWS_Aadii']]) {
                            bat "terraform destroy -var-file=${env.BRANCH_NAME}.tfvars -auto-approve -no-color"
                            echo "TASK 5: CLEANUP COMPLETE"
                        }
                    }
                }
            }
        }
    }
}