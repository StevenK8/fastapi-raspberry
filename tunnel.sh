#! /bin/bash
while : 
do
    echo "Ouverture du tunnel $(date)"
    ssh -i /root/.ssh/id_ecdsa_tunnel -R \*:8000:127.0.0.1:8000 -N -o ServerAliveInterval=5 -o ServerAliveCountMax=2 tunnel@ryzen.ddns.net -p 6622
    echo "Fermeture du tunnel $(date)"
    sleep 1
done

