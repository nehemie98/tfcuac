

<?php
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\SMTP;
use PHPMailer\PHPMailer\Exception;

session_start();
require_once(__DIR__ . "/../classe/utilisateurs.php");

// Inclure PHPMailer via Composer autoload
require_once(__DIR__ . '/../vendor/autoload.php');

$us = new Utilisateur();
$message = '';

if (isset($_POST['envoyer'])) {
    $path = "../images/inscription/";
    $imageName = $_FILES["image"]["name"] ?? '';
    $imageTmp = $_FILES["image"]["tmp_name"] ?? '';
    $imageSize = $_FILES["image"]["size"] ?? 0;
    $image = $path . basename($imageName);
    $type = strtolower(pathinfo($image, PATHINFO_EXTENSION));
    $uploadOk = 1;

    // Vérifier si un fichier a été envoyé
    if (!$imageTmp || $imageName === '') {
        $message .= "Veuillez sélectionner une image.<br>";
        $uploadOk = 0;
    }

    // Vérifier si le fichier est une image
    if ($uploadOk && getimagesize($imageTmp) === false) {
        $message .= "Le fichier n'est pas une image.<br>";
        $uploadOk = 0;
    }

    // Vérifier la taille du fichier
    if ($uploadOk && $imageSize > 15728640) {
        $message .= "Désolé, votre fichier est trop volumineux (maximum 15 Mo).<br>";
        $uploadOk = 0;
    }

    // Autoriser certains formats de fichier
    if ($uploadOk && !in_array($type, ["jpg", "png", "jpeg", "gif"])) {
        $message .= "Désolé, seuls les fichiers JPG, JPEG, PNG et GIF sont autorisés.<br>";
        $uploadOk = 0;
    }

    // Upload de l'image
    if ($uploadOk) {
        if (move_uploaded_file($imageTmp, $image)) {
            $image = basename($imageName);
        } else {
            $message .= "Désolé, une erreur s'est produite lors du téléchargement de votre fichier.<br>";
            $uploadOk = 0;
        }
    } else {
        $message .= "Désolé, votre fichier n'a pas été téléchargé.<br>";
    }

    $nom = htmlspecialchars($_POST['nom'] ?? '');
    $mail = filter_var($_POST['email'] ?? '', FILTER_SANITIZE_EMAIL);
    $role = htmlspecialchars($_POST['role'] ?? '');

    // Validation simple des champs
    if ($uploadOk) {
        try {
            if (!empty($nom) && !empty($mail) && !empty($role) && !empty($image)) {
                // Vérifier si l'utilisateur existe déjà (optionnel)
                $password = $us->getpas(); // Générer un mot de passe aléatoire
                if ($us->inscrire($nom, $mail, $role, $image, $password) === true) {
                    // Envoi du mail avec PHPMailer
                    $mail_subject = "Votre inscription sur notre site";
                    $mail_message = "Bonjour $nom,\n\nVotre inscription a été prise en compte.\nVoici votre mot de passe :\n\n----------------------\n$password\n----------------------\n\nMerci de votre confiance.";

                    // Configuration de PHPMailer
                    $mailPHPMailer = new PHPMailer(true);
                    try {
                        $mailPHPMailer->isSMTP();
                        $mailPHPMailer->Host = 'smtp.gmail.com';
                        $mailPHPMailer->SMTPAuth = true;
                        $mailPHPMailer->Port = 587;
                        $mailPHPMailer->Username = 'nehemiekasereka2003@gmail.com';
                        $mailPHPMailer->Password = 'naya kwtc bfow qozd';
                        $mailPHPMailer->SMTPSecure = PHPMailer::ENCRYPTION_STARTTLS;
                        $mailPHPMailer->setFrom('nehemiekasereka2003@gmail.com', 'ACCIAC');
                        $mailPHPMailer->addAddress($mail, $nom);

                        $mailPHPMailer->Subject = $mail_subject;
                        $mailPHPMailer->Body = $mail_message;
                        $mailPHPMailer->CharSet = 'UTF-8';

                        $mailPHPMailer->send();
                    } catch (Exception $e) {
                        $message .= "Le mail n'a pas pu être envoyé. Erreur: " . htmlspecialchars($mailPHPMailer->ErrorInfo) . "<br>";
                    }

                    header("Location: ../index.php");
                    exit();
                } else {
                    $message .= "Erreur lors de l'enregistrement.<br>";
                }
            } else {
                $message .= "Veuillez remplir tous les champs obligatoires.<br>";
            }
        } catch (Throwable $th) {
            $message .= "Une erreur est survenue : " . htmlspecialchars($th->getMessage());
        }
    }
}

