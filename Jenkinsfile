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
                    // Fixes the "Inconsistent dependency lock file" error
                    bat "terraform init -upgrade"
                    bat "terraform apply -var-file=${env.BRANCH_NAME}.tfvars -auto-approve -no-color"
                    
                    script {
                        // Capture and clean output from ANSI junk characters
                        def ipRaw = bat(script: "terraform output -raw instance_public_ip", returnStdout: true).trim()
                        env.INSTANCE_IP = ipRaw.replaceAll(/\u001B\[[;\\d]*m/, "").split('\n')[-1].trim()
                        
                        def idRaw = bat(script: "terraform output -raw instance_id", returnStdout: true).trim()
                        env.INSTANCE_ID = idRaw.replaceAll(/\u001B\[[;\\d]*m/, "").split('\n')[-1].trim()
                        
                        echo "======================================"
                        echo "IP CAPTURED: ${env.INSTANCE_IP}"
                        echo "ID CAPTURED: ${env.INSTANCE_ID}"
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
                        echo "TASK 3: SUCCESS"
                    }
                }
            }
        }

        stage('Task 4: Splunk Installation & Testing') {
            steps {
                script {
                    echo "Starting Ansible Configuration via WSL..."
                    // Copy key to /tmp/ in WSL to fix "Permission Denied" and "Too Open" errors
                    bat """
                        wsl cp Aadii_new.pem /tmp/Aadii_new.pem
                        wsl chmod 400 /tmp/Aadii_new.pem
                        wsl ansible-playbook -i dynamic_inventory.ini playbooks/splunk.yml --private-key /tmp/Aadii_new.pem -u ubuntu --ssh-common-args='-o StrictHostKeyChecking=no'
                        wsl ansible-playbook -i dynamic_inventory.ini playbooks/test-splunk.yml --private-key /tmp/Aadii_new.pem -u ubuntu --ssh-common-args='-o StrictHostKeyChecking=no'
                    """
                }
            }
        }

        stage('Task 5: Infrastructure Cleanup') {
            steps {
                script {
                    def destroy = input(message: 'Do you want to destroy the infrastructure?', ok: 'Yes, Destroy')
                    if(destroy) {
                        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'AWS_Aadii']]) {
                            bat "terraform destroy -var-file=${env.BRANCH_NAME}.tfvars -auto-approve -no-color"
                        }
                    }
                }
            }
        }
    }
}