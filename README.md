# MICROSERVICES 

**Phần 1. Microservices**

1. Dùng restTemplate để gọi service khác:
![image](https://user-images.githubusercontent.com/101548961/195976759-204ffb5b-bb9e-4b8a-b4a2-a01e344eb71e.png)

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
**Danh sách các service:**

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

-------------------------------------------------------------------------------------------------------
**Phần 2 : Tracing** 


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
