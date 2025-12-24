stage('Task 1: Provision & Output Capture') {
    steps {
        // Execute terraform apply with auto-approve
        bat "terraform apply -var-file=${env.BRANCH_NAME}.tfvars -auto-approve"
        
        script {
            // Capture public IP into Jenkins env variable
            def ipOut = bat(script: "terraform output -raw instance_public_ip", returnStdout: true).trim()
            env.INSTANCE_IP = ipOut.split("\n")[-1].trim() 
            
            // Capture Instance ID into Jenkins env variable
            def idOut = bat(script: "terraform output -raw instance_id", returnStdout: true).trim()
            env.INSTANCE_ID = idOut.split("\n")[-1].trim()
            
            // Print for Verification (Capture this for your screenshot)
            echo "--- TASK 1 CAPTURE COMPLETE ---"
            echo "Captured INSTANCE_IP: ${env.INSTANCE_IP}"
            echo "Captured INSTANCE_ID: ${env.INSTANCE_ID}"
        }
    }
}