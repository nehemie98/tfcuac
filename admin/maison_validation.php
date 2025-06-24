<?php
require_once '../classe/maison.php'; // Inclure la classe Maisons

// Vérifier la méthode et la présence des paramètres attendus
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['maison_id'], $_POST['validite'])) {
    // Sécuriser les entrées
    $maison_id = intval($_POST['maison_id']);
    $validite = htmlspecialchars($_POST['validite']);

    // Instancier la classe Maisons (ajustez si besoin de passer $db)
    $maisons = new Maison();

    // Appeler la méthode de validation
    $result = $maisons->valider($maison_id, $validite);

    if ($result) {
        header("Location: adm_index.php?message=Maison validée avec succès");
        exit;
    } else {
        header("Location: adm_index.php?error=Erreur lors de la validation de la maison");
        exit;
    }
} else {
    // Redirection si accès direct ou paramètres manquants
    header("Location: adm_index.php?error=Paramètres invalides");
    exit;
}
?>