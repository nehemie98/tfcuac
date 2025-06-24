<?php
require_once(__DIR__ . "/../classe/utilisateurs.php");
require_once(__DIR__ . "/../classe/maison.php");
// adm_index.php
session_start();
$us=new Utilisateur();
$mais=new Maison();
// Vérifiez si l'utilisateur est connecté et a le rôle d'administrateur 


$utilisa=$us->getutilisateurs(); 
// Vérifiez ici si l'utilisateur est bien administrateur
if(isset($_GET['sup'])) {
    // Vérification si l'utilisateur a cliqué sur le bouton de modification ou de suppression
    $id = $_GET['sup'] ?? null;	
    if ($id) {
        if ($us->deleteuser($id) === true) {
            header("location: adm_index.php");
            exit();
        } else { 
            echo "impossible de supprimer" . PHP_EOL;
        }
    }
}
$maisons = $mais->getMaisons();
?>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Tableau de bord Administrateur</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- Bootstrap 5 CDN -->
    <link rel="stylesheet" href="../asset/css/adm_index.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <style>
       
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
                            <i class="fas fa-tachometer-alt me-2"></i> Dashboard
                        </a>
                    </li>
                    <li class="nav-item mb-2">
                        <a class="nav-link d-flex align-items-center text-white" href="#" data-section="utilisateurs">
                            <i class="fas fa-users me-2"></i> Utilisateurs
                        </a>
                    </li>
                    <li class="nav-item mb-2">
                        <a class="nav-link d-flex align-items-center text-white" href="#" data-section="annonces">
                            <i class="fas fa-bullhorn me-2"></i> Annonces
                        </a>
                    </li>
                    <li class="nav-item mb-2">
                        <a class="nav-link d-flex align-items-center text-white" href="#" data-section="parametres">
                            <i class="fas fa-cogs me-2"></i> Paramètres
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
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                <h1 class="h2 mb-0"><i class="fas fa-home me-2 text-primary"></i>Tableau de bord</h1>
                <form class="d-flex mt-2 mt-md-0" role="search" method="get" action="recherche.php">
                    <input class="form-control me-2" type="search" name="q" placeholder="Rechercher un profil..." aria-label="Search">
                    <button class="btn btn-outline-primary" type="submit"><i class="fas fa-search"></i></button>
                </form>
                <div class="d-flex align-items-center mt-3">
                    <img src="../images/inscription/<?php echo isset($_SESSION['photo']) ? htmlspecialchars($_SESSION['photo']) : 'avantar.avif'; ?>" 
                         alt="Photo de profil" 
                         class="rounded-circle me-2" 
                         style="width:40px; height:40px; object-fit:cover;">
                    <span class="fw-bold">
                        <?php echo isset($_SESSION['nom']) ? htmlspecialchars($_SESSION['nom']) : 'Administrateur'; ?>
                    </span>
                </div>
            </div>
            <!-- Dashboard Section -->
            <div id="section-dashboard" class="section-content">
                <div class="alert alert-info">Bienvenue sur le tableau de bord administrateur.</div>
            </div>
            <!-- Utilisateurs Section -->
            <div id="section-utilisateurs" class="section-content" style="display:none;">
                <!-- Tableau d'activités -->
                <div class="card mb-4 shadow-sm">
                    <div class="card-header bg-primary text-white">
                        <i class="fas fa-history me-2"></i><strong>Liste des utilisateurs</strong>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-striped mb-0 align-middle">
                                <thead>
                                    <tr>
                                        <th>NOM</th>
                                        <th>EMAIL</th>
                                        <th>MOT DE PASSE</th>
                                        <th>ROLE</th>
                                        <th>IMAGE</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                  <?php
                                        $page = $_GET['page'] ?? 1;
                                        $page = max(1, intval($page));
                                        $result = method_exists($us, 'pagination') ? $us->pagination($page) : [];
                                        if (!empty($result)) {
                                            foreach ($result as $row) {
                                                echo "
                                                <tr>
                                                <td>" . htmlspecialchars($row['nom'] ?? '') . "</td>
                                                <td>" . htmlspecialchars($row['email'] ?? '') . "</td>
                                                <td>" . htmlspecialchars($row['mot_de_passe'] ?? '') . "</td>
                                                <td>" . htmlspecialchars($row['role'] ?? '') . "</td>
                                                <td class='img'> <img src='../image/inscription/" . htmlspecialchars( $row['image_profile'] ??'') . "' alt=''> </td>
                                                <td>
                                                    <a href='modification.php?mod=" . urlencode($row['id'] ?? '') . "' class='btn btn-warning btn-sm'>Modifier</a>
                                                    <a href='?sup=" . urlencode($row['id'] ?? '') . "' class='btn btn-danger btn-sm' onclick='return confirm(\"Êtes-vous sûr de vouloir supprimer cet utilisateur ?\");'>Supprimer</a>
                                                </td>
                                              </tr>";
                                    }
                                } else {
                                    echo "<tr><td colspan='6' class='text-center'>Aucun utilisateur trouvé</td></tr>";
                                }
                                    ?>
                                </tbody>
                            </table>
                            <nav aria-label="Page navigation example">
                                <ul class="pagination">
                                    <?php
                                    $totalPages = method_exists($us, 'gettotal') ? $us->gettotal() : 1;
                                    $page = isset($_GET['page']) ? (int)$_GET['page'] : 1;
                                    ?>
                                    <li class="page-item <?php if ($page <= 1) echo 'disabled'; ?>">
                                        <a class="page-link" href="?page=<?php echo $page - 1; ?>">Précédent</a>
                                    </li>
                                    <?php for ($i = 1; $i <= $totalPages; $i++) { ?>
                                        <li class="page-item <?php if ($page == $i) echo 'active'; ?>">
                                            <a class="page-link" href="?page=<?php echo $i; ?>"><?php echo $i; ?></a>
                                        </li>
                                    <?php } ?>
                                    <li class="page-item <?php if ($page >= $totalPages) echo 'disabled'; ?>">
                                        <a class="page-link" href="?page=<?php echo $page + 1; ?>">Suivant</a>
                                    </li>
                                </ul>
                            </nav>
                        </div>
                    </div>
                </div>
                <!-- Actions rapides -->
                <div class="row g-3">
                    <div class="col-12 col-md-4">
                        <div class="card text-center shadow-sm h-100">
                            <div class="card-body">
                                <div class="mb-2">
                                    <i class="fas fa-user-plus fa-2x text-success"></i>
                                </div>
                                <h5 class="card-title">Ajouter un utilisateur</h5>
                                <!-- Bouton pour ouvrir la modale -->
                                <button type="button" class="btn btn-success mt-2" data-bs-toggle="modal" data-bs-target="#ajoutUtilisateurModal">
                                    Ajouter
                                </button>
                                <!-- Modale d'ajout utilisateur (séquentielle) -->
                                <div class="modal fade" id="ajoutUtilisateurModal" tabindex="-1" aria-labelledby="ajoutUtilisateurModalLabel" aria-hidden="true" data-bs-backdrop="static" data-bs-keyboard="false">
                                    <div class="modal-dialog modal-dialog-centered">
                                        <div class="modal-content">
                                            <form id="ajoutUtilisateurForm" enctype="multipart/form-data" method="post" action="ajouter_utilisateur.php">
                                                <div class="modal-header">
                                                    <h5 class="modal-title" id="ajoutUtilisateurModalLabel">Ajouter un utilisateur</h5>
                                                </div>
                                                <div class="modal-body">
                                                    <!-- Étape 1 : Informations de base -->
                                                    <div class="step step-1">
                                                        <div class="mb-3">
                                                            <label for="nom" class="form-label">Nom</label>
                                                            <input type="text" class="form-control" id="nom" name="nom" required>
                                                        </div>
                                                        <div class="mb-3">
                                                            <label for="prenom" class="form-label">Prénom</label>
                                                            <input type="text" class="form-control" id="prenom" name="prenom" required>
                                                        </div>
                                                        <div class="mb-3">
                                                            <label for="email" class="form-label">Email</label>
                                                            <input type="email" class="form-control" id="email" name="email" required>
                                                        </div>
                                                        <div class="mb-3">
                                                            <label for="motdepasse" class="form-label">Mot de passe</label>
                                                            <input type="password" class="form-control" id="motdepasse" name="motdepasse" required>
                                                        </div>
                                                    </div>
                                                    <!-- Étape 2 : Photo de profil -->
                                                    <div class="step step-2 d-none">
                                                        <div class="mb-3">
                                                            <label for="photo" class="form-label">Photo de profil</label>
                                                            <input type="file" class="form-control" id="photo" name="photo" accept="image/*" required>
                                                        </div>
                                                    </div>
                                                    <!-- Étape 3 : Détails supplémentaires -->
                                                    <div class="step step-3 d-none">
                                                        <div class="mb-3">
                                                            <label for="telephone" class="form-label">Téléphone</label>
                                                            <input type="text" class="form-control" id="telephone" name="telephone" required>
                                                        </div>
                                                        <div class="mb-3">
                                                            <label for="role" class="form-label">Rôle</label>
                                                            <select class="form-select" id="role" name="role" required>
                                                                <option value="">Sélectionner...</option>
                                                                <option value="admin">Administrateur</option>
                                                                <option value="user">Utilisateur</option>
                                                            </select>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="modal-footer">
                                                    <button type="button" class="btn btn-secondary prev-step d-none">Précédent</button>
                                                    <button type="button" class="btn btn-primary next-step">Suivant</button>
                                                    <button type="submit" class="btn btn-success d-none">Ajouter</button>
                                                    <button type="button" class="btn btn-outline-danger" data-bs-dismiss="modal">Annuler</button>
                                                </div>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                             
                            </div>
                        </div>
                    </div>
                    <div class="col-12 col-md-4">
                        <div class="card text-center shadow-sm h-100">
                            <div class="card-body">
                                <div class="mb-2">
                                    <i class="fas fa-id-badge fa-2x text-primary"></i>
                                </div>
                                <h5 class="card-title">Voir les profils</h5>
                                <a href="#" class="btn btn-primary mt-2">Voir</a>
                            </div>
                        </div>
                    </div>
                    <div class="col-12 col-md-4">
                        <div class="card text-center shadow-sm h-100">
                            <div class="card-body">
                                <div class="mb-2">
                                    <i class="fas fa-file-export fa-2x text-warning"></i>
                                </div>
                                <h5 class="card-title">Exporter les données</h5>
                                <!-- Bouton Export Excel -->
                                <a href="export_excel.php" class="btn btn-warning mt-2 text-white mb-2">
                                    <i class="fas fa-file-excel me-1"></i>Exporter Excel
                                </a>
                                <!-- Bouton Export PDF -->
                                <a href="export_pdf.php" class="btn btn-danger mt-2 text-white mb-2">
                                    <i class="fas fa-file-pdf me-1"></i>Exporter PDF
                                </a>
                                <!-- Bouton Import Excel -->
                                <form action="import_excel.php" method="post" enctype="multipart/form-data" class="mt-2">
                                    <label class="form-label">Importer Excel</label>
                                    <input type="file" name="excel_file" accept=".xls,.xlsx,.pdf" class="form-control mb-2" required>
                                    <button type="submit" class="btn btn-success btn-sm">
                                        <i class="fas fa-upload me-1"></i>Importer
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- Annonces Section -->
            <div id="section-annonces" class="section-content" style="display:none;">
                <div class="card mb-4 shadow-sm">
                    <div class="card-header bg-primary text-white">
                        <i class="fas fa-bullhorn me-2"></i><strong>Gestion des annonces</strong>
                    </div>
                    <div class="card-body">
                        <p>Liste des maisons disponibles :</p>
                        <div class="row g-3">
                            <?php if (!empty($maisons)) : ?>
                                <?php foreach ($maisons as $maison) : 
                                    // Prépare le chemin complet de l'image
                                    $photo = !empty($maison['photo']) ? '../images/maison/' . $maison['photo'] : '../images/maison/default.jpg';
                                    $id_maison = $maison['id'] ?? ''; // Ajout de l'id_maison
                                ?>
                                    <div class="col-12 col-md-6 col-lg-4">
                                        <div class="card mb-3 shadow-sm">
                                            <img src="<?php echo htmlspecialchars($photo); ?>" class="card-img-top" alt="Maison" style="height:200px;object-fit:cover;">
                                            <div class="card-body">
                                                <h5 class="card-title"><?php echo htmlspecialchars($maison['adresse'] ?? ''); ?></h5>
                                                <p class="card-text mb-1"><i class="fas fa-bed"></i> <?php echo htmlspecialchars($maison['nombre_de_chambre'] ?? ''); ?> chambres</p>
                                                <p class="card-text mb-1"><i class="fas fa-info-circle"></i> Statut : <?php echo htmlspecialchars($maison['statut'] ?? ''); ?></p>
                                                <p class="fw-bold text-primary fs-5 mb-2"><?php echo htmlspecialchars($maison['prix'] ?? ''); ?> $</p>
                                                <button 
                                                    class="btn btn-outline-primary btn-sm"
                                                    onclick='showMaisonDetails(<?php echo json_encode([
                                                        "id" => $maison["id_maison"],
                                                        "photo" => $photo,
                                                        "adresse" => $maison["adresse"] ?? "",
                                                        "nombre_de_chambre" => $maison["nombre_de_chambre"] ?? "",
                                                        "statut" => $maison["statut"] ?? "",
                                                        "prix" => $maison["prix"] ?? "",
                                                        "description" => $maison["description"] ?? "",
                                                        "id_utilisateur" => $maison["id_utilisateur"] ?? ""
                                                    ], JSON_HEX_APOS | JSON_HEX_QUOT); ?>)'
                                                >
                                                    Voir détails
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                <?php endforeach; ?>
                            <?php else: ?>
                                <div class="col-12">
                                    <div class="alert alert-info text-center">Aucune annonce trouvée.</div>
                                </div>
                            <?php endif; ?>
                        </div>

                        <!-- Modal Détails Maison -->
                        <div class="modal fade" id="maisonDetailsModal" tabindex="-1" aria-labelledby="maisonDetailsModalLabel" aria-hidden="true">
                            <div class="modal-dialog modal-lg modal-dialog-centered">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title" id="maisonDetailsModalLabel">Détails de la maison</h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Fermer"></button>
                                    </div>
                                    <div class="modal-body">
                                        <div class="row g-3 align-items-center">
                                            <div class="col-12 col-md-5 mb-3 mb-md-0">
                                                <img id="maisonDetailsPhoto" src="" alt="Maison" class="img-fluid rounded w-100" style="object-fit:cover;max-height:300px;">
                                            </div>
                                            <div class="col-12 col-md-7">
                                                <h4 id="maisonDetailsAdresse"></h4>
                                                <p class="mb-1"><i class="fas fa-bed"></i> <span id="maisonDetailsChambres"></span> chambres</p>
                                                <p class="mb-1"><i class="fas fa-info-circle"></i> Statut : <span id="maisonDetailsStatut"></span></p>
                                                <p class="fw-bold text-primary fs-5 mb-2" id="maisonDetailsPrix"></p>
                                                <hr>
                                                <p id="maisonDetailsDescription"></p>
                                                <p class="mb-1 text-muted">ID utilisateur : <span id="maisonDetailsIdUtilisateur"></span></p>
                                                <p class="mb-1 text-muted">ID maison : <span id="maisonDetailsIdMaison"></span></p>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="modal-footer">
                                        <form id="maisonValidationForm" method="post" action="maison_validation.php" class="d-flex gap-2">
                                            <input type="hidden" name="maison_id" id="maisonDetailsHiddenId">
                                            <button type="submit" name="validite" value="approuver" class="btn btn-success">Approuver</button>
                                            <button type="submit" name="validite" value="rejeter" class="btn btn-danger">Rejeter</button>
                                        </form>
                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Fermer</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <script>
                        function showMaisonDetails(data) {
                                var img = document.getElementById('maisonDetailsPhoto');
                                img.src = data.photo && data.photo.trim() !== "" ? data.photo : '../images/maison/default.jpg';
                                img.onerror = function() { this.src = '../images/maison/default.jpg'; };
                                document.getElementById('maisonDetailsAdresse').textContent = data.adresse;
                                document.getElementById('maisonDetailsChambres').textContent = data.nombre_de_chambre;
                                document.getElementById('maisonDetailsStatut').textContent = data.statut;
                                document.getElementById('maisonDetailsPrix').textContent = data.prix + " $";
                                document.getElementById('maisonDetailsDescription').textContent = data.description;
                                document.getElementById('maisonDetailsIdUtilisateur').textContent = data.id_utilisateur;
                                document.getElementById('maisonDetailsIdMaison').textContent = data.id || '';
                                // Ajout de l'id de la maison dans le champ caché pour la validation
                                document.getElementById('maisonDetailsHiddenId').value = data.id || '';
                                var modal = new bootstrap.Modal(document.getElementById('maisonDetailsModal'));
                                modal.show();
                        }
                        </script>
                    </div>
                </div>
            </div>
            <!-- Paramètres Section -->
            <div id="section-parametres" class="section-content" style="display:none;">
                <div class="card mb-4 shadow-sm">
                    <div class="card-header bg-primary text-white">
                        <i class="fas fa-cogs me-2"></i><strong>Paramètres</strong>
                    </div>
                    <div class="card-body">
                        <p>Paramètres de l'application à configurer ici...</p>
                        <!-- Ajoutez ici le code de gestion des paramètres -->
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="../asset/js/adm_index.js"></script>
</body>
</html>