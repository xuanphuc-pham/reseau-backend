# RESEED

Si on est dans Docker, il faut reset le data dans le bdd.

```bash
sudo docker compose exec backend npx sequelize-cli db:seed:undo:all
sudo docker compose exec backend npx sequelize-cli db:seed:all
```
---

# Testing 

## Santé du serveur

```bash
curl -s http://localhost:3000/health | jq
```

---

## Routes d'authentification

Inscription d'un nouvel utilisateur :

```bash
curl -s -X POST http://localhost:3000/auth/register \
  -H "Content-Type: application/json" \
  -d '{"username":"testuser","password":"test123","fname":"Test","lname":"User"}' | jq
```

Connexion en tant qu'admin (on sauvegarde le token) :

```bash
ADMIN_TOKEN=$(curl -s -X POST http://localhost:3000/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin_alice","password":"admin123"}' | jq -r '.data.token')
echo "ADMIN_TOKEN=$ADMIN_TOKEN"
```

Connexion en tant qu'utilisateur classique (on sauvegarde le token) :

```bash
USER_TOKEN=$(curl -s -X POST http://localhost:3000/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"user_charlie","password":"user123"}' | jq -r '.data.token')
echo "USER_TOKEN=$USER_TOKEN"
```

Connexion en tant que modérateur (on sauvegarde le token) :

```bash
MOD_TOKEN=$(curl -s -X POST http://localhost:3000/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"mod_bob","password":"mod123"}' | jq -r '.data.token')
echo "MOD_TOKEN=$MOD_TOKEN"
```

Connexion en tant qu'utilisateur banni (la connexion marche mais les requêtes seront bloquées) :

```bash
BANNED_TOKEN=$(curl -s -X POST http://localhost:3000/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"banned_eve","password":"banned123"}' | jq -r '.data.token')
echo "BANNED_TOKEN=$BANNED_TOKEN"
```

Récupérer les infos de l'utilisateur connecté :

```bash
curl -s http://localhost:3000/auth/me \
  -H "Authorization: Bearer $ADMIN_TOKEN" | jq
```

Vérifier qu'un utilisateur banni est bien bloqué :

```bash
curl -s http://localhost:3000/auth/me \
  -H "Authorization: Bearer $BANNED_TOKEN" | jq
```

Accès sans authentification (doit échouer) :

```bash
curl -s http://localhost:3000/auth/me | jq
```

### Validation et cas limites (à lancer tôt pour éviter le rate limiter)

Inscription avec un nom d'utilisateur trop court (doit échouer 400) :

```bash
curl -s -X POST http://localhost:3000/auth/register \
  -H "Content-Type: application/json" \
  -d '{"username":"ab","password":"test123","fname":"X","lname":"Y"}' | jq
```

Inscription avec des caractères invalides dans le nom d'utilisateur (doit échouer 400) :

```bash
curl -s -X POST http://localhost:3000/auth/register \
  -H "Content-Type: application/json" \
  -d '{"username":"bad user!","password":"test123","fname":"X","lname":"Y"}' | jq
```

Inscription avec un nom d'utilisateur déjà pris (doit échouer 409) :

```bash
curl -s -X POST http://localhost:3000/auth/register \
  -H "Content-Type: application/json" \
  -d '{"username":"admin_alice","password":"test123","fname":"X","lname":"Y"}' | jq
```

---

## Routes des discussions

