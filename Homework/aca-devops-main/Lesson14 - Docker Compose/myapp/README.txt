Homework:
2. create own docker-compose project with:
  2.1 nginx container which will proxy pass from 80 port to backend:8000
  2.2 create flask backend app which will run simple app.py on 8000 port
  2.3 create postgresql which will be dependency for both 2.1 2.2 services

3. use own images cloned from ubuntu:latest image (ubuntu for all 3 images)


Solution:
1. Create myapp folder, inside appropriate folders for backend, db and proxy, and the compose file.
2. Clone the repo into ec2, cd to the myapp folder and run docker-compose command 
$ sudo docker-compose up -d