<?php
session_start();
require_once(__DIR__ . "/../classe/utilisateurs.php");
require_once(__DIR__ . "/../classe/maison.php");
require_once(__DIR__ . "/../classe/demande_location.php");

$us = new Utilisateur();
$maison = new Maison();
$location = new DemandeLocation();
$id_utilisateur = isset($_SESSION['user_id']) ? $_SESSION['user_id'] : null;
$demandes = [];
if ($id_utilisateur) {
    $demandes = $maison->getMaisonsByUtilisateur($id_utilisateur);
}
$maisons = $maison->getMaisonsApprouvees();
// Compteur pour badge notification
$nbDemandes = is_array($demandes) ? count($demandes) : 0;
$accept=$location-> getDemandesApprouveesPourLocataire($_SESSION['user_id']);
?>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Tableau de bord Locataire</title>
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
        #search-loader { display: none; }
    </style>
</head>
<body>
<div class="container-fluid">
    <div class="row flex-nowrap">
        <!-- Sidebar -->
        <nav id="sidebarMenu" class="col-12 col-md-3 col-lg-2 d-md-block bg-primary sidebar collapse px-0 position-fixed h-100" style="z-index: 1030;">
            <div class="d-flex flex-column align-items-center py-4">
                <img src="../images/logo/logos.avif" class="logo mb-3 rounded-circle" style="width:70px; height:70px; object-fit:cover;" alt="Logo">
                <ul class="nav flex-column w-100">
                    <li class="nav-item mb-2">
                        <a class="nav-link active d-flex align-items-center text-white" href="#" data-section="dashboard">
                            <i class="fas fa-tachometer-alt me-2"></i> Tableau de bord
                        </a>
                    </li>
                    <li class="nav-item mb-2">
                        <a class="nav-link d-flex align-items-center text-white" href="#" data-section="recherche">
                            <i class="fas fa-search me-2"></i> Rechercher une maison
                        </a>
                    </li>
                    <li class="nav-item mb-2 position-relative">
                        <a class="nav-link d-flex align-items-center text-white" href="#" data-section="demandes">
                            <i class="fas fa-list-ol me-2"></i> Mes demandes
                            <span class="notif-badge" id="notifDemandes"><?php echo $nbDemandes; ?></span>
                        </a>
                    </li>
                    <li class="nav-item mb-2">
                        <a class="nav-link d-flex align-items-center text-white" href="#" data-section="contrats">
                            <i class="fas fa-file-signature me-2"></i> Mes contrats/locations
                        </a>
                    </li>
                    <li class="nav-item mt-4">
                        <a class="nav-link text-danger d-flex align-items-center bg-white" href="../logout.php">
                            <i class="fas fa-sign-out-alt me-2"></i> Déconnexion
                        </a>
                    </li>
                </ul>
            </div>
        </nav>
        <!-- Sidebar toggle for mobile -->
        <button class="btn btn-primary d-md-none position-fixed m-2" style="z-index:1040; left:10px; top:10px;" type="button" data-bs-toggle="collapse" data-bs-target="#sidebarMenu" aria-controls="sidebarMenu" aria-expanded="false" aria-label="Toggle navigation" id="sidebarToggle">
            <i class="fas fa-bars"></i>
        </button>
        <!-- Main Content -->
        <main class="col-12 col-md-9 col-lg-10 ms-auto px-3 main-content" style="min-height:100vh;">
            <!-- Tableau de bord -->
            <div class="main-section active" id="dashboard">
                <div class="d-flex justify-content-between align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2 mb-0"><i class="fas fa-home me-2 text-primary"></i>Tableau de bord locataire</h1>
                    <div class="d-flex align-items-center mt-3">
                        <img src="<?php echo isset($_SESSION['user_photo']) ? htmlspecialchars($_SESSION['user_photo']) : 'default_user.png'; ?>" 
                             alt="Photo de profil" 
                             class="rounded-circle me-2" 
                             style="width:40px; height:40px; object-fit:cover;">
                        <span class="fw-bold">
                            <?php echo isset($_SESSION['user_name']) ? htmlspecialchars($_SESSION['user_name']) : 'Locataire'; ?>
                        </span>
                    </div>
                </div>
                <div class="row g-3">
                    <div class="col-12 col-md-6 col-lg-3">
                        <div class="card text-center shadow-sm h-100">
                            <div class="card-body">
                                <i class="fas fa-search fa-2x text-primary mb-2"></i>
                                <h5 class="card-title">Rechercher une maison</h5>
                                <button type="button" class="btn btn-primary mt-2" onclick="showSection('recherche')">Commencer</button>
                            </div>
                        </div>
                    </div>
                    <div class="col-12 col-md-6 col-lg-3">
                        <div class="card text-center shadow-sm h-100">
                            <div class="card-body">
                                <i class="fas fa-list-ol fa-2x text-warning mb-2"></i>
                                <h5 class="card-title">Mes demandes</h5>
                                <button type="button" class="btn btn-warning text-white mt-2" onclick="showSection('demandes')">Voir</button>
                            </div>
                        </div>
                    </div>
                    <div class="col-12 col-md-6 col-lg-3">
                        <div class="card text-center shadow-sm h-100">
                            <div class="card-body">
                                <i class="fas fa-file-signature fa-2x text-success mb-2"></i>
                                <h5 class="card-title">Contrats / Paiements</h5>
                                <button type="button" class="btn btn-success mt-2" onclick="showSection('contrats')">Afficher</button>
                            </div>
                        </div>
                    </div>
                    <div class="col-12 col-md-6 col-lg-3">
                        <div class="card text-center shadow-sm h-100">
                            <div class="card-body">
                                <i class="fas fa-star fa-2x text-info mb-2"></i>
                                <h5 class="card-title">Avis laissés</h5>
                                <button type="button" class="btn btn-info text-white mt-2" onclick="showSection('avis')">Donner un avis</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- Section recherche maison -->
            <div class="main-section" id="recherche">
                <div class="d-flex justify-content-between align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h2 class="h4"><i class="fas fa-search me-2 text-primary"></i>Recherche de maison</h2>
                    <button class="btn btn-outline-secondary" onclick="showSection('dashboard')">Retour</button>
                </div>
                <div class="mb-4">
                    <input type="text" class="form-control" id="searchMaisonInput" placeholder="Rechercher par ville, quartier, prix, etc..." onkeyup="showResult(this.value)">
                </div>
                <div id="search-loader" class="text-center mb-2">
                    <div class="spinner-border text-primary" role="status"><span class="visually-hidden">Chargement...</span></div>
                </div>
                <!-- Résultats AJAX -->
                <div class="col-md-12">
                    <div id="livesearch">
                    </div>
                </div>
                <!-- Les résultats s'affichent ici -->
                <!-- Modal Détails Maison -->
                <script>
                function showResult(str) {
                    var loader = document.getElementById("search-loader");
                    if (loader) loader.style.display = "block";
                    if (str.length==0) {
                        document.getElementById("livesearch").innerHTML="";
                        document.getElementById("livesearch").style.border="0px";
                        if (loader) loader.style.display = "none";
                        return;
                    }
                    var xmlhttp=new XMLHttpRequest();
                    xmlhttp.onreadystatechange=function() {
                        if (this.readyState==4 && this.status==200) {
                            document.getElementById("livesearch").innerHTML=this.responseText;
                            document.getElementById("livesearch").style.border="1px solid #A5ACB2";
                            if (loader) loader.style.display = "none";
                        }
                    }
                    xmlhttp.open("GET","../ajax/recherche_maison.php?q="+encodeURIComponent(str),true);
                    xmlhttp.send();
                }
                </script>
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
                                <form class="d-flex gap-2" method="post" action="../demande/demande_location.php" id="demandeForm">
                                    <input type="hidden" name="maison_id" id="maisonDetailsHiddenId">
                                    <input type="hidden" name="id_utilisateur" id="maisonDetailsHiddenIdUtilisateur" value="<?php echo isset($_SESSION['user_id']) ? htmlspecialchars($_SESSION['user_id']) : ''; ?>">
                                    <button type="submit" class="btn btn-primary" id="commanderBtn">Commander</button>
                                    <button type="button" class="btn btn-warning" id="avisBtn">Envoyer avis</button>
                                </form>
                                <!-- Modal Avis -->
                                <div class="modal fade" id="avisModal" tabindex="-1" aria-labelledby="avisModalLabel" aria-hidden="true">
                                    <div class="modal-dialog">
                                        <div class="modal-content">
                                            <form method="post" action="../avis/avis.php">
                                                <div class="modal-header">
                                                    <h5 class="modal-title" id="avisModalLabel">Envoyer un avis</h5>
                                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Fermer"></button>
                                                </div>
                                                <div class="modal-body">
                                                    <input type="text" name="maison_id" id="avisMaisonId" readonly class="form-control mb-3" style="pointer-events:none;background:#f8f9fa;">
                                                    <input type="text" name="id_utilisateur" id="avisIdUtilisateur" readonly class="form-control mb-3" style="pointer-events:none;background:#f8f9fa;" value="<?php echo isset($_SESSION['user_id']) ? htmlspecialchars($_SESSION['user_id']) : ''; ?>">
                                                    <div class="mb-3">
                                                        <label for="avisNote" class="form-label">Note</label>
                                                        <select class="form-select" id="avisNote" name="note" required>
                                                            <option value="">Choisir une note...</option>
                                                            <option value="1">&#9733; 1/5</option>
                                                            <option value="2">&#9733;&#9733; 2/5</option>
                                                            <option value="3">&#9733;&#9733;&#9733; 3/5</option>
                                                            <option value="4">&#9733;&#9733;&#9733;&#9733; 4/5</option>
                                                            <option value="5">&#9733;&#9733;&#9733;&#9733;&#9733; 5/5</option>
                                                        </select>
                                                    </div>
                                                    <div class="mb-3">
                                                        <label for="avisMessage" class="form-label">Votre message</label>
                                                        <textarea class="form-control" id="avisMessage" name="message" rows="4" required></textarea>
                                                    </div>
                                                </div>
                                                <div class="modal-footer">
                                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
                                                    <button type="submit" class="btn btn-warning">Envoyer</button>
                                                </div>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                                <script>
                                // Séparation du submit et du bouton commander
                                document.getElementById('commanderBtn').onclick = function(e) {
                                    // Laisser le submit du formulaire faire son travail
                                };
                                document.getElementById('avisBtn').onclick = function() {
                                    var maisonId = document.getElementById('maisonDetailsHiddenId').value;
                                    document.getElementById('avisMaisonId').value = maisonId;
                                    var avisModal = new bootstrap.Modal(document.getElementById('avisModal'));
                                    avisModal.show();
                                };
                                </script>
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
                    document.getElementById('maisonDetailsHiddenId').value = data.id || '';
                    var modal = new bootstrap.Modal(document.getElementById('maisonDetailsModal'));
                    modal.show();
                }
                // Ajout de la fonction toggleAnnoncesSection si absente
                function toggleAnnoncesSection() {
                    var section = document.getElementById('section-annonces');
                    if (section) {
                        section.style.display = (section.style.display === 'none' || section.style.display === '') ? 'block' : 'none';
                    }
                }
                </script>
            </div>
            <!-- SECTION DEMANDES -->
            <div class="main-section" id="demandes">
                <div class="d-flex justify-content-between align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h2><i class="fas fa-list-ol me-2 text-primary"></i>Mes demandes</h2>
                    <button class="btn btn-outline-secondary" onclick="showSection('dashboard')">Retour</button>
                </div>
                <!-- Listing demandes envoyées par le locataire -->
                <ul class="list-group mb-3">
                    <?php if (!empty($demandes)): ?>
                        <?php foreach ($demandes as $demande): ?>
                            <li class="list-group-item d-flex justify-content-between gap-3">
                                <div>
                                    <strong>
                                        <?php echo htmlspecialchars($demande['adresse'] ?? 'Maison'); ?> – 
                                        <?php echo htmlspecialchars($demande['prix'] ?? ''); ?> $
                                        <?php echo isset($demande['nombre_de_chambre']) ? htmlspecialchars($demande['nombre_de_chambre']) . ' chambre(s)' : ''; ?>
                                    </strong>
                                    <br>
                                    <span class="small">
                                        Demande envoyée le 
                                        <?php
                                        if (!empty($demande['date']) && strtotime($demande['date']) !== false) {
                                            echo date('d/m/Y', strtotime($demande['date']));
                                        } else {
                                            echo '';
                                        }
                                        ?>
                                    </span>
                                </div>
                                <div>
                                    <?php
                                    if (isset($demande['statut'])) {
                                        if ($demande['statut'] === 'en_attente') {
                                            echo '<span class="badge bg-info">En attente</span>';
                                        } elseif ($demande['statut'] === 'approuvee') {
                                            echo '<span class="badge bg-success">Approuvée – <a href=\"#\" onclick=\"showSection(\'contrats\');return false;\" style=\"color:#155724\">Signer/Payer</a></span>';
                                        } elseif ($demande['statut'] === 'refusee') {
                                            echo '<span class="badge bg-danger">Refusée</span>';
                                        } else {
                                            echo '<span class="badge bg-secondary">'.htmlspecialchars($demande['statut']).'</span>';
                                        }
                                    }
                                    ?>
                                </div>
                            </li>
                        <?php endforeach; ?>
                    <?php else: ?>
                        <li class="list-group-item text-center text-muted">Aucune demande trouvée.</li>
                    <?php endif; ?>
                </ul>
            </div>
            <!-- Section Contrats/Locations -->
            <div class="main-section" id="contrats">
                <div class="d-flex justify-content-between align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h2><i class="fas fa-file-signature me-2 text-success"></i> Mes contrats / Paiements</h2>
                    <button class="btn btn-outline-secondary" onclick="showSection('dashboard')">Retour</button>
                </div>
                <!-- Liste des contrats simulés/démo -->
                <table class="table table-striped mb-4">
                    <thead>
                        <tr>
                            <th>Maison</th>
                            <th>Status</th>
                            <th>Contrat</th>
                            <th>Paiement</th>
                            <th>Avis</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php if (!empty($accept)) : ?>
                                <?php foreach ($accept as $accep) :    ?>
                        <tr>
                            <td><strong><?php echo htmlspecialchars($accep['adresse']).', '. htmlspecialchars($accep['date_demande']); ?>
                            </strong><br><?php echo htmlspecialchars($accep['prix']); ?></td>
                              
                            <td><span class="badge bg-success">En cours</span></td>
                            <td>
                                <form action="../contrat/contrat.php" method="post">
                                    <input type="hidden" name="id_maison" value="<?php echo htmlspecialchars($accep['id_maison']); ?>">
                                    <input type="hidden" name="id_utilisateur" value="<?php echo htmlspecialchars($_SESSION['user_id']); ?>">
                                    <button type="submit" class="btn btn-outline-secondary btn-sm me-2">Voir signer <i class="fas fa-pen"></i></button>
                                </form>
                            </td>
                            <td>
                                <form method="post" onsubmit="alert('Paiement effectué !'); return false;">
                                    <button class="btn btn-warning btn-sm">Payer</button>
                                </form>
                            </td>
                            <td>
                                <button class="btn btn-outline-primary btn-sm" onclick="showModal('modAvisMaison')">Laisser un avis</button>
                            </td>
                               <?php endforeach; ?>
                            <?php else: ?>
                                <div class="col-12">
                                    <div class="alert alert-info text-center">Aucune annonce trouvée.</div>
                                </div>
                            <?php endif; ?>
                        </tr>
                        <tr>
                            <td><strong>Appart cosy, Lyon</strong><br>(Montant : 550 €)</td>
                            <td><span class="badge bg-secondary">Clôturé</span></td>
                            <td>
                                <span>Signé</span>
                            </td>
                            <td>
                                <span>Effectué</span>
                            </td>
                            <td>
                                <button class="btn btn-outline-primary btn-sm" onclick="showModal('modAvisMaison')">Laisser un avis</button>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <!-- Section Laisser un avis globale -->
            <div class="main-section" id="avis">
                <div class="d-flex justify-content-between align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h2><i class="fas fa-star me-2 text-warning"></i>Laisser un avis</h2>
                    <button class="btn btn-outline-secondary" onclick="showSection('dashboard')">Retour</button>
                </div>
                <div>
                    <!-- Plusieurs avis, recommandations à la flexibilité -->
                    <button class="btn btn-primary mb-2" data-bs-toggle="modal" data-bs-target="#modAvisMaison">Donner un avis sur une location</button>
                    <div><!-- Afficher les avis déjà laissés ici (dummy/demo) --></div>
                </div>
            </div>
        </main>
    </div>