if (isset($_POST['conxx'])) {
    $nom = htmlspecialchars($_POST['nom'] ?? '');
    $password = htmlspecialchars($_POST['password'] ?? '');

    $co = $us->connexion($nom, $password);
    if (is_array($co)) {
        $_SESSION['user'] = $co;
        $_SESSION['user_id'] = $co['id'];
        $_SESSION['nom'] = $co['nom'];
        $_SESSION['photo'] = $co['image_profile'];
        $_SESSION['connected'] = true;
        if ($co['role'] === 'admin') {
            header("Location: ../admin/adm_index.php");
        } elseif ($co['role'] === 'proprietaire') {
            header("Location: ../proprietaire/pr_index.php");
        } elseif ($co['role'] === 'locataire') {
            header("Location: ../locataire/lc_index.php");
        }
        exit();
    } elseif ($co === false) {
        $sms = "Nom d'utilisateur ou mot de passe incorrect";
        header("Location: ?rep=" . urlencode($sms));
        exit();
    }
}
?>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Connexion / Inscription</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="../asset/css/login.css">
</head>
<body>
<div class="container" id="login-form">
     <div class="imgs">
        <img src="../images/logo/logos.avif" alt="logo">
    </div>
    <?php if (!empty($_GET['rep'])): ?>
        <div class="alert alert-danger"><?= htmlspecialchars($_GET['rep']) ?></div>
    <?php endif; ?>
    <form action="" method="post" autocomplete="off">
        <h2>Connexion</h2>
        <input type="text" placeholder="nom" required name="nom" autocomplete="off">
        <input type="password" placeholder="Mot de passe" required name="password" autocomplete="off">
        <div>
            <button class="confirm-btn" name="conxx">Confirmer</button>
        </div>
    </form>
    <br>
    <div>
        <button class="signup-btn" onclick="showSignupForm()">S'inscrire</button>
    </div>
</div>

<div class="container containers hidden" id="signup-form">
    <div class="imgs">
        <img src="../images/logo/logos.avif" alt="logo">
    </div>
    <h2>Inscription</h2>
    <?php if (!empty($message)): ?>
        <div class="alert alert-danger"><?= $message ?></div>
    <?php endif; ?>
    <form action="" method="post" enctype="multipart/form-data" class="row g-2" autocomplete="off">
        <div class="col-md-6">
            <label for="nom" class="form-label">Nom</label>
            <input type="text" name="nom" id="nom" class="form-control" placeholder="Nom" required autocomplete="off">
        </div>
        <div class="col-md-6">
            <label for="email" class="form-label">Email</label>
            <input type="email" name="email" id="email" class="form-control" placeholder="Email" required autocomplete="off">
        </div>
        <div class="col-md-6">
            <label for="role" class="form-label">Role</label>
            <select name="role" id="role" class="form-select" required>
                <option value="" disabled selected>Choisir...</option>
                <option value="proprietaire">Propriétaire</option>
                <option value="locataire">Locataire</option>
                <option value="admin">Admin</option>
            </select>
        </div>
        <div class="col-md-6">
            <label for="image" class="form-label">Image</label>
            <input type="file" name="image" id="image" class="form-control" required>
        </div>
        <div class="col-12 text-center">
            <button type="submit" class="confirm-btn" name="envoyer">Envoyer</button>
        </div>
    </form>
    <br>
    <div>
        <button class="signup-btn" onclick="cancelSignup()">Annuler</button>
    </div>
</div>

<script src="../asset/js/login.js"></script>
</body>
</html>
