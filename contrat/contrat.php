<?php
require_once '../classe/contrat.php';
require_once '../classe/paiement.php';
require_once '../classe/maison.php';

$contrat = new Contrat();
$paiement = new Paiement();
$maison = new Maison();

// Récupération des ID maison et utilisateur
$id_maison = isset($_GET['id_maison']) ? intval($_GET['id_maison']) : (isset($_POST['id_maison']) ? intval($_POST['id_maison']) : 0);
$id_utilisateur = isset($_GET['id_utilisateur']) ? intval($_GET['id_utilisateur']) : (isset($_POST['id_utilisateur']) ? intval($_POST['id_utilisateur']) : 0);

if (!$id_maison || !$id_utilisateur) {
    header("Location: ../locataire/lc_index.php?error=" . urlencode("Paramètres manquants."));
    exit();
}

// Soumission du formulaire
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['payer'])) {
    $montant = floatval($_POST['montant']);
    $dated = date('Y-m-d'); // date de début aujourd'hui
    $statut = "Payé";
    $date_paiement = $dated;

    // 1. Récupérer le prix du loyer
    $prix_maison = $maison->getPrixMaison($id_maison);
    if (!$prix_maison || $prix_maison <= 0) {
        header("Location: ../locataire/lc_index.php?error=" . urlencode("Prix maison invalide."));
        exit();
    }

    // 2. Calcul de la date de fin
    $jours = 0;
    $reste = $montant;
    $date_courante = new DateTime($dated);
    while ($reste > 0) {
        $jours_dans_mois = (int)$date_courante->format('t');
        if ($reste >= $prix_maison) {
            $jours += $jours_dans_mois;
            $reste -= $prix_maison;
            $date_courante->modify('first day of next month');
        } else {
            $jours += intval(($reste / $prix_maison) * $jours_dans_mois);
            $reste = 0;
        }
    }
    $datef = date('Y-m-d', strtotime("$dated +$jours days"));

    // 3. Enregistrer le contrat
    $contrat->ajoutercontrat($dated, $datef, $id_utilisateur, $id_maison);

    // 4. Récupérer le dernier id_contrat inséré (pour cet utilisateur et maison)
    $id_contrat = $contrat->getDernierContrat($id_utilisateur, $id_maison, $dated); // à créer

    if ($id_contrat) {
        // 5. Enregistrement du paiement
        $paiement_enregistre = $paiement->ajouterPaiement($date_paiement, $montant, $statut, $id_contrat);
        if ($paiement_enregistre) {
            header("Location: cynetpay.php?mont=" . urlencode($montant) . "&id_mont=" );
            exit();
        } else {
            header("Location: ../locataire/lc_index.php?error=" . urlencode("Échec enregistrement paiement."));
            exit();
        }
    } else {
        header("Location: ../locataire/lc_index.php?error=" . urlencode("Contrat non trouvé."));
        exit();
    }
}
?>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Paiement Contrat</title>
  <link rel="icon" type="image/png" href="../images/logo/logos.avif">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

  <div class="container py-5">
    <div class="row justify-content-center">
      <div class="col-md-6">

        <div class="card shadow">
          <div class="card-header bg-primary text-white text-center">
            <h4>Paiement du contrat</h4>
          </div>
          <div class="card-body">
            <form action="" method="post">
              <!-- Champs cachés pour conserver les ID -->
              <input type="hidden" name="id_maison" value="<?= $id_maison ?>">
              <input type="hidden" name="id_utilisateur" value="<?= $id_utilisateur ?>">

              <div class="mb-3">
                <label for="montant" class="form-label">Montant à payer</label>
                <input type="number" step="0.01" name="montant" id="montant" class="form-control" required>
              </div>

              <button type="submit" name="payer" class="btn btn-success w-100">Payer</button>
            </form>
          </div>
        </div>

      </div>
    </div>
  </div>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
