# Timelapse

## FastAPI

1. Installation de dépendances:
```bash
sudo apt install python3-pip python3-picamera; python3 -m pip install --upgrade pip bcrypt
```

2. Installation de rust:
```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

rustup install nightly

rustup default nightly
```

3. Installation de FastAPI:
```bash
python3 -m pip install fastapi uvicorn
```

4. Ajout de uvicorn à la variable $PATH:
```bash
export PATH=/usr/local/bin:/usr/local/sbin:/home/pi/.local/bin:$PATH
```

5. Démarrage du serveur web:
```bash
cd Timelapse/app

uvicorn main:app --reload --host 192.168.1.21
```


6. Accès à la doc:
```bash
http://192.168.1.21:8000/docs
```

## Rclone

```bash
curl https://rclone.org/install.sh | sudo bash
```

```bash
*/5 * * * * rclone move /home/pi/camera/ timelapse:/home/timelapse/photos --delete-empty-src-dirs &
```

```bash
pip3 install pymysql
```


## Documentation de FastAPI

[FastAPI](https://fastapi.tiangolo.com/)

## Capteur DHT

### Dépendances

```bash
sudo apt install python-mysqldb
```

### Crontab

```bash
*/5 * * * * python3 /home/pi/Timelapse/logger-temp-hum.py &> /dev/null
```

## Services

sudo nano /etc/systemd/system/fastapi.service
```bash
[Unit]
Description=Fastapi server      

[Install]
WantedBy=multi-user.target

[Service]
After=network.target
ExecStart=/home/pi/.local/bin/uvicorn main:app --reload --host 0.0.0.0
Type=simple
User=pi   
Group=pi   
WorkingDirectory=/home/pi/Timelapse/app
Restart=on-failure
```

```bash
systemctl daemon-reload

systemctl enable fastapi.service
```

sudo nano /etc/systemd/system/sshtunnel.service

```bash
[Unit]
Description=SSH tunnel for fastapi

[Install]
WantedBy=multi-user.target

[Service]
ExecStart=screen -dmS tunnel /root/tunnel.sh
After=network.target
Type=forking
User=root
Group=root
WorkingDirectory=/root
Restart=on-failure
```

tunnel.sh:
```bash
#! /bin/bash
while : 
do
    echo "Ouverture du tunnel $(date)"
    ssh -i /root/.ssh/id_ecdsa_tunnel -R \*:8000:127.0.0.1:8000 -N -o ServerAliveInterval=5 -o ServerAliveCountMax=2 tunnel@ryzen.ddns.net -p 6622
    echo "Fermeture du tunnel $(date)"
    sleep 1
done
```

```bash
sudo chmod +x tunnel.sh

systemctl daemon-reload

systemctl enable sshtunnel.service
```

```bash
sudo ssh-keygen -t ecdsa -b 521 -f /root/.ssh/id_ecdsa_tunnel

sudo chmod 600 /root/.ssh/id_ecdsa_tunnel
sudo chmod 600 /root/.ssh/id_ecdsa_tunnel.pub

sudo ssh-copy-id -i /root/.ssh/id_ecdsa_tunnel.pub tunnel@ryzen.ddns.net -p 6622

sudo ssh -i /root/.ssh/id_ecdsa_tunnel -R \*8000:localhost:8000 -N tunnel@ryzen.ddns.net -p 6622
```

/etc/ssh/sshd_config
```bash
Match User tunnel
  AllowTcpForwarding yes
  PermitOpen *:8000
  X11Forwarding no
  AllowAgentForwarding no
  GatewayPorts yes
```

https://www.linuxtricks.fr/wiki/ssh-creer-un-tunnel-pour-rediriger-des-ports-d-une-machine-a-l-autre

https://www.it-react.com/index.php/2020/01/06/how-to-setup-reverse-ssh-tunnel-on-linux/
