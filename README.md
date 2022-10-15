# MICRO SERVICES


1. Dùng restTemplate để gọi service khác:
![image](https://user-images.githubusercontent.com/101548961/195976759-204ffb5b-bb9e-4b8a-b4a2-a01e344eb71e.png)

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
**Danh sách các service:**

![image](https://user-images.githubusercontent.com/101548961/195976908-359f5e36-b534-4a6d-8e91-8c8373a88a5e.png)

2. Tạo một Service "naming server", Sau đó dùng FeinClients để gọi service khác:

![img.png](img.png)

3. Tạo API Gateway (PORT 8765) có tác dụng điều hướng request tới các service

    Conversion:
![img_1.png](img_1.png)

    Exchange:
![img_2.png](img_2.png)