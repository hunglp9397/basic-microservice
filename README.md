# MICROSERVICES 

**Phần 1. Microservices**


![image](https://user-images.githubusercontent.com/101548961/195976908-359f5e36-b534-4a6d-8e91-8c8373a88a5e.png)

Check các service đã đăng kí trên Eureka(localhost:8761)
![img_6.png](img_6.png)

2. Tạo một Service "naming server", Sau đó dùng FeinClients để gọi service khác:

![img.png](img.png)

3. Tạo API Gateway (PORT 8765) có tác dụng điều hướng request tới các service

    Conversion:
![img_1.png](img_1.png)

    Exchange:
![img_2.png](img_2.png)

Database: File data.sql


------------------------------------------------------------------------------------------------------------------------
**Phần 2 : Run docker microservices**

2.1
- Bước 1 : Cd tới từng services rồi chạy lệnh `mvn clean package`
- Bước 2 : Cd tới folder basic-microservife, Tạo network bằng lệnh  `docker network create currency-network`
  (Ở đây _currency-network_ là tên network muốn đặt)
  Kiểm tra kết quả : `docker network ls`
        ![img_7.png](img_7.png)
  - Bước 3 : Docker Run file jar của của từng service trên network vừa tạo
      `docker run -p 8000:8000 --network=currency-network --name=exchange-service exchange-service/target/exchange-service-0.0.1-SNAPSHOT.jar`
      `docker run -p 8100:8100 --network=currency-network --name=conversion-service conversion-service-0.0.1-SNAPSHOT.jar`
      `docker run -p 8761:8761 --name naming-server --network currency-network naming-server-0.0.1-SNAPSHOT.jar`


------------------------------------------------------------------------------------------------------------------------
**Phần 3 : Tracing** 


Trong quá trình phát triển và vận hành một hệ thống, để giải quyết các vấn đề phát sinh,ta thường phải theo dõi 
flow của các request trong hệ thống. Flow của một request được bắt đầu kể từ khi hệ thống tiếp nhận request và kết thúc
khi hệ thống không còn xử lý request này nữa. Kỹ thuật này được gọi với thuật ngữ là tracing.

Thông qua distributed tracing, chúng ta có thể theo dõi được flow của một request dễ dàng hơn: xác định được tổng thời 
gian để hệ thống xử lý request đó, hoặc biết được request gặp vấn đề ở service nào.

![img_4.png](img_4.png)

Zipkin là một hệ thống distributed tracing open source. Chạy zipkin docker : "docker -p 9411:9411 openzipkin/zipkin:latest"


Chạy zipkin: localhost:9411

Sau đó connect các service với zipkin

Trace được các request trên giao diện zipkin như hình:
![img_5.png](img_5.png)