</div>

<!-- MODALE Laisser un AVIS -->
<div class="modal fade" id="modAvisMaison" tabindex="-1" aria-labelledby="modAvisMaisonLabel" aria-hidden="true">
  <div class="modal-dialog">
    <form class="modal-content" onsubmit="alert('Avis envoyé&nbsp;!');$('#modAvisMaison').modal('hide');return false;">
      <div class="modal-header">
        <h5 class="modal-title" id="modAvisMaisonLabel">Laisser un avis sur la maison</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body">
        <p>
          <label for="notation">
            Note :</label>
          <select name="notation" id="notation" class="form-select" required>
            <option value="">--</option>
            <option>⭐</option>
            <option>⭐⭐</option>
            <option>⭐⭐⭐</option>
            <option>⭐⭐⭐⭐</option>
            <option>⭐⭐⭐⭐⭐</option>
          </select>
        </p>
        <div class="mb-3">
          <label for="comment" class="form-label">Votre avis</label>
          <textarea class="form-control" name="comment" id="comment" required placeholder="Exprimez-vous.."></textarea>
        </div>
      </div>
      <div class="modal-footer">
        <button class="btn btn-primary" type="submit">Envoyer</button>
        <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Fermer</button>
      </div>
    </form>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function showSection(section) {
        document.querySelectorAll('.main-section').forEach(s => s.classList.remove('active'));
        document.getElementById(section).classList.add('active');
        document.querySelectorAll('.sidebar .nav-link').forEach(link => link.classList.remove('active'));
        document.querySelector('.sidebar .nav-link[data-section="'+section+'"]')?.classList.add('active');
    }
    document.querySelectorAll('.sidebar .nav-link[data-section]').forEach(link => {
        link.addEventListener('click', function(e) {
            e.preventDefault();
            showSection(this.getAttribute('data-section'));
        });
    });

    // Pour ouvrir une modale par ID en js natif+bootstrap
    function showModal(id){
      var modalDemo=new bootstrap.Modal(document.getElementById(id));
      modalDemo.show();
    }
</script>
</body>
</html>
