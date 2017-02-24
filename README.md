# GWRAP
You will be happy when use this project for movie sites :D

## [Lấy link video streaming từ Google Drive]

### Bước 1: Đổi DNS của vps sang DNS IPv6 của google
mở file `/etc/resolv.conf` và xoá hết những gì có trong đó và sau đấy paste 2 dòng sau vào:
```
nameserver 2001:4860:4860::8888
nameserver 2001:4860:4860::8844
```

Thoát và lưu file lại.

### Bước 2: Vào file /etc/hosts thêm 2 dòng  sau
```
127.0.0.1 *.googlevideo.com
```
