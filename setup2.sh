#!/bin/bash

# Cập nhật hệ thống và cài đặt các gói cần thiết
sudo apt update && sudo apt upgrade -y
sudo apt install -y build-essential curl git jq 

# Cài đặt Golang (phiên bản 1.22 hoặc mới hơn)
GO_VERSION="1.22.0"
wget https://go.dev/dl/go$GO_VERSION.linux-amd64.tar.gz
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go$GO_VERSION.linux-amd64.tar.gz
rm go$GO_VERSION.linux-amd64.tar.gz

# Thiết lập biến môi trường cho Go
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
source ~/.bashrc

go version  # Kiểm tra phiên bản Go

# Clone repository chính thức của Initia
git clone https://github.com/Initia/initia.git
cd initia
make install

# Kiểm tra phiên bản Initia
initiad version

# Khởi tạo node Initia
initiad start

# Tạo tập tin startinitia để khởi động lại node sau khi tắt máy
echo "#!/bin/bash" > ~/startinitia.sh
echo "initiad start" >> ~/startinitia.sh
chmod +x ~/startinitia.sh
