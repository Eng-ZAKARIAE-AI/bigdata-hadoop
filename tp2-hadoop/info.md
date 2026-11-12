# 1. Créer le répertoire HDFS
docker compose exec namenode hdfs dfs -mkdir -p /tp2/data

# 2. Créer le fichier local
echo "Bonjour HDFS depuis Docker Compose" > local.txt

# 3. Copier le fichier dans le conteneur namenode
docker cp local.txt tp2-namenode:/tmp/local.txt

# 4. Déposer le fichier dans HDFS depuis le conteneur
docker compose exec namenode hdfs dfs -put /tmp/local.txt /tp2/data/

# 5. Vérifier avec fsck
docker compose exec namenode hdfs fsck /tp2/data/local.txt -files -blocks
