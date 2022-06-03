# install dependencies from package.json
npm install

# start the sample application
npm start

# test on your browser, you should get hello world
http://localhost:8080

# stop the sample application
Ctrl-C

# create docker image
docker build . -t sample-nodejs-app:latest
[+] Building 1.1s (10/10) FINISHED                                                                                                                                                                    
 => [internal] load build definition from Dockerfile                                                                                                                                             0.0s
 => => transferring dockerfile: 37B                                                                                                                                                              0.0s
 => [internal] load .dockerignore                                                                                                                                                                0.0s
 => => transferring context: 59B                                                                                                                                                                 0.0s
 => [internal] load metadata for docker.io/library/node:18-alpine                                                                                                                                0.0s
 => [internal] load build context                                                                                                                                                                0.2s
 => => transferring context: 83.33kB                                                                                                                                                             0.2s
 => [1/5] FROM docker.io/library/node:18-alpine                                                                                                                                                  0.0s
 => CACHED [2/5] WORKDIR /usr/src/app                                                                                                                                                            0.0s
 => CACHED [3/5] COPY package.json .                                                                                                                                                             0.0s
 => CACHED [4/5] RUN npm install                                                                                                                                                                 0.0s
 => [5/5] COPY . .                                                                                                                                                                               0.4s
 => exporting to image                                                                                                                                                                           0.3s
 => => exporting layers                                                                                                                                                                          0.2s
 => => writing image sha256:e1644c4de0bc20396ae0a28591a0dd8a6d83b799f0e425e3f62f3aabce5c231e                                                                                                     0.0s
 => => naming to docker.io/library/sample-nodejs-app:latest                          

# run a docker container based on the image
docker run -p 8080:8080 sample-nodejs-app:latest        
> sample_nodejs_app@1.0.0 start
> node server.js
Running on http://0.0.0.0:8080

# test on your browser, you should get hello world
http://localhost:8080

# stop the docker container
Ctrl-C

# AWS IAM needed permissions. Add these permissions to the user you will use
- AmazonEC2ContainerRegistryFullAccess

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
