// pipeline {
//     agent any
    
//     environment {
//         // Ensure this matches the ID of your AWS credentials in Jenkins
//         AWS_CRED = credentials('AWS_Aadii') 
//     }

//     stages {
//         stage('Task 1: Provision & Output Capture') {
//             steps {
//                 withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'AWS_Aadii']]) {
//                     // Execute terraform apply
//                     bat "terraform apply -var-file=${env.BRANCH_NAME}.tfvars -auto-approve"
                    
//                     script {
//                         // Capture public IP
//                         def ipOut = bat(script: "terraform output -raw instance_public_ip", returnStdout: true).trim()
//                         env.INSTANCE_IP = ipOut.split("\n")[-1].trim() 
                        
//                         // Capture Instance ID
//                         def idOut = bat(script: "terraform output -raw instance_id", returnStdout: true).trim()
//                         env.INSTANCE_ID = idOut.split("\n")[-1].trim()
                        
//                         echo "--- TASK 1 CAPTURE COMPLETE ---"
//                         echo "Captured INSTANCE_IP: ${env.INSTANCE_IP}"
//                         echo "Captured INSTANCE_ID: ${env.INSTANCE_ID}"
//                     }
//                 }
//             }
//         }

//         stage('Task 2: Dynamic Inventory') {
//             steps {
//                 // Create the inventory file for Ansible
//                 bat "echo [splunk]>dynamic_inventory.ini"
//                 bat "echo ${env.INSTANCE_IP}>>dynamic_inventory.ini"
                
//                 // Display for verification screenshot
//                 bat "type dynamic_inventory.ini"
//             }
//         }
//     }
// }

pipeline {
    agent any
    
    environment {
        AWS_CRED = credentials('AWS_Aadii')
        // Disables Terraform color codes for cleaner logs
        TF_IN_AUTOMATION = 'true'
    }

    stages {
        stage('Task 1: Provision & Output Capture') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'AWS_Aadii']]) {
                    // -no-color flag makes the output clean for your screenshots
                    bat "terraform apply -var-file=${env.BRANCH_NAME}.tfvars -auto-approve -no-color"
                    
                    script {
                        def ipOut = bat(script: "terraform output -raw instance_public_ip", returnStdout: true).trim()
                        env.INSTANCE_IP = ipOut.split("\n")[-1].trim() 
                        
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

        stage('Task 2: Dynamic Inventory') {
            steps {
                bat "echo [splunk]>dynamic_inventory.ini"
                bat "echo ${env.INSTANCE_IP}>>dynamic_inventory.ini"
                
                echo "--- VERIFYING INVENTORY FILE ---"
                bat "type dynamic_inventory.ini"
            }
        }
    }
}