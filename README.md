# Projet backend

Nom et prenom: PHAM Xuan Phuc

Backend pour un forum de discussion (resseau sociaux), construit avec **Express**, **Sequelize** et **PostgreSQL**, conteneurisé avec **Docker** (Il faut lancer des containers).

## Stack technique

- **Runtime** : Node.js 20 (Alpine)
- **Framework** : Express 5
- **ORM** : Sequelize 6
- **Base de données** : PostgreSQL 15
- **Conteneurisation** : Docker Compose (backend + postgres + pgadmin)

## Prequisite

Vous devez avoir docker installé sur votre Linux (ou MAC). 
J'utilise Debian donc je suit [cette instruction](https://docs.docker.com/engine/install/debian/).
Cependant si vous utilisez MacOS il faut aller [ici](https://docs.docker.com/desktop/setup/install/mac-install/) (je crois). C'est un peu compliqué je ne sais pas comment installer. Si non vous pouvez utiliser un Debian VM ? 


## Lancement

**Build les images. Lancement des containers.**

Lancer le script en tant sudo. Si vous ne voulez pas vous pouvez donner le droit pour executer docker en tant que user.

```bash
sudo docker compose up
```
N'oublie pas à clear le processus utilisant les portes demandé 5432 (postgres), 3030 (backend), 5050 (pgadmin).

Je fais un migration ( unmigrate tout d'abord), j'ai mis dans un script. Vous pouvez le faire pendant le testing aussi. 
```bash
sudo bash start.sh
```

Le serveur backend est accessible sur `http://localhost:3000`. En faite c'est dans le container et je expose le port pour tourner dans localhost.

Down:
```bash
sudo docker compose down
```

---

## Testing

Voir `test.md`

---

## Base de données relationnelle

Regarde `backend/db/models` `backend/db/migraions`, ou `schema_dump.sql` que j'ai dumpé directement de Postgres

### Relations

| Relation | Type | Description |
|----------|------|-------------|
| User - Role | N:N | Via table `UserRoles` (u_id, r_id) |
| Role - Permission | N:N | Via table `RolePermissions` (r_id, p_id) |
| User - Discussion | 1:N | `owner_id` dans Discussions |
| User - Comment | 1:N | `user_id` dans Comments |
| Discussion - Comment | 1:N | `discussion_id` dans Comments |
| User - ReactionDiscussion | 1:N | Un user peut réagir à plusieurs discussions |
| User - ReactionComment | 1:N | Un user peut réagir à plusieurs commentaires |
| Discussion - ReactionDiscussion | 1:N | Une discussion peut avoir plusieurs réactions |
| Comment - ReactionComment | 1:N | Un commentaire peut avoir plusieurs réactions |
| User - Session | 1:N | Un user peut avoir plusieurs sessions actives |


---

## RBAC - Controle d'acces base sur les roles

Vous pouvez regardé dans seeder avec les données initiaux

### Roles et permissions

| Permission | Admin | Moderator | User | Guest | Banned |
|------------|:-----:|:---------:|:----:|:-----:|:------:|
| `discussion.create` | x | x | x | | |
| `discussion.read.any` | x | x | x | x | |
| `discussion.read.own` | x | x | x | | |
| `discussion.edit.own` | x | x | x | | |
| `discussion.edit.any` | x | x | | | |
| `discussion.delete.own` | x | x | x | | |
| `discussion.delete.any` | x | x | | | |
| `comment.create` | x | x | x | | |
| `comment.read.any` | x | x | x | | |
| `comment.read.own` | x | x | x | | |
| `comment.edit.own` | x | x | x | | |
| `comment.edit.any` | x | x | | | |
| `comment.delete.own` | x | x | x | | |
| `comment.delete.any` | x | x | | | |
| `reaction.create` | x | x | x | | |
| `reaction.delete.own` | x | x | x | | |
| `user.create` | x | | | | |
| `user.read.any` | x | x | x | | |
| `user.read.own` | x | x | x | | |
| `user.edit.own` | x | x | x | | |
| `user.edit.any` | x | | | | |
| `user.delete.own` | x | | x | | |
| `user.delete.any` | x | | | | |
| `user.ban.any` | x | x | | | |

---

## Endpoints de l'API

Base URL : `http://localhost:3000`

Vous pouvez tester dans `test.md`

### Authentification (`/auth`)

| Methode | Route | Auth | Body | Description |
|---------|-------|:----:|------|-------------|
| `POST` | `/auth/register` | Non | `username, password, fname, lname` | Inscription |
| `POST` | `/auth/login` | Non | `username, password` | Connexion (retourne un JWT) |
| `POST` | `/auth/logout` | Oui | - | Deconnexion (invalide la session) |
| `GET` | `/auth/me` | Oui | - | Info utilisateur connecte |

### Discussions (`/discussions`)

| Methode | Route | Auth | Body | Description |
|---------|-------|:----:|------|-------------|
| `GET` | `/discussions` | Non | - | Lister (pagination: `?page=&limit=`) |
| `GET` | `/discussions/:id` | Non | - | Detail avec commentaires et reactions |
| `POST` | `/discussions` | Oui | `title, content` | Creer |
| `PATCH` | `/discussions/:id` | Oui | `title` et/ou `content` | Modifier (own/any) |
| `DELETE` | `/discussions/:id` | Oui | - | Supprimer (own/any) |

### Reactions sur discussions (`/discussions/:id/reactions`)

| Methode | Route | Auth | Body | Description |
|---------|-------|:----:|------|-------------|
| `POST` | `/discussions/:id/reactions` | Oui | `type` | Ajouter/modifier (upsert) |
| `DELETE` | `/discussions/:id/reactions` | Oui | - | Retirer sa reaction |

### Commentaires (`/discussions/:id/comments`)

| Methode | Route | Auth | Body | Description |
|---------|-------|:----:|------|-------------|
| `GET` | `/discussions/:id/comments` | Non | - | Lister (pagination) |
| `POST` | `/discussions/:id/comments` | Oui | `content` | Creer |
| `PATCH` | `/discussions/:id/comments/:commentId` | Oui | `content` | Modifier (own/any) |
| `DELETE` | `/discussions/:id/comments/:commentId` | Oui | - | Supprimer (own/any) |

### Reactions sur commentaires

| Methode | Route | Auth | Body | Description |
|---------|-------|:----:|------|-------------|
| `POST` | `/discussions/:id/comments/:commentId/reactions` | Oui | `type` | Ajouter/modifier |
| `DELETE` | `/discussions/:id/comments/:commentId/reactions` | Oui | - | Retirer |

### Utilisateurs (`/users`)

| Methode | Route | Auth | Body | Description |
|---------|-------|:----:|------|-------------|
| `GET` | `/users` | Oui | - | Lister (pagination) |
| `GET` | `/users/me` | Oui | - | Mon profil |
| `GET` | `/users/:id` | Oui | - | Profil par ID |
| `PATCH` | `/users/:id` | Oui | `fname` et/ou `lname` | Modifier (own/any) |
| `DELETE` | `/users/:id` | Oui | - | Supprimer (own/any) |
| `POST` | `/users/:id/ban` | Oui | - | Bannir (mod/admin) |
| `POST` | `/users/:id/unban` | Oui | - | Debannir (mod/admin) |

### Sante

| Methode | Route | Auth | Description |
|---------|-------|:----:|-------------|
| `GET` | `/health` | Non | Check de sante du serveur |



## Securite

### Couches de securite implementees

- Je suis recommendé par Chat d'utiliser `helmet` pour le header. 
- CORS pour permettre que l'origine au frontend `localhost:5173`. *J'ai pas du temps pour dev le front end mais je le mettre quand même*. 
- Je suis recommendé par Chat d'utiliser `express-rate-limit` pour contrer le brutforce
- Hachage mdp
- RBAC implémenté
- Authentification par JWT + session token persistee en base (table `Sessions`). Le token est stocke dans un cookie `session_token` ou passe via header `Authorization: Bearer`
- XSS et validation des entrés

---

## Comptes de test

Voir le data initiaux dans `backend/db/seeders/20260216214154-initial-data.js`

| Username | Password | Role |
|----------|----------|------|
| admin_alice | admin123 | Admin |
| mod_bob | mod123 | Moderator |
| user_charlie | user123 | User |
| user_diana | user123 | User |
| banned_eve | banned123 | Banned |
