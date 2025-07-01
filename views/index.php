  <?php
  session_start();
  require_once("../classe/maison.php");

  $mais = new Maison();
  $maisons = $mais->getMaisonsApprouvees();
  ?>
  <!DOCTYPE html>
  <html lang="fr">
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Accueil - Location Maisons</title>
    <link rel="icon" type="image/png" href="../images/logo/logos.avif">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link href="https://fonts.googleapis.com/css?family=Montserrat:400,700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="style.css">
  </head>
  <body>
  <header>
    <div class="navbar">
      <div class="logo">
        <img src="../images/logo/logos.avif" alt="Logo Location Maisons" style="height:40px;vertical-align:middle;margin-right:8px;border-radius:8px;">
        ACCIAC Butembo
      </div>
      <button class="menu-toggle" aria-label="Menu"><i class="fas fa-bars"></i></button>
      <nav>
        <ul class="menu">
          <li><a href="index.php"><i class="fas fa-home"></i> Accueil</a></li>
          <li><a href="#" data-bs-toggle="modal" data-bs-target="#searchModal"><i class="fas fa-search"></i> Rechercher</a></li>
          <li><a href="#" onclick="toggleAnnoncesSection();return false;"><i class="fas fa-list"></i> Annonces</a></li>
          <?php if (isset($_SESSION['nom']) && !empty($_SESSION['nom'])): ?>
            <?php
              // Redirige vers le bon tableau de bord selon le rôle
              $dashboardUrl = '#';
              if (isset($_SESSION['role']) && !empty($_SESSION['role'])) {
                switch ($_SESSION['role']) {
                  case 'admin':
                    $dashboardUrl = '../admin/adm_index.php';
                    break;
                  case 'locataire':
                    $dashboardUrl = '../locataire/lc_index.php';
                    break;
                  case 'proprietaire':
                    $dashboardUrl = '../proprietaire/pr_index.php';
                    break;
                }
              }
            ?>
            <li><a href="<?php echo $dashboardUrl; ?>"><i class="fas fa-user"></i> Mon Compte</a></li>
          <?php else: ?>
            <li><a href="../page/login.php"><i class="fas fa-user"></i> Mon Compte</a></li>
          <?php endif; ?>
          
          <li><a href="#"><i class="fas fa-phone"></i> Contact</a></li>
          <?php if (empty($_SESSION['nom'])): ?>
            <li><a href="../page/login.php"><i class="fas fa-sign-in-alt"></i> Connexion</a></li>
          <?php else: ?>
            <li><a href="../page/logout.php"><i class="fas fa-sign-out-alt"></i> Déconnexion</a></li>
          <?php endif; ?>
        </ul>
      </nav>
    </div>
  </header>
  <main>
    <h1>Bienvenue sur Location Maisons</h1>
    <p>
      Trouvez facilement une maison à louer selon vos critères.<br>
      Parcourez les annonces, contactez les propriétaires et gérez vos recherches simplement et rapidement.
    </p>

    <div class="row g-3">
      <?php if (!empty($maisons)) : ?>
        <?php foreach ($maisons as $maison) : 
          $photo = !empty($maison['photo']) ? '../images/maison/' . htmlspecialchars($maison['photo']) : '../images/maison/default.jpg';
          $id_maison = isset($maison['id_maison']) ? $maison['id_maison'] : '';
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
                    "id" => $id_maison,
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
            <form class="d-flex gap-2" method="post" action="../demande/demande_location.php">
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
                          <option value="1">&#9733; <span style="color:rgb(177, 141, 35);">1/5</span></option>
                          <option value="2">&#9733;&#9733; <span style="color:rgb(92, 172, 46);">2/5</span></option>
                          <option value="3">&#9733;&#9733;&#9733; <span style="color:rgb(78, 67, 32);">3/5</span></option>
                          <option value="4">&#9733;&#9733;&#9733;&#9733; <span style="color:rgb(61, 8, 255);">4/5</span></option>
                          <option value="5">&#9733;&#9733;&#9733;&#9733;&#9733; <span style="color:rgb(112, 35, 131);">5/5</span></option>
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
            document.getElementById('commanderBtn').onclick = function() {
              var maisonId = document.getElementById('maisonDetailsHiddenId').value;
              if(maisonId) {
                window.location.href = 'demande_de_location.php?maison_id=' + encodeURIComponent(maisonId);
              }
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

    <!-- Bouton de recherche -->
    <a href="#" class="cta-btn" data-bs-toggle="modal" data-bs-target="#searchModal">
      <i class="fas fa-search"></i> Rechercher une maison
    </a>

    <!-- Modal de recherche -->
    <div class="modal fade" id="searchModal" tabindex="-1" aria-labelledby="searchModalLabel" aria-hidden="true">
      <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content">
          <form onsubmit="event.preventDefault(); /* Ajoutez ici votre logique de recherche */">
            <div class="modal-header">
              <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Fermer"></button>
            </div>
            <div class="main-section" id="recherche">
                <div class="d-flex justify-content-between align-items-center pt-3 pb-2 mb-4 border-bottom">
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
                
            </div>
          </form>
        </div>
      </div>
    </div>
  </main>
  <footer>
    &copy; <?php echo date('Y'); ?> Location Maisons. Tous droits réservés.
  </footer>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
  <script src="script.js"></script>
  </body>
  </html>
