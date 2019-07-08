## CentOS/RedHat 一键替换YUM源为阿里云YUM源脚本  

支持RedHat系 5、6、7，root执行以下命令即可。  
  
``` shell
 wget -N --no-check-certificate https://raw.githubusercontent.com/AlliotTech/yum2aliyun/master/yum2aliyun.sh && chmod +x yum2aliyun.sh && ./yum2aliyun.sh 2>&1 | tee yum2aliyun.log  
```