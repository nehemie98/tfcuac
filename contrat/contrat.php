<?php
require_once '../classe/contrat.php';
$contrat = new Contrat();
if(isset($_POST['id_maison']) AND isset($_POST['id_utilisateur'])){
    
    
    $id_maison = intval($_POST['id_maison']);
    $id_utilisateur = intval($_POST['id_utilisateur']);
if(isset($_POST['envoyer'])){
    extract($_POST);
    $dated=htmlspecialchars($datedb);
    $datef=htmlspecialchars($datefi);
    if($contrat->ajoutercontrat($dated, $datef, $id_utilisateur, $id_maison)){
        $message = "Demande ajoutée avec succès.";
        header("Location: ../views/index.php?message=" . urlencode($message));
        exit();
    } else {
        $message = "Erreur lors de l'ajout de la demande.";
        header("Location: ../views/index.php?error=" . urlencode($message));
        exit();
    }

}
    
} else {
    header("Location: ../views/index.php?error=" . urlencode("Paramètres manquants."));
    exit();

}
 ?>
 <!DOCTYPE html>
 <html lang="en">
 <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="icon" type="image/png" href="../images/logo/logos.avif">
 </head>
 <body>
    <form action="" method="post">
        <input type="date" name="datedb" id="">
        <input type="date" name="datefi" id="">
        <button name="envoyer">Envoyer</button>
    </form>
 </body>
 </html>