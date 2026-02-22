# Diagnostic du Frontend Shopeasy

Ce document présente l'analyse complète du frontend de l'application Shopeasy, basée sur la branche `feat-shopeasy-base-project`.

## 1. Fonctionnalités Principales

L'application est une plateforme d'e-commerce structurée autour des fonctionnalités suivantes :

*   **Authentification & Profil :**
    *   Inscription d'un nouvel utilisateur.
    *   Connexion / Déconnexion.
    *   Persistance de la session via token JWT et `SharedPreferences`.
    *   Récupération automatique du profil au démarrage (`/auth/me`).
    *   Mise à jour des informations de profil (nom, email).
*   **Catalogue & Navigation :**
    *   Affichage de la liste des produits.
    *   Filtrage par catégorie.
    *   Consultation détaillée d'un produit (image, description, prix, stock).
*   **Avis Produits (Reviews) :**
    *   Lecture des avis clients pour chaque produit.
    *   Ajout d'un avis (note de 1 à 5 et commentaire).
*   **Gestion du Panier :**
    *   Ajout de produits au panier.
    *   Modification des quantités et suppression d'articles.
    *   Calcul en temps réel du montant total.
*   **Commandes (Orders) :**
    *   Processus de checkout avec saisie d'adresse.
    *   Validation de la commande auprès de l'API.
    *   Consultation de l'historique des commandes passées.
*   **Thème :** Support des modes clair et sombre.

## 2. Modèles de Données

Les modèles définis dans `lib/models/` sont :

*   **User :** `id`, `firstName`, `lastName`, `email`, `token`.
*   **Product :** `id`, `title`, `description`, `price`, `quantityInStock`, `imageUrl`.
*   **Category :** `id`, `title`, `description`, `imageUrl`.
*   **Review :** `id`, `productId`, `userId`, `comment`, `rating`, `createdAt`.
*   **Order :** `id`, `status`, `totalAmount`, `items` (List<OrderItem>), `createdAt`, `updatedAt`.
*   **OrderItem :** `id`, `quantity`, `price`.
*   **Address :** `id`, `street`, `city`, `zipCode`, `country`.

## 3. Analyse de l'API (Endpoints)

Base URL configurée : `https://shopeasy-backend-levs.onrender.com/api`

### Authentification & Utilisateurs
*   `POST /auth/login` : Authentification.
*   `GET /auth/me` : Infos utilisateur connecté.
*   `POST /users/register` : Inscription.
*   `PUT /users/:id` : Mise à jour du profil.

### Produits & Catégories
*   `GET /categories` : Liste des catégories.
*   `GET /products` : Liste des produits (supporte le paramètre `?category=`).
*   `GET /products/:id` : Détails d'un produit.

### Avis (Reviews)
*   `GET /products/:id/reviews` : Liste des avis.
*   `POST /products/:id/reviews` : Création d'un avis.

### Commandes (Orders)
*   `GET /orders` : Historique des commandes.
*   `POST /orders` : Création d'une commande.

## 4. Besoins Côté Backend

Pour assurer le bon fonctionnement du frontend, le backend doit implémenter :

1.  **Gestion JWT :** Émission et validation de tokens Bearer.
2.  **Base de Données Relationnelle :**
    *   Tables correspondantes aux modèles listés ci-dessus.
    *   Relations clés étrangères (ex: `OrderItems` reliés à `Orders` et `Products`).
3.  **Stock :** Décrémentation automatique de `quantityInStock` lors d'une commande.
4.  **Validation :** Sécurisation des entrées utilisateur (format email, unicité de l'email, etc.).
5.  **Hébergement :** Service pour servir les images des produits (`imageUrl`).
