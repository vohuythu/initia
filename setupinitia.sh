#!/bin/bash

# Cập nhật và cài đặt các gói cần thiết
sudo apt update && sudo apt install -y build-essential curl git jq unzip wget lz4

# Cài đặt Golang phiên bản 1.22.0
GO_VERSION="1.22.0"
cd $HOME
wget "https://golang.org/dl/go${GO_VERSION}.linux-amd64.tar.gz"
sudo rm -rf /thu/local/go
sudo tar -C /thu/local -xzf "go${GO_VERSION}.linux-amd64.tar.gz"
rm "go${GO_VERSION}.linux-amd64.tar.gz"
echo "export PATH=\$PATH:/thu/local/go/bin:\$HOME/go/bin" >> ~/.bash_profile
source ~/.bash_profile
go version  # Kiểm tra phiên bản Go đã cài đặt

# Tải và xây dựng mã nguồn Initia
git clone https://github.com/initia-labs/initia.git
cd initia
git checkout v0.2.12  # Thay đổi thành phiên bản mong muốn
make install

# Kiểm tra phiên bản initiad
initiad version

# Thiết lập cấu hình node
MONIKER="VOHUYTHU"  # Thay đổi thành tên node mong muốn
CHAIN_ID="initiation-2"
initiad init $MONIKER --chain-id $CHAIN_ID

# Tải tệp genesis.json
wget https://initia.s3.ap-southeast-1.amazonaws.com/${CHAIN_ID}/genesis.json -O $HOME/.initia/config/genesis.json

# Cấu hình seeds và peers
SEEDS="2eaa272622d1ba6796100ab39f58c75d458b9dbc@34.142.181.82:26656,c28827cb96c14c905b127b92065a3fb4cd77d7f6@testnet-seeds.whispernode.com:25756"
PEERS="40d3f977d97d3c02bd5835070cc139f289e774da@168.119.10.134:26313,841c6a4b2a3d5d59bb116cc549565c8a16b7fae1@23.88.49.233:26656"
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/" $HOME/.initia/config/config.toml
sed -i -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.initia/config/config.toml

# Thiết lập giá gas tối thiểu
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.15uinit,0.01uusdc\"/" $HOME/.initia/config/app.toml

# Thiết lập khởi động lại node khi máy khởi động
echo "#!/bin/bash" > $HOME/start_initia.sh
echo "export PATH=\$PATH:/thu/local/go/bin:\$HOME/go/bin" >> $HOME/start_initia.sh
echo "initiad start" >> $HOME/start_initia.sh
chmod +x $HOME/start_initia.sh

