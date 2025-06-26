<?php
require_once(__DIR__ . '/../classe/demande_location.php');
$demande = new DemandeLocation();

if (isset($_POST['accepter']) || isset($_POST['refuser'])) {
    $action = isset($_POST['accepter']) ? 'accepter' : 'refuser';
    $id_demande = $_POST['id_demande'] ?? null;

    if ($id_demande === null) {
        echo "ID de demande manquant.";
        exit;
    }

    $dem = $demande->traiterDemande($id_demande, $action);
    if ($dem) {
        $msg = urlencode("Votre traitement de la demande a été envoyé");
        header("Location: pr_index.php?msg=$msg");
        exit();
    }
}
?>
