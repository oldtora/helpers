#!/bin/bash
echo "-----------------------------------------------------------------------------"
curl -s https://raw.githubusercontent.com/oldtora/helpers/main/oldtora.sh | bash
echo "-----------------------------------------------------------------------------"
echo "-----------------------------------------------------------------------------"
echo "Сетапим фаервол"
echo "-----------------------------------------------------------------------------"
sleep 1
curl -s https://raw.githubusercontent.com/oldtora/helpers/main/tools/ufw.sh | bash
echo "-----------------------------------------------------------------------------"
echo "Ставим апдейты"
echo "-----------------------------------------------------------------------------"
sleep 1
sudo apt update && sudo apt upgrade -y
echo "-----------------------------------------------------------------------------"
echo "Качаем, распаковываем и всё такое"
echo "-----------------------------------------------------------------------------"
sleep 1
wget https://github.com/peaqnetwork/peaq-network-node/releases/download/agung-apr-7-2022/peaq-node-agung-apr-7-2022.tar.gz && \
tar -xvzf peaq-node-agung-apr-7-2022.tar.gz && \
rm peaq-node-agung-apr-7-2022.tar.gz && \
chmod +x $HOME/peaq-node
echo "-----------------------------------------------------------------------------"
echo "Сетапим сервисы хуервисы"
echo "-----------------------------------------------------------------------------"
sleep 1
sudo tee /etc/systemd/system/peaq.service > /dev/null <<EOF  
[Unit]
Description=Peaq Node
After=network-online.target
[Service]
User=$USER
ExecStart=/root/peaq-node \
--chain agung
WorkingDirectory=$HOME/
Restart=on-failure
RestartSec=12
[Install]
WantedBy=multi-user.target
EOF

echo "#!/bin/sh
./peaq-node \
--base-path ./chain-data \
--chain agung \
--port 1033 \
--ws-port 9944 \
--rpc-port 9933 \
--rpc-cors all \
--pruning archive \
--name ro_full_node_0" >> start_node.sh

sudo systemctl daemon-reload && \
sudo systemctl enable peaq && \
sudo systemctl start peaq
echo "-----------------------------------------------------------------------------"
echo "Наверное готов"
echo "-----------------------------------------------------------------------------"
sleep 1
echo "-----------------------------------------------------------------------------"
echo "Проверка логов: sudo journalctl -n 100 -f -u peaq"
echo "-----------------------------------------------------------------------------"
