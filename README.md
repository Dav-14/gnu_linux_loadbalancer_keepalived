# Sujet 

1. Bref rappel Linux : distributions, architecture, quelques commandes... 

2. 	a. Installation d'un VM CentOS Stream 8 ou 9 (possibilité autres distributions si préférence) 
		b. Partition standard, un disque (taille mini requis, pas besoin de plus), nommage libre. Partitionnement automatique 

3. Recommandation système: 

	> Ne pas utiliser root, se créer un compte utilisateur avec élévation 

	a. Interdire l'accès root par SSH 

	> Ne jamais désactiver le firewall ni le SELinux 

	b. Ajouter un disque secondaire 

	> 5 ou 10Go pour accueillir les données ; 

	> Ajouter niveau système, modifier la table des partitions ; point de montage /data 

4. Installer un serveur web - Frontend 

	a. Nginx (ou apache ou tomcat au choix... ne soyons pas sectaire) 

	> Configurer le serveur web pour y publier un site "fait maison" avec git

	b. Installer un backend 

	> Ajouter un backend de son choix (API Java ou autres) 

	> Installer les prérequis nécessaires 

	c. Configurer le serveur web en conséquence 

5. Installer un second serveur sous CentOS pour placer le serveur web en mode cluster de production 

	a. Réinstallation complète comme le premier ou processus de clonage 

	b. Installer le load-balancer 

	c. Installation et paramétrage keepalived 

	d. Installation et paramétrage haproxy 

6. Tester le fonctionnement de la répartition de charge. Activer les stats haproxy et contrôler 

Bonus : étudier les livraisons de versions sans coupure

# Schéma d'infrastructure

> En résumé : Ce qu'il faut faire

![Schéma d'infrastructure png](/infra.png)