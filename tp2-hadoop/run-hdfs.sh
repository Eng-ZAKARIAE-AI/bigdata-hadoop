#!/bin/bash # Indique que le script doit être exécuté avec l'interpréteur Bash.
set -e # Arrête immédiatement l'exécution du script si une commande échoue.

# Ensure config files exist # Commentaire d'origine indiquant la vérification de l'existence des fichiers de configuration.
if [ ! -f /opt/hadoop/etc/hadoop/core-site.xml ]; then # Vérifie si le fichier core-site.xml est absent du répertoire de configuration Hadoop.
    cp /opt/hadoop/etc/hadoop/core-site-original.xml /opt/hadoop/etc/hadoop/core-site.xml 2>/dev/null || true # Copie le fichier core-site.xml d'origine si disponible, en ignorant les erreurs.
fi # Termine le bloc conditionnel de vérification de core-site.xml.
if [ ! -f /opt/hadoop/etc/hadoop/hdfs-site.xml ]; then # Vérifie si le fichier hdfs-site.xml est absent du répertoire de configuration Hadoop.
    cp /opt/hadoop/etc/hadoop/hdfs-site-original.xml /opt/hadoop/etc/hadoop/hdfs-site.xml 2>/dev/null || true # Copie le fichier hdfs-site.xml d'origine si disponible, en ignorant les erreurs.
fi # Termine le bloc conditionnel de vérification de hdfs-site.xml.

# Fix ownership of data directories if needed # Commentaire d'origine indiquant la correction éventuelle des droits sur les répertoires de données.
if [ -d /data/hdfs/name ] && [ ! -w /data/hdfs/name ]; then # Vérifie que le répertoire des métadonnées NameNode existe mais n'est pas accessible en écriture.
    chown -R hadoop:hadoop /data/hdfs 2>/dev/null || true # Tente de rendre l'utilisateur hadoop propriétaire des données HDFS, en ignorant les erreurs.
fi # Termine le bloc conditionnel de correction des permissions.

# Execute the actual Hadoop command # Commentaire d'origine indiquant le lancement de la commande Hadoop réelle.
exec /opt/hadoop/bin/hdfs "$@" # Remplace le processus courant par la commande HDFS en transmettant tous les arguments reçus.