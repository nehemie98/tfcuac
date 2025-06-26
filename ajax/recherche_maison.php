<?php 
require_once("../connexion/connexion.php");
 $con = new connexion();
 $conn = $con->getcon();
$q = htmlspecialchars($_GET['q']);

if (empty($q)) {
    echo '<div class="alert alert-warning">Veuillez entrer un terme de recherche.</div>';
    exit;
}
$sql = $conn->prepare("SELECT * FROM `maison` WHERE (prix LIKE ? OR nombre_de_chambre LIKE ? OR adresse LIKE ?) AND statut = 'Disponible' AND validite = 'approuver'");
$sql->execute(array($q.'%', $q.'%', $q.'%'));
$result = $sql->fetchAll(PDO::FETCH_ASSOC);
?>

<div class="row g-3">
    <?php if (!empty($result)) : ?>
        <?php foreach ($result as $maison) : 
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

<!-- Le reste du code (modals, scripts...) ne change pas -->
