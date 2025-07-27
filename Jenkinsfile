pipeline { agent any 

stages {  

stage('Clone Repository') {  

steps {
       git branch: 'main'
       url:https://github.com/VM240697/Vjterraformtask
              }
 } 
}  
stage('Terraform Init') {  

steps { sh 'terraform init' } }  

stage('Terraform Validate') {  

steps { sh 'terraform validate' } }  

stage('Terraform Plan') {  

steps {  

sh 'terraform plan' } }  

stage('Terraform Apply') {  

steps {  

sh 'terraform apply -auto-approve'  

} } } 

} 
