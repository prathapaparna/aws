# aws
Vpc link
https://stackoverflow.com/questions/45164355/what-is-vpc-subnet-in-aws

## Load Balancer & Auto scaling
### Load Balancer
create 2 ec2 instances and install httpd and enable port 80
create a load balancer
 follow the below link to for ECR and ECS
 
 https://mydeveloperplanet.com/2021/09/07/how-to-deploy-a-spring-boot-app-on-aws-ecs-cluster/
 https://mydeveloperplanet.com/2021/10/12/how-to-deploy-a-spring-boot-app-on-aws-fargate/


CLB ---> no condition for config directly we connect ec2 servers
ALB ---> we need to cretae target group attach tg as a listerner -- http/https protocol
NLB ----> " " ---> tcp/tcl protocol---> very high perfomance
