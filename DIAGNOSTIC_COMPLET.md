# Diagnostic Complet Shopeasy (Frontend & Backend)

Ce document présente l'analyse de l'application Shopeasy, identifiant les écarts entre le frontend Flutter et le backend Node.js, et propose des recommandations pour assurer la robustesse du système.

## 1. Diagnostic du Frontend (Flutter)

L'application frontend est bien structurée mais dépend de plusieurs endpoints et formats de données qui ne sont pas encore totalement alignés avec le backend.

### Points forts
*   Architecture claire (modèles, providers, services).
*   Gestion du panier et du thème déjà fonctionnelle en local.
*   Modèles de données complets (User, Product, Order, Review, etc.).

### Points d'attention
*   **Services API :** Les URLs sont codées en dur dans `api_service.dart`.
*   **Validation :** Certaines validations de formulaires pourraient être renforcées.

---

## 2. Diagnostic du Backend (Node.js)

Le backend actuel (branche `main` ou intégré) nécessite des ajustements majeurs pour supporter toutes les fonctionnalités du frontend.

### Écarts API et Compatibilité
| Fonctionnalité | Route Frontend | Route Backend | Statut |
| :--- | :--- | :--- | :--- |
| Inscription | `POST /users/register` | `POST /auth/register` | ❌ Incohérent |
| Session | `GET /auth/me` | `GET /users/me` | ❌ Incohérent |
| Commandes | `POST /orders` | `POST /api/cart/validate` | ❌ Incohérent |
| Avis | `GET /products/:id/reviews` | Aucun | ❌ Manquant |

### Format des Réponses
*   **Enveloppement JSON :** Le frontend attend `{ "products": [...] }` mais le backend renvoie `[...]`.
*   **Réponse Login :** Le frontend attend l'objet `user` complet lors du login, pas seulement l'ID.

---

## 3. Analyse de la Base de Données

### Modifications de Schéma Requises
1.  **Table `Orders` :** Ajouter les colonnes d'adresse (`street`, `city`, `zipCode`, `country`).
2.  **Table `Reviews` (À CRÉER) :**
    *   `comment` (TEXT), `rating` (INTEGER 1-5).
    *   Relations avec `User` et `Product`.
3.  **Table `Products` :** S'assurer que `imageUrl` est présent et systématiquement rempli.

---

## 4. Recommandations Sécurité, Performance et Robustesse

### Sécurité
*   **JWT Secret :** Utiliser des variables d'environnement (`process.env.JWT_SECRET`) au lieu de valeurs par défaut.
*   **CORS :** Restreindre les origines en production.

### Validation
*   Utiliser `express-validator` pour valider strictement les entrées (ex: prix positif, note entre 1 et 5).

### Performance
*   **Indexation :** Ajouter des index sur `email` (Users) et `CategoryId` (Products).
*   **Pagination :** Indispensable pour la route `/products` si le catalogue s'étoffe.

---

## 5. Plan d'Action
1.  **Harmoniser les Endpoints :** Aligner les routes backend sur les appels du frontend.
2.  **Standardiser les Réponses :** Envelopper systématiquement les listes dans des objets JSON.
3.  **Mettre à jour Sequelize :** Créer les migrations pour les adresses et les avis.
4.  **Enrichir le Login :** Inclure les données utilisateur dans la réponse JWT.
