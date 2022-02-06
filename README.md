**Membuat simple web server dengan Linux (CentOS / Ubuntu) dengan 2 server dan 1 load balancer di AWS/GCP**

VPC:

    VPC Subnet: 10.10.10.0/23
    Public Subnet: 10.10.10.0/28
    Private Subnet: 10.10.10.16/28

Webserver:

    OS: Ubuntu 20.03
    Platform aplikasi: Docker
    Jumlah: 2
    IP: 10.10.10.20/28 & 10.10.10.30/28

Load Balancer:

    OS: Ubuntu 20.03
    Load Balancer: HAProxy
    Jumlah 1
    Subnet: Publik
    IP: 10.10.10.10/28
