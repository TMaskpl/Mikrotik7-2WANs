# Project 1
Load balancing 2WANs



![2022-01-15_07-57](https://user-images.githubusercontent.com/75216446/149612683-20994a83-6436-4099-a642-6f5b88041af6.png)


# Project 2

![obraz-8](https://user-images.githubusercontent.com/75216446/165448404-dedcd3b2-7fd6-40e2-9f33-8f44758c8bc8.png)


- set route on 2 WAN
- check IP on Internet

0   s 0.0.0.0/0       10.30.1.1         2

1  As 0.0.0.0/0       10.20.1.1         1

2  As 8.8.4.4/32      10.30.1.1         1

3  As 8.8.8.8/32      10.20.1.1         1

![obraz](https://user-images.githubusercontent.com/75216446/165448765-6017a0cc-e1a2-41f6-b516-4adf5fc99e83.png)

- set VRRP
- set priority (higher master)
- set this same ip on vrrp interface
- set DHCP Server on vrrp interface
- set netwatch on 8.8.8.8 / 8.8.4.4