Lister toutes les discussions (public, pas besoin d'être connecté) :

```bash
curl -s "http://localhost:3000/discussions" | jq
```

Liste avec pagination :

```bash
curl -s "http://localhost:3000/discussions?page=1&limit=2" | jq
```

Récupérer une discussion par son ID (avec commentaires et réactions) :

```bash
curl -s http://localhost:3000/discussions/1 | jq
```

Récupérer une discussion qui n'existe pas :

```bash
curl -s http://localhost:3000/discussions/999 | jq
```

Créer une discussion (en tant qu'utilisateur classique) :

```bash
curl -s -X POST http://localhost:3000/discussions \
  -H "Authorization: Bearer $USER_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"title":"Ma nouvelle discussion","content":"Voici le contenu de ma discussion"}' | jq
```

Créer une discussion sans être connecté (doit échouer 401) :

```bash
curl -s -X POST http://localhost:3000/discussions \
  -H "Content-Type: application/json" \
  -d '{"title":"Doit échouer","content":"Pas de token"}' | jq
```

Créer une discussion avec des champs manquants (doit échouer 400) :

```bash
curl -s -X POST http://localhost:3000/discussions \
  -H "Authorization: Bearer $USER_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"title":""}' | jq
```

Modifier sa propre discussion (user_charlie est propriétaire de la discussion 2) :

```bash
curl -s -X PATCH http://localhost:3000/discussions/2 \
  -H "Authorization: Bearer $USER_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"title":"Titre modifié par le propriétaire"}' | jq
```

Modifier la discussion de quelqu'un d'autre en tant qu'utilisateur classique (doit échouer 403) :

```bash
curl -s -X PATCH http://localhost:3000/discussions/1 \
  -H "Authorization: Bearer $USER_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"title":"Tentative de modifier le post admin"}' | jq
```

Modifier n'importe quelle discussion en tant qu'admin (doit fonctionner) :

```bash
curl -s -X PATCH http://localhost:3000/discussions/2 \
  -H "Authorization: Bearer $ADMIN_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"title":"Modifié par admin"}' | jq
```

Supprimer la discussion de quelqu'un d'autre en tant qu'utilisateur classique (doit échouer 403) :

```bash
curl -s -X DELETE http://localhost:3000/discussions/1 \
  -H "Authorization: Bearer $USER_TOKEN" | jq
```

---

## Routes des commentaires

Lister les commentaires de la discussion 1 :

```bash
curl -s "http://localhost:3000/discussions/1/comments" | jq
```

Liste des commentaires avec pagination :

```bash
curl -s "http://localhost:3000/discussions/1/comments?page=1&limit=2" | jq
```

Lister les commentaires d'une discussion qui n'existe pas :

```bash
curl -s "http://localhost:3000/discussions/999/comments" | jq
```

Créer un commentaire sur la discussion 1 :

```bash
curl -s -X POST http://localhost:3000/discussions/1/comments \
  -H "Authorization: Bearer $USER_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"content":"Voici mon nouveau commentaire !"}' | jq
```

Créer un commentaire sans être connecté (doit échouer 401) :

```bash
curl -s -X POST http://localhost:3000/discussions/1/comments \
  -H "Content-Type: application/json" \
  -d '{"content":"Commentaire sans auth"}' | jq
```

Créer un commentaire avec un contenu vide (doit échouer 400) :

```bash
curl -s -X POST http://localhost:3000/discussions/1/comments \
  -H "Authorization: Bearer $USER_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"content":""}' | jq
```

Modifier son propre commentaire (user_charlie est propriétaire du commentaire 1) :

```bash
curl -s -X PATCH http://localhost:3000/discussions/1/comments/1 \
  -H "Authorization: Bearer $USER_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"content":"Mon commentaire modifié"}' | jq
```

Modifier le commentaire de quelqu'un d'autre en tant qu'utilisateur classique (doit échouer 403) :

```bash
curl -s -X PATCH http://localhost:3000/discussions/1/comments/2 \
  -H "Authorization: Bearer $USER_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"content":"Tentative de modifier le commentaire de diana"}' | jq
```

Modifier n'importe quel commentaire en tant que modérateur (doit fonctionner) :

```bash
curl -s -X PATCH http://localhost:3000/discussions/1/comments/2 \
  -H "Authorization: Bearer $MOD_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"content":"Commentaire modifié par le modérateur"}' | jq
```

Supprimer le commentaire de quelqu'un d'autre en tant qu'utilisateur classique (doit échouer 403) :

```bash
curl -s -X DELETE http://localhost:3000/discussions/1/comments/2 \
  -H "Authorization: Bearer $USER_TOKEN" | jq
```

Supprimer n'importe quel commentaire en tant qu'admin (doit fonctionner) :

```bash
curl -s -X DELETE http://localhost:3000/discussions/1/comments/3 \
  -H "Authorization: Bearer $ADMIN_TOKEN" | jq
```

---

## Routes des réactions sur les discussions

Ajouter une réaction à la discussion 1 (mod_bob n'a pas de réaction seedée sur la discussion 1) :

```bash
curl -s -X POST http://localhost:3000/discussions/1/reactions \
  -H "Authorization: Bearer $MOD_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"type":"love"}' | jq
```

Mettre à jour une réaction (même utilisateur, même discussion = upsert) :

```bash
curl -s -X POST http://localhost:3000/discussions/1/reactions \
  -H "Authorization: Bearer $MOD_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"type":"wow"}' | jq
```

Type de réaction invalide (doit échouer 400) :

```bash
curl -s -X POST http://localhost:3000/discussions/1/reactions \
  -H "Authorization: Bearer $MOD_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"type":"invalid"}' | jq
```

Réagir à une discussion qui n'existe pas (doit échouer 404) :

```bash
curl -s -X POST http://localhost:3000/discussions/999/reactions \
  -H "Authorization: Bearer $MOD_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"type":"like"}' | jq
```

Retirer sa propre réaction d'une discussion :

```bash
curl -s -X DELETE http://localhost:3000/discussions/1/reactions \
  -H "Authorization: Bearer $MOD_TOKEN" | jq
```

Retirer une réaction qui n'existe pas (doit échouer 404) :

```bash
curl -s -X DELETE http://localhost:3000/discussions/1/reactions \
  -H "Authorization: Bearer $MOD_TOKEN" | jq
```

---

## Routes des réactions sur les commentaires

Ajouter une réaction au commentaire 1 de la discussion 1 :

```bash
curl -s -X POST http://localhost:3000/discussions/1/comments/1/reactions \
  -H "Authorization: Bearer $MOD_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"type":"haha"}' | jq
```

Mettre à jour une réaction sur un commentaire (upsert) :

```bash
curl -s -X POST http://localhost:3000/discussions/1/comments/1/reactions \
  -H "Authorization: Bearer $MOD_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"type":"sad"}' | jq
```

Retirer sa propre réaction d'un commentaire :

```bash
curl -s -X DELETE http://localhost:3000/discussions/1/comments/1/reactions \
  -H "Authorization: Bearer $MOD_TOKEN" | jq
```

---

## Routes des utilisateurs

Lister les utilisateurs (nécessite la permission user.read.any) :

```bash
curl -s "http://localhost:3000/users" \
  -H "Authorization: Bearer $USER_TOKEN" | jq
```

Liste des utilisateurs avec pagination :

```bash
curl -s "http://localhost:3000/users?page=1&limit=2" \
  -H "Authorization: Bearer $ADMIN_TOKEN" | jq
```

Récupérer le profil de l'utilisateur connecté :

```bash
curl -s http://localhost:3000/users/me \
  -H "Authorization: Bearer $USER_TOKEN" | jq
```

Récupérer un utilisateur par son ID :

```bash
curl -s http://localhost:3000/users/3 \
  -H "Authorization: Bearer $USER_TOKEN" | jq
```

Récupérer un utilisateur qui n'existe pas :

```bash
curl -s http://localhost:3000/users/999 \
  -H "Authorization: Bearer $ADMIN_TOKEN" | jq
```

Modifier son propre profil (user_charlie = id 3) :

```bash
curl -s -X PATCH http://localhost:3000/users/3 \
  -H "Authorization: Bearer $USER_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"fname":"Charles","lname":"Modifié"}' | jq
```

Modifier le profil de quelqu'un d'autre en tant qu'utilisateur classique (doit échouer 403) :

```bash
curl -s -X PATCH http://localhost:3000/users/1 \
  -H "Authorization: Bearer $USER_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"fname":"Piraté"}' | jq
```

Modifier n'importe quel utilisateur en tant qu'admin (doit fonctionner) :

```bash
curl -s -X PATCH http://localhost:3000/users/4 \
  -H "Authorization: Bearer $ADMIN_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"fname":"Diana-Modifiée"}' | jq
```

---

## Routes de ban / unban

Bannir user_diana (id 4) en tant que modérateur :

```bash
curl -s -X POST http://localhost:3000/users/4/ban \
  -H "Authorization: Bearer $MOD_TOKEN" | jq
```

Essayer de bannir l'admin en tant que modérateur (doit échouer 403) :

```bash
curl -s -X POST http://localhost:3000/users/1/ban \
  -H "Authorization: Bearer $MOD_TOKEN" | jq
```

Essayer de se bannir soi-même (doit échouer 400) :

```bash
curl -s -X POST http://localhost:3000/users/2/ban \
  -H "Authorization: Bearer $MOD_TOKEN" | jq
```

Débannir user_diana en tant qu'admin :

```bash
curl -s -X POST http://localhost:3000/users/4/unban \
  -H "Authorization: Bearer $ADMIN_TOKEN" | jq
```

---

## Suppression d'utilisateur

Supprimer quelqu'un d'autre en tant qu'utilisateur classique (doit échouer 403) :

```bash
curl -s -X DELETE http://localhost:3000/users/4 \
  -H "Authorization: Bearer $USER_TOKEN" | jq
```

Supprimer l'admin en tant que modérateur (doit échouer 403) :

```bash
curl -s -X DELETE http://localhost:3000/users/1 \
  -H "Authorization: Bearer $MOD_TOKEN" | jq
```

---

## Déconnexion

Déconnexion de l'admin :

```bash
curl -s -X POST http://localhost:3000/auth/logout \
  -H "Authorization: Bearer $ADMIN_TOKEN" | jq
```

Vérifier que le token est bien invalidé après la déconnexion (doit échouer 401) :

```bash
curl -s http://localhost:3000/auth/me \
  -H "Authorization: Bearer $ADMIN_TOKEN" | jq
```

---

## Validation et cas limites

Tentative d'injection XSS dans le titre d'une discussion (doit être échappé) :

```bash
curl -s -X POST http://localhost:3000/discussions \
  -H "Authorization: Bearer $USER_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"title":"<script>alert(1)</script>","content":"Test XSS"}' | jq
```

Titre trop long (plus de 200 caractères - doit échouer 400) :

```bash
curl -s -X POST http://localhost:3000/discussions \
  -H "Authorization: Bearer $USER_TOKEN" \
  -H "Content-Type: application/json" \
  -d "{\"title\":\"$(printf 'A%.0s' {1..201})\",\"content\":\"test\"}" | jq
```

---

# Construction un requete (consultation)

```
curl -s -X <MÉTHODE> <URL> \
  -H "Authorization: Bearer <TOKEN>" \
  -H "Content-Type: application/json" \
  -d '<BODY_JSON>'
```


# Routes

| Méthode | Route | Auth requise | Body |
|---------|-------|:------------:|------|
| `GET` | `/health` | Non | — |
| `POST` | `/auth/register` | Non | `username, password, fname, lname` |
| `POST` | `/auth/login` | Non | `username, password` |
| `POST` | `/auth/logout` | Oui | — |
| `GET` | `/auth/me` | Oui | — |
| `GET` | `/discussions` | Non | — |
| `GET` | `/discussions/:id` | Non | — |
| `POST` | `/discussions` | Oui | `title, content` |
| `PATCH` | `/discussions/:id` | Oui | `title` et/ou `content` |
| `DELETE` | `/discussions/:id` | Oui | — |
| `POST` | `/discussions/:id/reactions` | Oui | `type` (like, love, haha, wow, sad, angry) |
| `DELETE` | `/discussions/:id/reactions` | Oui | — |
| `GET` | `/discussions/:id/comments` | Non | — |
| `POST` | `/discussions/:id/comments` | Oui | `content` |
| `PATCH` | `/discussions/:id/comments/:commentId` | Oui | `content` |
| `DELETE` | `/discussions/:id/comments/:commentId` | Oui | — |
| `POST` | `/discussions/:id/comments/:commentId/reactions` | Oui | `type` |
| `DELETE` | `/discussions/:id/comments/:commentId/reactions` | Oui | — |
| `GET` | `/users` | Oui | — |
| `GET` | `/users/me` | Oui | — |
| `GET` | `/users/:id` | Oui | — |
| `PATCH` | `/users/:id` | Oui | `fname` et/ou `lname` |
| `DELETE` | `/users/:id` | Oui | — |
| `POST` | `/users/:id/ban` | Oui (mod/admin) | — |
| `POST` | `/users/:id/unban` | Oui (mod/admin) | — |


# Nettoyage

On est dans Docker, si vous voulez on peut reset le data.

```bash
docker-compose exec backend npx sequelize-cli db:seed:undo:all
docker-compose exec backend npx sequelize-cli db:seed:all
```

