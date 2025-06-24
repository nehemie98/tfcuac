<?php
session_start();
require_once(__DIR__ . "/../classe/utilisateurs.php");
require_once(__DIR__ . "/../classe/maison.php");
$us = new Utilisateur();
$maison = new Maison();
$id_utilisateur = isset($_SESSION['user_id']) ? $_SESSION['user_id'] : null;
$demandes = [];
if ($id_utilisateur) {
    $demandes = $maison->getMaisonsByUtilisateur($id_utilisateur);
}
?>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Tableau de bord Locataire</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
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
                            <span class="notif-badge">2</span>
                        </a>
                    </li>
                    <li class="nav-item mb-2">
                        <a class="nav-link d-flex align-items-center text-white" href="#" data-section="contrats">
                            <i class="fas fa-file-signature me-2"></i> Mes contrats/locations
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
                <form method="get" action="#maisonsResults" class="mb-4">
                    <div class="row g-2">
                        <div class="col-md-4">
                            <input type="text" class="form-control" name="motcle" placeholder="Ville, quartier, ..." />
                        </div>
                        <div class="col-md-3">
                            <input type="number" class="form-control" name="min_prix" placeholder="Prix min" />
                        </div>
                        <div class="col-md-3">
                            <input type="number" class="form-control" name="max_prix" placeholder="Prix max" />
                        </div>
                        <div class="col-md-2">
                            <button class="btn btn-primary w-100">Rechercher</button>
                        </div>
                    </div>
                </form>
                <!-- Résultats (exemple statique pour la démo) -->
                <div class="row" id="maisonsResults">
                    <!-- Cards maisons test -->
                    <div class="col-md-4 mb-3">
                        <div class="card shadow">
                            <img src="maison1.jpg" class="card-img-top" alt="Maison 1">
                            <div class="card-body">
                                <h5 class="card-title">Appartement spacieux à Lyon</h5>
                                <p>550 € / mois <br>2 chambres, quartier Part-Dieu</p>
                                <div class="d-flex gap-2">
                                    <form method="post" action="#" onsubmit="alert('Notification envoyée !'); return false;">
                                        <input type="hidden" name="maison_id" value="101">
                                        <button type="submit" class="btn btn-success">Demander à louer</button>
                                    </form>
                                    <button type="button" class="btn btn-outline-primary" onclick="showMaisonDetail('maison1')">Voir le détail</button>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- Autres maisons en démo/simple -->
                    <div class="col-md-4 mb-3">
                        <div class="card shadow">
                            <img src="maison2.jpg" class="card-img-top" alt="Maison 2">
                            <div class="card-body">
                                <h5 class="card-title">Studio moderne à Bordeaux</h5>
                                <p>420 € / mois <br> Bonne proximité transports.</p>
                                <div class="d-flex gap-2">
                                    <form method="post" action="#" onsubmit="alert('Notification envoyée !'); return false;">
                                        <input type="hidden" name="maison_id" value="102">
                                        <button type="submit" class="btn btn-success">Demander à louer</button>
                                    </form>
                                    <button type="button" class="btn btn-outline-primary" onclick="showMaisonDetail('maison2')">Voir le détail</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- Fin Résultats -->
            </div>

            <!-- Modal Détail Maison -->
            <div class="modal fade" id="modalMaisonDetail" tabindex="-1" aria-labelledby="modalMaisonDetailLabel" aria-hidden="true">
              <div class="modal-dialog modal-lg modal-dialog-centered">
                <div class="modal-content">
                  <div class="modal-header">
                    <h5 class="modal-title" id="modalMaisonDetailLabel">Détail de la maison</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                  </div>
                  <div class="modal-body">
                    <div class="row">
                      <div class="col-md-5" id="detailMaisonImg">
                        <!-- Image maison -->
                      </div>
                      <div class="col-md-7" id="detailMaisonInfos">
                        <!-- Infos maison -->
                      </div>
                    </div>
                  </div>
                  <div class="modal-footer">
                    <form method="post" action="#" id="formDemandeLocation" onsubmit="alert('Notification envoyée !');$('#modalMaisonDetail').modal('hide');return false;">
                      <input type="hidden" name="maison_id" id="modalMaisonId" value="">
                      <button type="submit" class="btn btn-success">Demander la location maintenant</button>
                    </form>
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Fermer</button>
                  </div>
                </div>
              </div>
            </div>

            <script>
            // Données de démo pour les maisons
            const maisonsDemo = {
                maison1: {
                    id: 101,
                    titre: "Appartement spacieux à Lyon",
                    prix: "550 € / mois",
                    chambres: "2 chambres",
                    quartier: "Part-Dieu",
                    description: "Bel appartement lumineux, proche de toutes commodités, cuisine équipée, balcon.",
                    image: "maison1.jpg"
                },
                maison2: {
                    id: 102,
                    titre: "Studio moderne à Bordeaux",
                    prix: "420 € / mois",
                    chambres: "1 pièce",
                    quartier: "Proximité transports",
                    description: "Studio rénové, idéal étudiant ou jeune actif, accès tramway, commerces à pied.",
                    image: "maison2.jpg"
                }
            };

            function showMaisonDetail(maisonKey) {
                const maison = maisonsDemo[maisonKey];
                if (!maison) return;
                document.getElementById('modalMaisonDetailLabel').textContent = maison.titre;
                document.getElementById('detailMaisonImg').innerHTML = `<img src="${maison.image}" alt="${maison.titre}" class="img-fluid rounded shadow">`;
                document.getElementById('detailMaisonInfos').innerHTML = `
                    <h4>${maison.titre}</h4>
                    <p><strong>Prix :</strong> ${maison.prix}</p>
                    <p><strong>Chambres :</strong> ${maison.chambres}</p>
                    <p><strong>Quartier :</strong> ${maison.quartier}</p>
                    <p>${maison.description}</p>
                `;
                document.getElementById('modalMaisonId').value = maison.id;
                var modal = new bootstrap.Modal(document.getElementById('modalMaisonDetail'));
                modal.show();
            }
            </script>
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
                                        <?php echo htmlspecialchars($demande['prix'] ?? ''); ?> €
                                        <?php echo isset($demande['nombre_de_chambre']) ? htmlspecialchars($demande['nombre_de_chambre']) . ' chambre(s)' : ''; ?>
                                    </strong>
                                    <br>
                                    <span class="small">
                                        Demande envoyée le 
                                        <?php echo isset($demande['date_demande']) ? date('d/m/Y', strtotime($demande['date_demande'])) : ''; ?>
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
                        <tr>
                            <td><strong>Studio ludique, Bordeaux</strong><br>(Montant : 420 €)</td>
                            <td><span class="badge bg-success">En cours</span></td>
                            <td>
                                <button class="btn btn-outline-secondary btn-sm me-2">Voir signer <i class="fas fa-pen"></i></button>
                            </td>
                            <td>
                                <form method="post" onsubmit="alert('Paiement effectué !'); return false;">
                                    <button class="btn btn-warning btn-sm">Payer</button>
                                </form>
                            </td>
                            <td>
                                <button class="btn btn-outline-primary btn-sm" onclick="showModal('modAvisMaison')">Laisser un avis</button>
                            </td>
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
                    <!-- multiple avis, recommandations à la flexibilité -->
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
