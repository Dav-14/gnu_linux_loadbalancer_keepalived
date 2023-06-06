# Nom de ton projet

Ce projet utilise Terraform et Ansible pour automatiser le déploiement d'une infrastructure basée sur les providers libvirt et ansible. Il se base également sur le gestionnaire de paquets aptitude.

## Prérequis

Avant de commencer, assurez-vous d'avoir les éléments suivants :

- Une clé SSH nommée `id_gnu_linux` située dans le répertoire `~/.ssh/`. Cette clé sera utilisée pour accéder aux machines virtuelles provisionnées par le projet.

    - Genérer la clé avec `ssh-keygen -t <algo> -b <longeur> <path>`
    ex: `ssh-keygen -t rsa -b 4096 ~/.ssh/id_gnu_linux` 

- L'installation de libvirt sur votre système. Vous pouvez installer libvirt en utilisant les commandes spécifiques à votre distribution Linux. Libvirt depend de l'hyperviseur qemu/kvm


    Pour Ubuntu, vous pouvez exécuter la commande suivante :
        - https://ubuntu.com/server/docs/virtualization-libvirt

    Pour debian:
        - https://debian-facile.org/atelier:chantier:virtualisation-avec-libvirt

- Docker


## Utilisation du projet avec Devcontainer

Ce projet est configuré pour être utilisé avec Devcontainer, qui fournit un environnement de développement cohérent et reproductible. Pour utiliser Devcontainer, suivez les étapes ci-dessous :

1. Installez Docker sur votre système.

2. Installez l'extension Devcontainer pour votre éditeur de code préféré (par exemple, Visual Studio Code).

3. Ouvrez le projet dans votre éditeur de code.

4. Lorsque vous êtes invité à recharger le projet avec Devcontainer, acceptez et laissez Devcontainer construire l'environnement de développement.

5. Une fois que Devcontainer a terminé la construction, vous pouvez commencer à utiliser le projet avec tous les outils et dépendances préconfigurés.

N'oubliez pas de consulter la documentation du projet pour plus d'informations sur les commandes et les configurations spécifiques.

