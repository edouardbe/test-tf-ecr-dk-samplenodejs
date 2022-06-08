# install dependencies from package.json
npm install

# start the sample application
npm start

# test on your browser, you should get hello world
http://localhost:80

# stop the sample application
Ctrl-C

# create docker image
docker build . -t sample-nodejs-app:latest

# run a docker container based on the image
docker run -p 80:80 sample-nodejs-app:latest        
> sample_nodejs_app@1.0.0 start
> node server.js
Running on http://0.0.0.0:80

# test on your browser, you should get hello world
http://localhost:80

# stop the docker container
Ctrl-C

# AWS IAM needed permissions. Add these permissions to the user you will use
- AmazonEC2ContainerRegistryFullAccess
- AmazonECS_FullAccess
- IAMFullAccess
- ElasticLoadBalancingFullAccess
- AmazonS3FullAccess

# terraform
# either change the aws profile = "test-tf-ecr-dk-samplenodejs" to your own profile name, or create the credentials you need in ~/.aws/credentials
[test-tf-ecr-dk-samplenodejs]
aws_access_key_id = AKIA...
aws_secret_access_key = y3zJQ...

# init
terraform init

# plan
terraform plan

# apply
terraform apply
yes

# you will get the loadbalancer address as output, something like
loadbalancer-address = "test-lb-753262703.us-east-1.elb.amazonaws.com"

# test on your browser, you should get hello world
http://test-lb-753262703.us-east-1.elb.amazonaws.com/