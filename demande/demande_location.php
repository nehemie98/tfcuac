<?php
require_once '../classe/demande_location.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $id_utilisateur = isset($_POST['id_utilisateur']) ? intval($_POST['id_utilisateur']) : 0;
    $id_maison = isset($_POST['maison_id']) ? intval($_POST['maison_id']) : 0;

    // Instanciation de la classe DemandeLocation
    $demandeLocation = new DemandeLocation();

    if ($demandeLocation->ajouterDemande($id_utilisateur, $id_maison)) {
        $message = "Demande ajoutée avec succès.";
        header("Location: ../views/index.php?message=" . urlencode($message));
        exit();
    } else {
        $message = "Erreur lors de l'ajout de la demande.";
        header("Location: ../views/index.php?error=" . urlencode($message));
        exit();
    }
}
?>
