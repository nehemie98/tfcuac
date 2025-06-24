<?php
require_once '../classe/avis.php'; // Assurez-vous que le chemin est correct

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Récupérer les données du formulaire
    $note = $_POST['note'] ?? '';
    $commentaire = $_POST['message'] ?? '';
    $id_utilisateur = $_POST['id_utilisateur'] ?? '';
    $id_maison = $_POST['maison_id'] ?? '';

    // Créer une instance de la classe Avis
    $avis = new Avis();

    // Appeler la méthode ajouteravis() avec les bons paramètres
    $resultat = $avis->ajouterAvis($note, $commentaire, $id_utilisateur, $id_maison);

    if ($resultat) {
        // Rediriger vers la page d'accueil avec un message de succès
        // Assurez-vous que la page d'accueil est correcte
       header("Location: ../views/index.php?message=Votre avis a été ajouté avec succès.");
        exit;
    } else {
        header("Location: ../views/index.php?error=Erreur lors de l'ajout de votre avis.");
        exit;
    }
}
?>
