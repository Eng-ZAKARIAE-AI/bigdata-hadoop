#!/bin/bash # Indique que le script doit être exécuté avec l'interpréteur Bash.
set -e # Arrête immédiatement l'exécution du script si une commande échoue.

# Copy default configs # Commentaire indiquant une tentative de copie des configurations par défaut.
cp /opt/hadoop/etc/hadoop/* /opt/hadoop/etc/hadoop/ 2>/dev/null || true # Tente de copier les fichiers de configuration vers le même répertoire, en ignorant les erreurs éventuelles.

# Write core-site.xml # Commentaire indiquant la génération du fichier core-site.xml.
cat > /opt/hadoop/etc/hadoop/core-site.xml << 'EOF' # Écrit un nouveau contenu dans core-site.xml à partir d'un bloc de texte jusqu'au marqueur EOF.
<?xml version="1.0" encoding="UTF-8"?> # Déclare la version XML et l'encodage du fichier de configuration.
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?> # Associe une feuille de style XSL optionnelle pour l'affichage du XML.
<configuration> # Ouvre l'élément racine contenant la configuration Hadoop.
  <property> # Déclare une propriété de configuration Hadoop.
    <name>fs.defaultFS</name> # Spécifie le nom de la propriété définissant le système de fichiers par défaut.
    <value>hdfs://namenode:8020</value> # Définit l'URI du NameNode HDFS utilisé comme système de fichiers par défaut.
  </property> # Ferme la déclaration de la propriété fs.defaultFS.
</configuration> # Ferme l'élément racine de la configuration Hadoop.
EOF # Termine le bloc de texte inséré dans core-site.xml.

# Write hdfs-site.xml # Commentaire indiquant la génération du fichier hdfs-site.xml.
cat > /opt/hadoop/etc/hadoop/hdfs-site.xml << 'EOF' # Écrit un nouveau contenu dans hdfs-site.xml à partir d'un bloc de texte jusqu'au marqueur EOF.
<?xml version="1.0" encoding="UTF-8"?> # Déclare la version XML et l'encodage du fichier de configuration.
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?> # Associe une feuille de style XSL optionnelle pour l'affichage du XML.
<configuration> # Ouvre l'élément racine contenant la configuration HDFS.
  <property> # Déclare une propriété de configuration HDFS.
    <name>dfs.replication</name> # Spécifie le nom de la propriété contrôlant le facteur de réplication.
    <value>2</value> # Définit le nombre de réplicas de chaque bloc HDFS à 2.
  </property> # Ferme la déclaration de la propriété dfs.replication.
  <property> # Déclare une propriété de configuration HDFS.
    <name>dfs.blocksize</name> # Spécifie le nom de la propriété contrôlant la taille des blocs.
    <value>8388608</value> # Définit la taille des blocs HDFS à 8 mébioctets (8 * 1024 * 1024 octets).
  </property> # Ferme la déclaration de la propriété dfs.blocksize.
  <property> # Déclare une propriété de configuration HDFS.
    <name>dfs.namenode.name.dir</name> # Spécifie le répertoire de stockage des métadonnées du NameNode.
    <value>/data/hdfs/name</value> # Définit le chemin utilisé par le NameNode pour ses métadonnées.
  </property> # Ferme la déclaration de la propriété dfs.namenode.name.dir.
  <property> # Déclare une propriété de configuration HDFS.
    <name>dfs.namenode.data.dir</name> # Spécifie une propriété additionnelle de type répertoire côté NameNode.
    <value>/data/hdfs/data</value> # Définit un chemin de données associé à cette propriété dans ce script.
  </property> # Ferme la déclaration de la propriété dfs.namenode.data.dir.
  <property> # Déclare une propriété de configuration HDFS.
    <name>dfs.datanode.data.dir</name> # Spécifie le répertoire de stockage des blocs sur les DataNodes.
    <value>/data/hdfs/data</value> # Définit le chemin utilisé par les DataNodes pour stocker les blocs.
  </property> # Ferme la déclaration de la propriété dfs.datanode.data.dir.
</configuration> # Ferme l'élément racine de la configuration HDFS.
EOF # Termine le bloc de texte inséré dans hdfs-site.xml.

# Remove any .raw files that might cause issues # Commentaire indiquant la suppression des fichiers .raw potentiellement problématiques.
rm -f /opt/hadoop/etc/hadoop/*.raw 2>/dev/null || true # Supprime les fichiers .raw dans la configuration Hadoop sans échouer si aucun n'existe.

# Execute the actual Hadoop command # Commentaire indiquant le lancement de la commande Hadoop réelle.
exec /opt/hadoop/bin/hdfs "$@" # Remplace le processus courant par la commande HDFS en transmettant tous les arguments reçus.