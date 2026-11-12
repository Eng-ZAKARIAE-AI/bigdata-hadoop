#!/bin/bash # Indique que le script doit être exécuté avec l'interpréteur Bash.
set -e # Arrête immédiatement l'exécution du script si une commande échoue.

if [ -n "$SLEEP_SECONDS" ]; then # Vérifie si la variable d'environnement SLEEP_SECONDS est définie et non vide.
   echo "Sleeping for $SLEEP_SECONDS seconds" # Affiche un message indiquant la durée de la pause avant le démarrage.
   sleep $SLEEP_SECONDS # Met en pause l'exécution du script pendant le nombre de secondes demandé.
fi # Termine le bloc conditionnel lié à la temporisation de démarrage.

# Fix data directory ownership # Commentaire indiquant la correction éventuelle des droits sur le répertoire de données.
if [ -d /data/hdfs ] && [ "$(id -u)" = "1001" ]; then # Vérifie que /data/hdfs existe et que l'utilisateur courant a l'identifiant 1001.
  chown -R hadoop:hadoop /data/hdfs 2>/dev/null || true # Tente de rendre l'utilisateur hadoop propriétaire du répertoire HDFS, en ignorant les erreurs.
fi # Termine le bloc conditionnel de correction des permissions.

# Execute the command # Commentaire indiquant le lancement de la commande demandée.
CMD="$1" # Récupère le premier argument du script comme commande à exécuter.
shift # Retire le premier argument pour conserver uniquement les arguments restants.
case "$CMD" in # Démarre une structure conditionnelle selon la commande demandée.
  namenode) exec /opt/hadoop/bin/hdfs namenode "$@" ;; # Si la commande est namenode, lance le processus NameNode HDFS avec les arguments restants.
  datanode) exec /opt/hadoop/bin/hdfs datanode "$@" ;; # Si la commande est datanode, lance le processus DataNode HDFS avec les arguments restants.
  *) exec "$CMD" "$@" ;; # Pour toute autre commande, exécute directement la commande fournie avec ses arguments.
esac # Termine la structure conditionnelle de sélection de commande.