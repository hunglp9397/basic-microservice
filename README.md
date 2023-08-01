🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥

**Mục lục**
   - [ **Phần 1: Microservices**]()
   - [ **Phần 2 : Tracing  (có thể bỏ qua phần này)**]()
   - [ **Phần 3 : Run docker microservices**]()


🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥




[ **Phần 1: Microservices**]()

![image](https://user-images.githubusercontent.com/101548961/195976908-359f5e36-b534-4a6d-8e91-8c8373a88a5e.png)

Check các service đã đăng kí trên Eureka(localhost:8761)
![img_6.png](images/img_6.png)

2. Tạo một Service "naming server", Sau đó dùng FeinClients để gọi service khác:

![img.png](images/img.png)

3. Tạo API Gateway (PORT 8765) có tác dụng điều hướng request tới các service

    Conversion:
![img_1.png](images/img_1.png)

    Exchange:
![img_2.png](images/img_2.png)

Database: File data.sql

----------------------------------------------------------------------------------------------------------

[ **Phần 2 : Tracing  (có thể bỏ qua phần này)**]()

Trong quá trình phát triển và vận hành một hệ thống, để giải quyết các vấn đề phát sinh,ta thường phải theo dõi 
flow của các request trong hệ thống. Flow của một request được bắt đầu kể từ khi hệ thống tiếp nhận request và kết thúc
khi hệ thống không còn xử lý request này nữa. Kỹ thuật này được gọi với thuật ngữ là tracing.

Thông qua distributed tracing, chúng ta có thể theo dõi được flow của một request dễ dàng hơn: xác định được tổng thời 
gian để hệ thống xử lý request đó, hoặc biết được request gặp vấn đề ở service nào.

![img_4.png](images/img_4.png)

Zipkin là một hệ thống distributed tracing open source. Chạy zipkin docker : `docker run -p 9411:9411 openzipkin/zipkin:latest`


Chạy zipkin: localhost:9411

Sau đó connect các service với zipkin bằng cách sau:

Thêm các dependency sau vào các file pom của services: conversion, exchange, naming-server, api-gateway
      
       <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-sleuth</artifactId>
        </dependency>

        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-sleuth-zipkin</artifactId>
        </dependency>

Trace được các request trên giao diện zipkin như hình:
![img_5.png](images/img_5.png)



------------------------------------------------------------------------------------------------------------------------
[**Phần 3 : Run docker microservices**]()
Lưu ý : Phần này không dùng docker compose, Run container theo cách dễ hiểu


1. **Tạo network**

   `docker network create microservice_network`


2. **Mysql service**

    - Pull images mysql : `docker pull mysql:5.7`
    - Run container từ images vừa pull: 
   `docker run --name mysql-instance -v /tmp/mysql-data:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=dummypassword -e MYSQL_DATABASE=db-exchange-service -e MYSQL_USER=hunglp -e MYSQL_PASSWORD=dummypassword --network microservice_network -p 3306:3306 -it mysql:5.7`
    - Kết quả: ![img_13.png](images/img_13.png)
    - Truy cập vào container mysql : `docker exec -it mysql-instance bash -l`
    - Đăng nhập mysql instance bằng lệnh :  `mysql -uroot -pdummypassword`
    - hiển thị list databases : `show databases;`
    - Sử dụng schema : `use db-exchange-service;`
    - Show tables cuar schema: `show tables;`
    - Execute các câu query ở file [data.sql](images/data.sql):  

3. **Naming service**
   - Sửa file pom ( trong naming-server) thành như sau :
   - !images/[img_15.png](images/img_15.png)
   - cd đến thư mục naming-server, Chạy lệnh sau để build images `./mvnw spring-boot:build-image -DskipTests`
   - Kết quả: ![img_16.png](images/img_16.png)
   - Run container từ images vừa build: `docker run -p 8761:8761 123497/naming-server:0.0.1-SNAPSHOT --name=naming-instance --network microservice_network `
   - Kết quả:![img_17.png](images/img_17.png)



4. **Exchange-Service:**
    - Thêm vào file pom.xml như sau:
    - ![img_11.png](images/img_11.png)
    - Apply config cho docker (Path DB và Path join tới naming server)
    - ![img_14.png](images/img_14.png)
    - ![img_18.png](images/img_18.png)
    - cd tới thư mục exchange-services
    - Run lệnh sau để build images bằng maven: `./mvnw spring-boot:build-image -DskipTests`
    - Kiểm tra images vừa build: : `docker images | grep exchange-service`
    - Kết quả : 
    ![img_12.png](images/img_12.png)
    - Run container exchange-service : `docker run -p 8000:8000 123497/exchange-service:0.0.1-SNAPSHOT --name=exchange-instance --network microservice_network -d mysql-instance`
    - ---------------------------------- Xong -------
    - Kết quả :
    - ![img_20.png](images/img_20.png)
    - ![img_19.png](images/img_19.png) 
    - ![img_21.png](images/img_21.png)


5. **Conversion-Service:**
   - Thêm vào file pom.xml như sau:
   - ![img_23.png](images/img_23.png)
   - Apply config cho docker(Path join tới naming sever và url api call sang exchange service) :
   - ![img_27.png](images/img_27.png)
   - cd tới thư mục conversion-serrvice
   - Build images : `./mvnw spring-boot:build-image -DskipTests`(Thường lần 1 sẽ lỗi, chạy lại lệnh này lần 2 là đươ :v)
   - Kết quả: ![img_24.png](images/img_24.png)
   - Run container conversion-service: `docker run -p 8100:8100 123497/conversion-service:0.0.1-SNAPSHOT --name=conversion-instance --network microservice_network`
   - Kết quả:
   - ![img_25.png](images/img_25.png)
   

6. **API Gateway**
   - Build như các service trên
   - `./mvnw spring-boot:build-image -DskipTests`
   - `docker run -p 8765:8765 123497/api-gateway:0.0.1-SNAPSHOT --name=api-gateway --network microservice_network`

==> Tổng kết:
![img_26.png](images/img_26.png)

------------------------------------------------------------------------------------------------------------------------
[**Phần 4 : Run docker microservices với Docker compose**]()
1.  Tạo file docker-compose.yaml trong folder lớn của project
   - Config như sau: 
      ![img_34.png](images/img_34.png)
      ![img_35.png](images/img_35.png)
  


2. Run docker containers
   - cd tới folder basic-microservice
   - Run lệnh : `docker-compose up`
   

3. Kết quả:
   - ![img_36.png](images/img_36.png)

   - ![img_37.png](images/img_37.png)
   - Gọi internal API trong exchange-service
   ![img_38.png](images/img_38.png)
   - Gọi exchange api thoong qua naming-server
   - ![img_39.png](images/img_39.png)
   - Gọi microservices thông qua rest api:
   - ![img_40.png](images/img_40.png)
   - Gọi microservies thông qua fein client
   - ![img_41.png](images/img_41.png)

Xong.

------------------------------------------------------------------------------------------------------------------------
[**Phần 5 : Kubernetes với Microservices**]()

_**Lưu ý : Code thực hành sẽ ở branch: kubernetes và sẽ chỉ thực hành 2 service : conversion-service và exchange-service**_


1. Build lại images (version là 0.0.2-SNAPSHOT)
   - build images bằng lệnh : `./mvnw spring-boot:build-image -DskipTests`
   - Kết quả : ![1.png](images/1.jpg)

2. Push images lên dockerhub
   - `docker push 123497/exchange-service:0.0.2-SNAPSHOT`
   - `docker push 123497/conversion-service:0.0.2-SNAPSHOT`
   - Kết quả : 
   - ![2.png](images/2.jpg)

3. Tạo deployments và expose service
   - Mysql service: 
      + `cd k8s/database`
      + `kubectl apply -f=mysql-pvc.yml -f=mysql-pv.yml -f=mysql-deploy.yml -f=mysql-service.yml`
   - Exchange-service:
      + `cd k8s/exchange`
      + `kubectl apply -f=exchange-deploy.yml -f=exchange-service.yml`
   - Conversion-service
      + `cd k8s/conversion`
      + `kubectl apply -f=conversion-deploy.yml -f=conversion-service.yml`

4.  Expose các service
   - Expose mysql(Run cmd administrator) : `minikube service mysqldb`
      + Get pods : `kubectl get pod`
      + Truy cập vào mysql của pods bằng lệnh: `kubectl exec --stdin --tty mysql-deploy-759d8869bc-rmqr4 -- /bin/bash` (mysql-deploy-759d8869bc-rmqr4 là tên của pod)
      + Login mysql : `mysql -uroot -pPassword123`
      + Set quyền cho các user : `GRANT ALL PRIVILEGES ON *.* TO 'root'@'%';` 
      + Apply : `FLUSH PRIVILEGES;`
   -  Expose currency exchange(Run cmd administator) : `minikube service currenyc-`
   -  Ex
      + 


      https://stackoverflow.com/questions/2983248/com-mysql-jdbc-exceptions-jdbc4-communicationsexception-communications-link-fai/2985169#2985169
