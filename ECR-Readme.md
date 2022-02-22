# Deploy an application with ECR and ECS
## Prerequisites
   create an ec2 instance
   install git,java,maven,docker
   
clone spring boot application files from git hub
```
git clone https://github.com/prathapaparna/aws.git
```
build package
```
mvn clean install
```
## Create a ECR repo
![image](https://user-images.githubusercontent.com/99127429/155153723-e36dadcb-7f26-4890-9a2f-dfa4cc2f282e.png)

click on view push commands for create and push docker image into ECR Repo

![image](https://user-images.githubusercontent.com/99127429/155153937-2af81f80-e5e3-4b58-bb39-6a83f38c694e.png)

## Now Create Task Definitions

<img width="656" alt="image" src="https://user-images.githubusercontent.com/99127429/155154247-d4fbb887-3cbe-402f-b683-2c7e17cdd415.png">

create IAM role for ecs task

![image](https://user-images.githubusercontent.com/99127429/155154444-98208006-2dd0-4f3c-9b9c-60f0f539f685.png)

## Now Create a cluster
select ec2 while creating cluster

![image](https://user-images.githubusercontent.com/99127429/155154693-b8bde1f2-8d2d-4ba2-85fe-5c6640f94ed3.png)

### create a service in the cluster and enable ALB and ASG

![image](https://user-images.githubusercontent.com/99127429/155155041-b376fcf9-1a3b-4c45-8d18-483a9d256b96.png)

![image](https://user-images.githubusercontent.com/99127429/155155266-226fccfb-6047-4a50-b429-c6b4b745f1b5.png)
![image](https://user-images.githubusercontent.com/99127429/155155313-19b28b1d-3578-4e62-b9d1-0a5883058e81.png)
![image](https://user-images.githubusercontent.com/99127429/155155390-b3191575-d5d5-4a2a-8121-b295e745f6b2.png)
![image](https://user-images.githubusercontent.com/99127429/155155484-3b23ced2-f739-4fdf-ae28-e7702ef1e104.png)





