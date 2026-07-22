#!/bin/bash
set -e

/docker-entrypoint.sh mysqld &

echo "Esperando a que MySQL local esté listo..."
until mysqladmin ping -h localhost -uroot -proot --silent; do
    sleep 2
done

echo "Esperando a que el maestro esté disponible..."
until mysql -h mysql_principal -urepl -prepl_pass123 -e "SELECT 1" >/dev/null 2>&1; do
    sleep 2
done

echo "Configurando replicación..."
mysql -uroot -proot <<EOF
STOP REPLICA;
RESET REPLICA ALL;

CHANGE REPLICATION SOURCE TO
    SOURCE_HOST='mysql_principal',
    SOURCE_USER='repl',
    SOURCE_PASSWORD='repl_pass123',
    SOURCE_AUTO_POSITION=1;

START REPLICA;
EOF

echo "Replicación configurada."

wait