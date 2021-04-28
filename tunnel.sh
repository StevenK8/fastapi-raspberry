#! /bin/bash
while : 
do
    echo "Ouverture du tunnel $(date)"
    ssh -i /root/.ssh/id_ecdsa_tunnel -R \*:8000:127.0.0.1:8000 -N -o ServerAliveInterval=5 -o ServerAliveCountMax=2 tunnel@ryzen.ddns.net -p 6622
    echo "Fermeture du tunnel $(date)"
    sleep 1
done
sudo chmod +x tunnel.sh
 
systemctl daemon-reload
 
systemctl enable sshtunnel.service
sudo ssh-keygen -t ecdsa -b 521 -f /root/.ssh/id_ecdsa_tunnel
 
sudo chmod 600 /root/.ssh/id_ecdsa_tunnel
sudo chmod 600 /root/.ssh/id_ecdsa_tunnel.pub
 
sudo ssh-copy-id -i /root/.ssh/id_ecdsa_tunnel.pub tunnel@ryzen.ddns.net -p 6622
 
sudo ssh -i /root/.ssh/id_ecdsa_tunnel -R \*8000:localhost:8000 -N tunnel@ryzen.ddns.net -p 6622
