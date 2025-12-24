

// pipeline {
//     agent any
    
//     environment {
//         AWS_CRED = credentials('AWS_Aadii')
//         // Disables Terraform color codes for cleaner logs
//         TF_IN_AUTOMATION = 'true'
//     }

//     stages {
//         stage('Task 1: Provision & Output Capture') {
//             steps {
//                 withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'AWS_Aadii']]) {
//                     // -no-color flag makes the output clean for your screenshots
//                     bat "terraform apply -var-file=${env.BRANCH_NAME}.tfvars -auto-approve -no-color"
                    
//                     script {
//                         def ipOut = bat(script: "terraform output -raw instance_public_ip", returnStdout: true).trim()
//                         env.INSTANCE_IP = ipOut.split("\n")[-1].trim() 
                        
//                         def idOut = bat(script: "terraform output -raw instance_id", returnStdout: true).trim()
//                         env.INSTANCE_ID = idOut.split("\n")[-1].trim()
                        
//                         echo "======================================"
//                         echo "TASK 1: SUCCESSFUL CAPTURE"
//                         echo "IP ADDRESS: ${env.INSTANCE_IP}"
//                         echo "INSTANCE ID: ${env.INSTANCE_ID}"
//                         echo "======================================"
//                     }
//                 }
//             }
//         }

//         stage('Task 2: Dynamic Inventory') {
//             steps {
//                 bat "echo [splunk]>dynamic_inventory.ini"
//                 bat "echo ${env.INSTANCE_IP}>>dynamic_inventory.ini"
                
//                 echo "--- VERIFYING INVENTORY FILE ---"
//                 bat "type dynamic_inventory.ini"
//             }
//         }
//     }
// }


pipeline {
    agent any
    
    environment {
        // Disables Terraform color codes and enables automation mode
        TF_IN_AUTOMATION = 'true'
        // Ensures AWS CLI uses the correct region for the health check
        AWS_DEFAULT_REGION = 'us-east-1'
    }

    stages {
        // TASK 1: Provisioning & Output Capture
        stage('Task 1: Provision & Output Capture') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'AWS_Aadii']]) {
                    // Apply infrastructure without messy color codes
                    bat "terraform apply -var-file=${env.BRANCH_NAME}.tfvars -auto-approve -no-color"
                    
                    script {
                        // Capture public IP safely
                        def ipOut = bat(script: "terraform output -raw instance_public_ip", returnStdout: true).trim()
                        env.INSTANCE_IP = ipOut.split("\n")[-1].trim() 
                        
                        // Capture Instance ID safely
                        def idOut = bat(script: "terraform output -raw instance_id", returnStdout: true).trim()
                        env.INSTANCE_ID = idOut.split("\n")[-1].trim()
                        
                        echo "======================================"
                        echo "TASK 1: SUCCESSFUL CAPTURE"
                        echo "IP ADDRESS: ${env.INSTANCE_IP}"
                        echo "INSTANCE ID: ${env.INSTANCE_ID}"
                        echo "======================================"
                    }
                }
            }
        }

        // TASK 2: Dynamic Inventory Management
        stage('Task 2: Dynamic Inventory') {
            steps {
                // Create the INI file for Ansible (no spaces around > ensures clean formatting)
                bat "echo [splunk]>dynamic_inventory.ini"
                bat "echo ${env.INSTANCE_IP}>>dynamic_inventory.ini"
                
                echo "--- VERIFYING DYNAMIC INVENTORY FILE ---"
                bat "type dynamic_inventory.ini"
            }
        }

        // TASK 3: AWS Health Status Verification
        stage('Task 3: AWS Health Status Verification') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'AWS_Aadii']]) {
                    script {
                        echo "Waiting for instance ${env.INSTANCE_ID} to pass health checks (2/2)..."
                        echo "Note: This may take 2-5 minutes. Please wait."
                        
                        // Polling AWS until the instance status is 'ok'
                        bat "aws ec2 wait instance-status-ok --instance-ids ${env.INSTANCE_ID} --region us-east-1"
                        
                        echo "======================================"
                        echo "TASK 3: SUCCESS"
                        echo "Instance ${env.INSTANCE_ID} is now HEALTHY"
                        echo "======================================"
                    }
                }
            }
        }
    }
}