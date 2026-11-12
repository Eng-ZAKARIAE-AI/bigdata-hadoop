# TP2 — Cluster HDFS avec Docker Compose

Ce projet met en place un petit cluster **Hadoop HDFS 3.5.0** à l'aide de **Docker Compose**, composé d'un **NameNode** et de **deux DataNodes**. Il est destiné à un travail pratique de type Big Data/Hadoop.

## Objectif

- Démarrer un cluster HDFS local minimal (1 NameNode + 2 DataNodes).
- Monter des fichiers de configuration Hadoop personnalisés.
- Persister les métadonnées et les blocs HDFS dans des répertoires locaux.
- Fournir des scripts utilitaires pour le démarrage et l'exécution des commandes HDFS.

## Structure du projet

- `Dockerfile` : construit une image personnalisée à partir de `apache/hadoop:3.5.0`, copie les fichiers de configuration et définit le point d'entrée `hdfs`.
- `docker-compose.yml` : orchestre les services `namenode`, `datanode1` et `datanode2` sur le réseau `hdfs-net`.
- `run-hdfs.sh` : script de lancement qui vérifie/copie des fichiers de configuration si nécessaire, ajuste des permissions puis exécute `hdfs`.
- `starter.sh` : script de démarrage alternatif avec pause optionnelle (`SLEEP_SECONDS`), correction de permissions et routage vers `namenode`/`datanode`.
- `hadoop-wrapper.sh` : script utilitaire alternatif qui réécrit les fichiers `core-site.xml`/`hdfs-site.xml`, supprime les éventuels fichiers `.raw` puis exécute `hdfs`.
- `config/core-site.xml` : configuration Hadoop principale (définition de `fs.defaultFS`).
- `config/hdfs-site.xml` : configuration HDFS (réplication, taille de bloc, répertoires NameNode/DataNode).
- `config/hdfs.conf.raw` : fichier résiduel/artefact présent dans le dépôt (non modifiable dans cet environnement en raison des permissions).
- `data/` : répertoires de persistance montés dans les conteneurs.
  - `data/namenode_name/` : métadonnées du NameNode (monté sur `/data/hdfs/name`).
  - `data/datanode1/` : données/blocs du premier DataNode (monté sur `/data/hdfs/data`).
  - `data/datanode2/` : données/blocs du second DataNode (monté sur `/data/hdfs/data`).
  - autres sous-dossiers (`namenode`, `namenode_data`, `datanode3`) : présents mais non utilisés par la configuration Compose actuelle.

## Configuration HDFS

### `config/core-site.xml`
- `fs.defaultFS` = `hdfs://namenode:8020`

### `config/hdfs-site.xml`
- `dfs.replication` = `2` (adapté à 2 DataNodes)
- `dfs.blocksize` = `8388608` (8 Mio)
- `dfs.namenode.name.dir` = `/data/hdfs/name`
- `dfs.datanode.data.dir` = `/data/hdfs/data`
- `dfs.namenode.data.dir` = `/data/hdfs/data` (présent dans la configuration actuelle ; propriété non standard côté NameNode)

## Services Docker Compose

- **namenode** (`tp2-namenode`)
  - Image : `tp2-hadoop:3.5.0`
  - Commande : `namenode`
  - Ports exposés : `9870` (UI web), `8020` (RPC)
  - Volumes : `./config` (lecture seule), `./data/namenode_name`

- **datanode1** (`tp2-datanode1`)
  - Image : `tp2-hadoop:3.5.0`
  - Commande : `datanode`
  - Volumes : `./config` (lecture seule), `./data/datanode1`

- **datanode2** (`tp2-datanode2`)
  - Image : `tp2-hadoop:3.5.0`
  - Commande : `datanode`
  - Volumes : `./config` (lecture seule), `./data/datanode2`

Réseau partagé : `hdfs-net`.

## Prérequis

- Docker
- Docker Compose (plugin `docker compose`)

## Utilisation

### 1. Construire l'image (si nécessaire)

```bash
docker build -t tp2-hadoop:3.5.0 .
```

### 2. Formater le NameNode (première initialisation uniquement)

À faire uniquement si le répertoire `data/namenode_name` ne contient pas encore de métadonnées valides :

```bash
docker compose run --rm namenode namenode -format
```

### 3. Démarrer le cluster

```bash
docker compose up -d
```

### 4. Vérifier l'état

```bash
docker compose ps
docker compose logs -f namenode
docker compose logs -f datanode1 datanode2
```

Interface web NameNode : [http://localhost:9870](http://localhost:9870)

### 5. Exécuter une commande HDFS

Exemple pour lister la racine HDFS :

```bash
docker compose exec namenode hdfs dfs -ls /
```

### 6. Arrêter le cluster

```bash
docker compose down
```

## Remarques et points d'attention

- Le montage `./config:/opt/hadoop/etc/hadoop:ro` dans `docker-compose.yml` **remplace** les fichiers de configuration copiés dans l'image par le `Dockerfile` au moment de l'exécution.
- Les scripts `run-hdfs.sh`, `starter.sh` et `hadoop-wrapper.sh` ne sont pas référencés par le `Dockerfile` ni par `docker-compose.yml` dans l'état actuel ; ils constituent des variantes/outils potentiels.
- Des répertoires de données existants peuvent contenir des métadonnées d'exécutions précédentes ; en cas de réinitialisation, manipuler `data/` avec précaution.
- Le fichier `config/hdfs.conf.raw` n'a pas pu être commenté automatiquement dans cet environnement (permissions insuffisantes).
- La propriété `dfs.namenode.data.dir` dans `hdfs-site.xml` est non standard pour le NameNode HDFS et mérite vérification selon vos besoins pédagogiques.

## Fichiers commentés

Des commentaires en français ont été ajoutés ligne par ligne dans les fichiers suivants :
- `Dockerfile`
- `docker-compose.yml`
- `run-hdfs.sh`
- `starter.sh`
- `hadoop-wrapper.sh`
- `config/core-site.xml`
- `config/hdfs-site.xml`
