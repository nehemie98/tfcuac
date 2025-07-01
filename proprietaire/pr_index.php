<?php
session_start();
require_once(__DIR__."/../classe/utilisateurs.php");
require_once(__DIR__ . "/../classe/maison.php");
require_once(__DIR__ . '/../classe/demande_location.php');
require_once(__DIR__ . '/../classe/paiement.php');
require_once(__DIR__ . '/../classe/contrat.php');


// Vérifier si l'utilisateur est connecté
if (!isset($_SESSION['user_id'])) {
    header('Location: ../connexion.php');
    exit();
}

// Instancier la classe Maison
$maison = new Maison();
$demande = new DemandeLocation();
// Récupérer les demandes envoyées aux maisons du propriétaire
$demandesEnvoyees = $demande->getDemandesEnvoyeesAMaMaison($_SESSION['user_id']);

$user_id = intval($_SESSION['user_id']);

if (isset($_POST['publier'])) {
    $message = '';
    $photoName = $_FILES["photo"]["name"] ?? '';
    $photoTmp = $_FILES["photo"]["tmp_name"] ?? '';
    $photoSize = $_FILES["photo"]["size"] ?? 0;
    $photoDir = __DIR__ . '/../images/maison/';
    $photoExt = strtolower(pathinfo($photoName, PATHINFO_EXTENSION));
    $uploadOk = 1;
    $newPhotoName = '';

    // Vérifier si un fichier a été envoyé
    if (!$photoTmp || $photoName === '') {
        $message .= "Veuillez sélectionner une image.<br>";
        $uploadOk = 0;
    }

    // Vérifier si le fichier est une image
    if ($uploadOk && getimagesize($photoTmp) === false) {
        $message .= "Le fichier n'est pas une image.<br>";
        $uploadOk = 0;
    }

    // Vérifier la taille du fichier (max 15 Mo)
    if ($uploadOk && $photoSize > 15728640) {
        $message .= "Fichier trop volumineux (max 15 Mo).<br>";
        $uploadOk = 0;
    }

    // Autoriser certains formats de fichier
    if ($uploadOk && !in_array($photoExt, ["jpg", "jpeg", "png", "gif","webp"])) {
        $message .= "Formats autorisés : JPG, JPEG, PNG, GIF,WEBP.<br>";
        $uploadOk = 0;
    }

    // Upload de l'image
    if ($uploadOk) {
        if (!is_dir($photoDir)) {
            mkdir($photoDir, 0777, true);
        }
        $newPhotoName = uniqid('maison_') . '.' . $photoExt;
        $targetFile = $photoDir . $newPhotoName;
        if (!move_uploaded_file($photoTmp, $targetFile)) {
            $message .= "Erreur lors du téléchargement de l'image.<br>";
            $uploadOk = 0;
        }
    }

    // Validation des champs
    $adresse = trim($_POST['adresse'] ?? '');
    $nombre_de_chambre = intval($_POST['nombre_de_chambre'] ?? 0);
    $statut = trim($_POST['statut'] ?? '');
    $prix = floatval($_POST['prix'] ?? 0);
    $description = trim($_POST['description'] ?? '');

    if ($uploadOk && $adresse && $nombre_de_chambre > 0 && $statut && $prix > 0 && $description) {
        // Enregistrer uniquement le nom du fichier image dans la base
        $maison->ajouterMaison(
            htmlspecialchars($adresse),
            $nombre_de_chambre,
            $newPhotoName,
            htmlspecialchars($statut),
            $prix,
            htmlspecialchars($description),
            $user_id
        );
        header('Location: pr_index.php?ajout=ok');
        exit();
    } else {
        // Vous pouvez afficher $message dans la page pour informer l'utilisateur
        // Exemple : echo '<div class="alert alert-danger">'.$message.'</div>';
    }
    // Fonction pour obtenir le nombre total de demandes pour les maisons du propriétaire
  

    // Exemple d'utilisation pour afficher le nombre total de demandes dans une variable
    $paiement = new Paiement();
    $nombrePaiements = $paiement->getPaiementsParProprietaire($id_user);
   
}
?>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Tableau de bord Propriétaire</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="icon" type="image/png" href="../images/logo/logos.avif">
    <link rel="stylesheet" href="../asset/css/adm_index.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        .sidebar .nav-link.active { background: #fff; color: #0d6efd !important; }
        .notif-badge { position: absolute; top: 8px; right: 16px; background: red; color: #fff; border-radius: 50%; padding: 2px 7px; font-size: 12px; }
        .main-section { display: none; }
        .main-section.active { display: block; }
    </style>
</head>
<body>
<div class="container-fluid">
    <div class="row flex-nowrap">
        <!-- Sidebar -->
        <nav id="sidebarMenu" class="col-12 col-md-3 col-lg-2 d-md-block bg-primary sidebar collapse px-0 position-fixed h-100" style="z-index: 1030;">
            <div class="d-flex flex-column align-items-center py-4">
                <img src="../images/logo/logos.avif" alt="Logo Entreprise" class="logo mb-3 rounded-circle" style="width:70px; height:70px; object-fit:cover;">
                <ul class="nav flex-column w-100">
                    <li class="nav-item mb-2">
                        <a class="nav-link active d-flex align-items-center text-white" href="#" data-section="dashboard">
                            <i class="fas fa-tachometer-alt me-2"></i> Tableau de bord
                        </a>
                    </li>
                    <li class="nav-item mb-2">
                        <a class="nav-link d-flex align-items-center text-white" href="#" data-bs-toggle="modal" data-bs-target="#modalAnnonce">
                            <i class="fas fa-bullhorn me-2"></i> Publier annonce
                        </a>
                    </li>
                    <li class="nav-item mb-2 position-relative">
                        <a class="nav-link d-flex align-items-center text-white" href="#" data-section="demandes">
                            <i class="fas fa-bell me-2"></i> Demandes
                            <span class="notif-badge"><?php echo  $nombreDemandes =$demande->getNombreDemandesPourMesMaisons($user_id);?></span>
                        </a>
                    </li>
                    <li class="nav-item mb-2">
                        <a class="nav-link d-flex align-items-center text-white" href="#" data-section="paiements">
                            <i class="fas fa-credit-card me-2"></i> Paiements
                        </a>
                    </li>
                    <li class="nav-item mb-2">
                        <a class="nav-link d-flex align-items-center text-white" href="#" data-section="messages">
                            <i class="fas fa-envelope me-2"></i> Messages/Évaluations
                        </a>
                    </li>
                    <li class="nav-item mt-4">
                        <a class="nav-link text-danger d-flex align-items-center bg-white" href="#">
                            <i class="fas fa-sign-out-alt me-2"></i> Déconnexion
                        </a>
                    </li>
                </ul>
            </div>
        </nav>
        <!-- Sidebar toggle button for mobile -->
        <button class="btn btn-primary d-md-none position-fixed m-2" style="z-index:1040; left:10px; top:10px;" type="button" data-bs-toggle="collapse" data-bs-target="#sidebarMenu" aria-controls="sidebarMenu" aria-expanded="false" aria-label="Toggle navigation" id="sidebarToggle">
            <i class="fas fa-bars"></i>
        </button>
        <!-- Main Content -->
        <main class="col-12 col-md-9 col-lg-10 ms-auto px-3 main-content" style="min-height:100vh;">
            <!-- Tableau de bord -->
            <div class="main-section active" id="dashboard">
                <div class="d-flex justify-content-between align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2 mb-0"><i class="fas fa-home me-2 text-primary"></i>Tableau de bord</h1>
                    <div class="d-flex align-items-center mt-3">
                        <img src="../images/inscription/<?php echo !empty($_SESSION['photo']) ? htmlspecialchars($_SESSION['photo']) : 'avantar.avif'; ?>" 
                             alt="Photo de profil" 
                             class="rounded-circle me-2" 
                             style="width:40px; height:40px; object-fit:cover;">
                        <span class="fw-bold">
                            <?php echo !empty($_SESSION['nom']) ? htmlspecialchars($_SESSION['nom']) : 'Propriétaire'; ?>
                        </span>
                    </div>
                </div>
                <div class="row g-3">
                    <div class="col-12 col-md-4">
                        <div class="card text-center shadow-sm h-100">
                            <div class="card-body">
                                <i class="fas fa-bullhorn fa-2x text-success mb-2"></i>
                                <h5 class="card-title">Publier une annonce</h5>
                                <button type="button" class="btn btn-success mt-2" data-bs-toggle="modal" data-bs-target="#modalAnnonce">
                                    Publier
                                </button>
                            </div>
                        </div>
                    </div>
                    <div class="col-12 col-md-4">
                        <div class="card text-center shadow-sm h-100">
                            <div class="card-body">
                                <i class="fas fa-bell fa-2x text-primary mb-2"></i>
                                <h5 class="card-title">Voir les demandes</h5>
                                <button class="btn btn-primary mt-2" onclick="showSection('demandes')">Voir</button>
                            </div>
                        </div>
                    </div>
                    <div class="col-12 col-md-4">
                        <div class="card text-center shadow-sm h-100">
                            <div class="card-body">
                                <i class="fas fa-credit-card fa-2x text-warning mb-2"></i>
                                <h5 class="card-title">Paiements</h5>
                                <button class="btn btn-warning mt-2 text-white" onclick="showSection('paiements')">Consulter</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- Section Demandes -->
            <div class="main-section" id="demandes">
                <div class="d-flex justify-content-between align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h2><i class="fas fa-bell me-2 text-primary"></i>Demandes reçues</h2>
                    <button class="btn btn-outline-secondary" onclick="showSection('dashboard')">Retour</button>
                </div>
                <!-- Liste des demandes dynamiques -->
                <div class="list-group">
                    <?php if (!empty($demandesEnvoyees)) : ?>
                        <?php foreach ($demandesEnvoyees as $demande) : ?>
                            <a href="#"
                               class="list-group-item list-group-item-action"
                               data-bs-toggle="modal"
                               data-bs-target="#modalDemande<?php echo intval($demande['id_demande']); ?>">
                                <strong>
                                    <?php echo htmlspecialchars($demande["nom_locataire"] ?? 'Locataire inconnu'); ?>
                                </strong>
                                - <?php echo htmlspecialchars($demande["email_locataire"] ?? 'Demande de location'); ?>
                                <span class="badge bg-<?php echo ($demande["statut"] === 'Nouveau') ? 'info' : 'secondary'; ?> ms-2">
                                    <?php echo htmlspecialchars($demande["statut"]); ?>
                                </span>
                            </a>
                            <!-- Modale dynamique pour chaque demande -->
                            <div class="modal fade" id="modalDemande<?php echo intval($demande['id_demande']); ?>" tabindex="-1" aria-labelledby="modalDemandeLabel<?php echo intval($demande['id_demande']); ?>" aria-hidden="true">
                                <div class="modal-dialog">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <h5 class="modal-title" id="modalDemandeLabel<?php echo intval($demande['id_demande']); ?>">
                                                <?php echo htmlspecialchars($demande["statut"] ?? 'Demande'); ?> - <?php echo htmlspecialchars($demande["nom_locataire"] ?? 'Locataire'); ?>
                                            </h5>
                                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                        </div>
                                        <div class="modal-body">
                                            <p><strong>Email :</strong> <?php echo htmlspecialchars($demande["email_locataire"] ?? ''); ?></p>
                
                                            <p><strong>nom :</strong> <?php echo nl2br(htmlspecialchars($demande["nom_locataire"] ?? '')); ?></p>
                                            <p><strong>Adresse du bien :</strong> <?php echo htmlspecialchars($demande["adresse"] ?? ''); ?></p>
                                            <p><strong>Statut :</strong>
                                                <span class="badge bg-<?php echo ($demande["statut"] === 'Nouveau') ? 'info' : 'secondary'; ?>">
                                                    <?php echo htmlspecialchars($demande["statut"]); ?>
                                                </span>
                                            </p>
                                        </div>
                                        <div class="modal-footer">
                                            <form method="post" action="action.php" class="d-inline">
                                                <input type="hidden" name="id_demande" value="<?php echo intval($demande['id_demande']); ?>">
                                                <button type="submit" name="accepter" class="btn btn-success">Accepter</button>
                                            </form>
                                            <form method="post" action="action.php" class="d-inline ms-2">
                                                <input type="hidden" name="id_demande" value="<?php echo intval($demande['id_demande']); ?>">
                                                <button type="submit" name="refuser" class="btn btn-danger">Refuser</button>
                                            </form>
                                            <button class="btn btn-outline-secondary" data-bs-dismiss="modal">Fermer</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        <?php endforeach; ?>
                    <?php else : ?>
                        <div class="alert alert-info">Aucune demande reçue pour le moment.</div>
                    <?php endif; ?>
                </div>
            </div>
            <!-- Section Paiements -->
            <div class="main-section" id="paiements">
                <div class="d-flex justify-content-between align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h2><i class="fas fa-credit-card me-2 text-warning"></i>Paiements</h2>
                    <button class="btn btn-outline-secondary" onclick="showSection('dashboard')">Retour</button>
                </div>
                <!-- Tableau des paiements (exemple statique) -->
                <table class="table table-striped">
                    <thead>
                        <?php if (!empty($nombrePaiements)) : ?>
                        <?php foreach ($nombrePaiements as $paie) : ?>
                        <tr>
                            <th>Locataire</th>
                            <th>Montant</th>
                            <th>Date</th>
                            <th>Statut</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td><?php echo htmlspecialchars($paie["nom_locataire"] ?? 'Locataire inconnu'); ?></td>
                            <td><?php echo htmlspecialchars($paie["montant"] ?? 'Locataire inconnu'); ?></td>
                            <td><?php echo htmlspecialchars($paie["date"] ?? 'Locataire inconnu'); ?></td>
                            <td><span class="badge bg-success"><?php echo htmlspecialchars($paie["statut"] ?? 'Locataire inconnu'); ?></span></td>
                        </tr>
                        <?php endforeach; ?>
                        <?php else : ?>
                        <tr>
                            <td colspan="4" class="text-center">Aucun paiement enregistré.</td> 
                        </tr>
                        <?php endif; ?>
                    </tbody>
                </table>
            </div>
            <!-- Section Messages/Evaluations -->
            <div class="main-section" id="messages">
                <div class="d-flex justify-content-between align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h2><i class="fas fa-envelope me-2 text-info"></i>Messages & Évaluations</h2>
                    <button class="btn btn-outline-secondary" onclick="showSection('dashboard')">Retour</button>
                </div>
                <!-- Liste des messages (exemple statique) -->
                <div class="list-group">
                    <a href="#" class="list-group-item list-group-item-action" data-bs-toggle="modal" data-bs-target="#modalMessage1">
                        <strong>Évaluation</strong> - Jean Dupont <span class="badge bg-success ms-2">Nouveau</span>
                    </a>
                    <a href="#" class="list-group-item list-group-item-action" data-bs-toggle="modal" data-bs-target="#modalMessage2">
                        <strong>Message</strong> - Marie Martin
                    </a>
                </div>
            </div>
        </main>
    </div>
</div>

<!-- Modale Publier Annonce -->
<!-- Modale Publier Annonce (étapes séquentielles) -->
<div class="modal fade" id="modalAnnonce" tabindex="-1" aria-labelledby="modalAnnonceLabel" aria-hidden="true">
    <div class="modal-dialog">
        <form class="modal-content" method="post" action="" enctype="multipart/form-data" id="formAnnonce">
            <div class="modal-header">
                <h5 class="modal-title" id="modalAnnonceLabel">Publier une annonce</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <!-- Étape 1 -->
                <div class="step-annonce" id="step1">
                    <div class="mb-3">
                        <label for="id_utilisateur" class="form-label">ID Utilisateur</label>
                        <input type="text" class="form-control" id="id_utilisateur" name="id_utilisateur" value="<?php echo isset($_SESSION['user_id']) ? intval($_SESSION['user_id']) : ''; ?>">
                    </div>
                    <div class="mb-3">
                        <label for="adresse" class="form-label">Adresse</label>
                        <input type="text" class="form-control" id="adresse" name="adresse" required>
                    </div>
                    <div class="mb-3">
                        <label for="nombre_de_chambre" class="form-label">Nombre de chambres</label>
                        <input type="number" class="form-control" id="nombre_de_chambre" name="nombre_de_chambre" min="1" required>
                    </div>
                    <div class="mb-3">
                        <label for="photo" class="form-label">Photo</label>
                        <input type="file" class="form-control" id="photo" name="photo" accept="image/*" required>
                    </div>
                    <button type="button" class="btn btn-primary float-end" id="toStep2">Suivant</button>
                </div>
                <!-- Étape 2 -->
                <div class="step-annonce d-none" id="step2">
                    <div class="mb-3">
                        <label for="statut" class="form-label">Statut</label>
                        <select class="form-select" id="statut" name="statut" required>
                            <option value="">Sélectionner...</option>
                            <option value="Disponible">Disponible</option>
                            <option value="Indisponible">Indisponible</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="prix" class="form-label">Prix (€)</label>
                        <input type="number" class="form-control" id="prix" name="prix" min="0" required>
                    </div>
                    <div class="mb-3">
                        <label for="description" class="form-label">Description</label>
                        <textarea class="form-control" id="description" name="description" required></textarea>
                    </div>
                    <button type="button" class="btn btn-secondary" id="backStep1">Précédent</button>
                    <button type="submit" class="btn btn-success float-end" name="publier">Publier</button>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Annuler</button>
            </div>
        </form>
    </div>
</div>

<!-- Modale Demande 1 -->
<div class="modal fade" id="modalDemande1" tabindex="-1" aria-labelledby="modalDemande1Label" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="modalDemande1Label">Demande de location - Jean Dupont</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <p><strong>Email :</strong> jean.dupont@email.com</p>
                <p><strong>Téléphone :</strong> 0600000000</p>
                <p><strong>Message :</strong> Je souhaite louer votre appartement du 1er juillet.</p>
                <p><strong>Statut :</strong> <span class="badge bg-info">Nouveau</span></p>
            </div>
            <div class="modal-footer">
                <button class="btn btn-success">Accepter</button>
                <button class="btn btn-danger">Refuser</button>
                <button class="btn btn-outline-secondary" data-bs-dismiss="modal">Fermer</button>
            </div>
        </div>
    </div>
</div>
<!-- Modale Demande 2 -->
<div class="modal fade" id="modalDemande2" tabindex="-1" aria-labelledby="modalDemande2Label" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="modalDemande2Label">Demande de visite - Marie Martin</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <p><strong>Email :</strong> marie.martin@email.com</p>
                <p><strong>Téléphone :</strong> 0700000000</p>
                <p><strong>Message :</strong> Puis-je visiter l'appartement ce week-end ?</p>
                <p><strong>Statut :</strong> <span class="badge bg-secondary">En attente</span></p>
            </div>
            <div class="modal-footer">
                <button class="btn btn-success">Accepter</button>
                <button class="btn btn-danger">Refuser</button>
                <button class="btn btn-outline-secondary" data-bs-dismiss="modal">Fermer</button>
            </div>
        </div>
    </div>
</div>
<!-- Modale Message 1 -->
<div class="modal fade" id="modalMessage1" tabindex="-1" aria-labelledby="modalMessage1Label" aria-hidden="true">
    <div class="modal-dialog">
        <form class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="modalMessage1Label">Évaluation - Jean Dupont</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <p><strong>Note :</strong> ⭐⭐⭐⭐⭐</p>
                <p><strong>Commentaire :</strong> Très bon propriétaire, réactif et sympathique !</p>
                <div class="mb-3">
                    <label for="reponse1" class="form-label">Répondre :</label>
                    <textarea class="form-control" id="reponse1" name="reponse"></textarea>
                </div>
            </div>
            <div class="modal-footer">
                <button class="btn btn-primary">Envoyer la réponse</button>
                <button class="btn btn-outline-secondary" data-bs-dismiss="modal">Fermer</button>
            </div>
        </form>
    </div>
</div>
<!-- Modale Message 2 -->
<div class="modal fade" id="modalMessage2" tabindex="-1" aria-labelledby="modalMessage2Label" aria-hidden="true">
    <div class="modal-dialog">
        <form class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="modalMessage2Label">Message - Marie Martin</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <p><strong>Message :</strong> Merci pour votre disponibilité !</p>
                <div class="mb-3">
                    <label for="reponse2" class="form-label">Répondre :</label>
                    <textarea class="form-control" id="reponse2" name="reponse"></textarea>
                </div>
            </div>
            <div class="modal-footer">
                <button class="btn btn-primary">Envoyer la réponse</button>
                <button class="btn btn-outline-secondary" data-bs-dismiss="modal">Fermer</button>
            </div>
        </form>
    </div>
    
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="../asset/js/pr_index.js"></script>
</body>
</html>