FROM apache/hadoop:3.5.0 # Utilise l'image officielle Apache Hadoop 3.5.0 comme base du conteneur.

# Copy our config files over the defaults # Commentaire indiquant la copie des fichiers de configuration personnalisés.
COPY config/core-site.xml /opt/hadoop/etc/hadoop/core-site.xml # Copie la configuration core-site.xml locale dans l'image Hadoop.
COPY config/hdfs-site.xml /opt/hadoop/etc/hadoop/hdfs-site.xml # Copie la configuration hdfs-site.xml locale dans l'image Hadoop.

# Override entrypoint to bypass broken envtoconf.py # Commentaire indiquant la surcharge du point d'entrée par défaut.
ENTRYPOINT ["/opt/hadoop/bin/hdfs"] # Définit la commande hdfs comme point d'entrée du conteneur.