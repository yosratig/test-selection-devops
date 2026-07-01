# Journal d'utilisation de l'IA

## Prompt 1 — README.md

**Ce que l'IA a généré :** Un README avec les commandes de démarrage, la
liste des dossiers du projet, et la procédure de sauvegarde.

**Ce que j'ai modifié :** J'ai testé chaque commande une par une pour
vérifier qu'elle fonctionnait vraiment, dans le bon ordre.

**Pourquoi :** Le README doit permettre à l'évaluateur de tout relancer
sans mon aide, donc je devais m'assurer que chaque commande était juste.

---

## Prompt 2 — Script backup.sh

**Ce que l'IA a généré :** Un script qui sauvegarde la base de données
avec `pg_dump`, archive les fichiers Odoo avec `tar`, et écrit un log
à chaque étape.

**Ce que j'ai modifié :** J'ai vérifié le vrai chemin des fichiers Odoo
dans mon conteneur (avec la commande `find`), car le chemin proposé par
défaut n'était pas garanti d'être le bon.

**Pourquoi :** Un mauvais chemin aurait rendu la sauvegarde du filestore
invalide, sans forcément donner d'erreur visible tout de suite.

---

## Prompt 3 — Restauration après crash

**Ce que l'IA a généré :** La procédure pour tout remettre en état :
recréer la base de données, restaurer le dump SQL, puis restaurer les
fichiers Odoo.

**Ce que j'ai modifié :** J'ai vérifié après chaque étape que ça avait
bien fonctionné, au lieu d'enchaîner toutes les commandes d'un coup.

**Pourquoi :** Une erreur non détectée à une étape aurait faussé toute
la suite de la restauration.

---

## Ce que j'ai appris aujourd'hui

Le processus complet de restauration après un crash : recréer la base
de données, restaurer le dump SQL dedans, puis restaurer les fichiers
Odoo. Chaque étape doit être faite dans le bon ordre, sinon la restauration
ne fonctionne pas.
