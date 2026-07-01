# Runbook — Restauration après crash

## Contexte
Cette procédure permet de restaurer la stack Odoo (base de données + filestore)
depuis une archive de backup, après une perte totale des conteneurs et volumes Docker.

## Prérequis
- Une archive de backup présente dans `/backup/backup_YYYYMMDD_HHMMSS.tar.gz`
- Docker et Docker Compose installés
- Le fichier `docker-compose.yml` du projet, dans le dossier `apps/`

## Étapes de restauration

### 1. Extraire l'archive de backup
```bash
mkdir -p /backup/restore-temp
tar -xzf /backup/backup_YYYYMMDD_HHMMSS.tar.gz -C /backup/restore-temp
```
Cela génère deux fichiers : `db_YYYYMMDD_HHMMSS.sql` et `filestore_YYYYMMDD_HHMMSS.tar.gz`.

### 2. Démarrer la stack (conteneurs vides)
```bash
cd apps
docker compose up -d
```

### 3. Créer la base de données PostgreSQL
```bash
docker exec -it apps-db-1 createdb -U odoo odoo
```

### 4. Restaurer le dump SQL
```bash
cat /backup/restore-temp/db_YYYYMMDD_HHMMSS.sql | docker exec -i apps-db-1 psql -U odoo -d odoo
```

### 5. Restaurer le filestore
```bash
docker cp /backup/restore-temp/filestore_YYYYMMDD_HHMMSS.tar.gz apps-odoo-1:/tmp/filestore.tar.gz
docker exec -it apps-odoo-1 sh -c "cd / && tar -xzf /tmp/filestore.tar.gz"
docker exec -it apps-odoo-1 rm /tmp/filestore.tar.gz
```

### 6. Vérification
- Aller sur `http://erp.local`
- Se connecter à Odoo
- Vérifier que le module Sales est installé et que les données (clients, produits, devis) sont présentes

## Nettoyage
```bash
rm -rf /backup/restore-temp
```

## Notes
- Le nom des conteneurs (`apps-db-1`, `apps-odoo-1`) peut varier selon la machine :
  vérifier avec `docker compose ps` avant de lancer les commandes.
- Ne jamais restaurer un dump sur une base contenant déjà des données de production
  sans confirmation préalable.
