warning: in the working copy of 'composer.lock', LF will be replaced by CRLF the next time Git touches it
warning: in the working copy of 'vendor/autoload.php', LF will be replaced by CRLF the next time Git touches it
warning: in the working copy of 'vendor/composer/ClassLoader.php', LF will be replaced by CRLF the next time Git touches it
warning: in the working copy of 'vendor/composer/InstalledVersions.php', LF will be replaced by CRLF the next time Git touches it
warning: in the working copy of 'vendor/composer/LICENSE', LF will be replaced by CRLF the next time Git touches it
warning: in the working copy of 'vendor/composer/autoload_classmap.php', LF will be replaced by CRLF the next time Git touches it
warning: in the working copy of 'vendor/composer/autoload_namespaces.php', LF will be replaced by CRLF the next time Git touches it
warning: in the working copy of 'vendor/composer/autoload_psr4.php', LF will be replaced by CRLF the next time Git touches it
warning: in the working copy of 'vendor/composer/autoload_real.php', LF will be replaced by CRLF the next time Git touches it
warning: in the working copy of 'vendor/composer/autoload_static.php', LF will be replaced by CRLF the next time Git touches it
warning: in the working copy of 'vendor/composer/installed.json', LF will be replaced by CRLF the next time Git touches it
warning: in the working copy of 'vendor/composer/installed.php', LF will be replaced by CRLF the next time Git touches it
warning: in the working copy of 'vendor/composer/platform_check.php', LF will be replaced by CRLF the next time Git touches it
[1mdiff --git a/admin/adm_index.php b/admin/adm_index.php[m
[1mindex 33d705e..6cc53cd 100644[m
[1m--- a/admin/adm_index.php[m
[1m+++ b/admin/adm_index.php[m
[36m@@ -31,6 +31,7 @@[m [m$maisons = $mais->getMaisons();[m
     <title>Tableau de bord Administrateur</title>[m
     <meta name="viewport" content="width=device-width, initial-scale=1">[m
     <!-- Bootstrap 5 CDN -->[m
[32m+[m[32m     <link rel="icon" type="image/png" href="../images/logo/logos.avif">[m
     <link rel="stylesheet" href="../asset/css/adm_index.css">[m
     <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">[m
     <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">[m
[1mdiff --git a/classe/demande_location.php b/classe/demande_location.php[m
[1mindex 4682e06..d3836bc 100644[m
[1m--- a/classe/demande_location.php[m
[1m+++ b/classe/demande_location.php[m
[36m@@ -1,5 +1,11 @@[m
 <?php[m
[32m+[m[32muse PHPMailer\PHPMailer\PHPMailer;[m
[32m+[m[32muse PHPMailer\PHPMailer\Exception;[m
[32m+[m
 require_once("../connexion/connexion.php");[m
[32m+[m[32mrequire_once("../classe/maison.php");[m
[32m+[m[32mrequire_once("../classe/utilisateurs.php");[m
[32m+[m[32mrequire_once(__DIR__ . '/../vendor/autoload.php');[m
 [m
 class DemandeLocation[m
 {[m
[36m@@ -14,72 +20,227 @@[m [mclass DemandeLocation[m
 [m
     public function ajouterDemande($id_utilisateur, $id_maison)[m
     {[m
[31m-        $query = "INSERT INTO " . $this->table . " (date, statut, id_utilisateur, id_maison)[m
[32m+[m[32m        $query = "INSERT INTO {$this->table} (date, statut, id_utilisateur, id_maison)[m
                   VALUES (NOW(), 'en_attente', :id_utilisateur, :id_maison)";[m
         $stmt = $this->conn->prepare($query);[m
[31m-        $stmt->bindParam(":id_utilisateur", $id_utilisateur);[m
[31m-        $stmt->bindParam(":id_maison", $id_maison);[m
[31m-[m
[32m+[m[32m        $stmt->bindParam(":id_utilisateur", $id_utilisateur, PDO::PARAM_INT);[m
[32m+[m[32m        $stmt->bindParam(":id_maison", $id_maison, PDO::PARAM_INT);[m
         return $stmt->execute();[m
     }[m
 [m
     public function supprimerDemande($id_demande)[m
     {[m
[31m-        $query = "DELETE FROM " . $this->table . " WHERE id_demande = :id_demande";[m
[32m+[m[32m        $query = "DELETE FROM {$this->table} WHERE id_demande = :id_demande";[m
         $stmt = $this->conn->prepare($query);[m
[31m-        $stmt->bindParam(":id_demande", $id_demande);[m
[31m-[m
[32m+[m[32m        $stmt->bindParam(":id_demande", $id_demande, PDO::PARAM_INT);[m
         return $stmt->execute();[m
     }[m
 [m
     public function getDemandes()[m
     {[m
[31m-        $query = "SELECT * FROM " . $this->table . " ORDER BY id_demande DESC";[m
[32m+[m[32m        $query = "SELECT * FROM {$this->table} ORDER BY id_demande DESC";[m
         $stmt = $this->conn->prepare($query);[m
         $stmt->execute();[m
[31m-[m
         return $stmt->fetchAll(PDO::FETCH_ASSOC);[m
     }[m
 [m
     public function getDemande($id_demande)[m
     {[m
[31m-        $query = "SELECT * FROM " . $this->table . " WHERE id_demande = :id_demande";[m
[32m+[m[32m        $query = "SELECT * FROM {$this->table} WHERE id_demande = :id_demande";[m
         $stmt = $this->conn->prepare($query);[m
[31m-        $stmt->bindParam(":id_demande", $id_demande);[m
[32m+[m[32m        $stmt->bindParam(":id_demande", $id_demande, PDO::PARAM_INT);[m
         $stmt->execute();[m
[31m-[m
         return $stmt->fetch(PDO::FETCH_ASSOC);[m
     }[m
 [m
     public function getDemandesByUtilisateur($id_utilisateur)[m
     {[m
[31m-        $query = "SELECT * FROM " . $this->table . " WHERE id_utilisateur = :id_utilisateur ORDER BY id_demande DESC";[m
[32m+[m[32m        $query = "SELECT * FROM {$this->table} WHERE id_utilisateur = :id_utilisateur ORDER BY id_demande DESC";[m
         $stmt = $this->conn->prepare($query);[m
[31m-        $stmt->bindParam(":id_utilisateur", $id_utilisateur);[m
[32m+[m[32m        $stmt->bindParam(":id_utilisateur", $id_utilisateur, PDO::PARAM_INT);[m
         $stmt->execute();[m
[31m-[m
         return $stmt->fetchAll(PDO::FETCH_ASSOC);[m
     }[m
 [m
[31m-    // Méthode pour changer le statut d'une demande (accepter, refuser, etc.)[m
     public function actionStatut($id_demande, $statut)[m
     {[m
[31m-        $query = "UPDATE " . $this->table . " SET statut = :statut WHERE id_demande = :id_demande";[m
[32m+[m[32m        $query = "UPDATE {$this->table} SET statut = :statut WHERE id_demande = :id_demande";[m
         $stmt = $this->conn->prepare($query);[m
[31m-        $stmt->bindParam(":statut", $statut);[m
[31m-        $stmt->bindParam(":id_demande", $id_demande);[m
[31m-[m
[32m+[m[32m        $stmt->bindParam(":statut", $statut, PDO::PARAM_STR);[m
[32m+[m[32m        $stmt->bindParam(":id_demande", $id_demande, PDO::PARAM_INT);[m
         return $stmt->execute();[m
     }[m
 [m
     public function getDemandesByStatut($statut)[m
     {[m
[31m-        $query = "SELECT * FROM " . $this->table . " WHERE statut = :statut ORDER BY id_demande DESC";[m
[32m+[m[32m        $query = "SELECT * FROM {$this->table} WHERE statut = :statut ORDER BY id_demande DESC";[m
         $stmt = $this->conn->prepare($query);[m
[31m-        $stmt->bindParam(":statut", $statut);[m
[32m+[m[32m        $stmt->bindParam(":statut", $statut, PDO::PARAM_STR);[m
         $stmt->execute();[m
[32m+[m[32m        return $stmt->fetchAll(PDO::FETCH_ASSOC);[m
[32m+[m[32m    }[m
 [m
[32m+[m[32m    public function getDemandesEnvoyeesAMaMaison($id_utilisateur_maison)[m
[32m+[m[32m    {[m
[32m+[m[32m        $query = "SELECT[m[41m [m
[32m+[m[32m                    dl.id_demande,[m
[32m+[m[32m                    dl.date AS date_demande,[m
[32m+[m[32m                    dl.statut,[m
[32m+[m[32m                    u.id AS id_locataire,[m
[32m+[m[32m                    u.nom AS nom_locataire,[m
[32m+[m[32m                    u.email AS email_locataire,[m
[32m+[m[32m                    m.id_maison,[m
[32m+[m[32m                    m.adresse,[m
[32m+[m[32m                    m.prix[m
[32m+[m[32m                  FROM {$this->table} dl[m
[32m+[m[32m                  INNER JOIN maison m ON dl.id_maison = m.id_maison[m
[32m+[m[32m                  INNER JOIN utilisateurs u ON dl.id_utilisateur = u.id[m
[32m+[m[32m                  WHERE m.id_utilisateur = :id_utilisateur_maison[m
[32m+[m[32m                  ORDER BY dl.id_demande DESC";[m
[32m+[m[32m        $stmt = $this->conn->prepare($query);[m
[32m+[m[32m        $stmt->bindParam(":id_utilisateur_maison", $id_utilisateur_maison, PDO::PARAM_INT);[m
[32m+[m[32m        $stmt->execute();[m
         return $stmt->fetchAll(PDO::FETCH_ASSOC);[m
     }[m
[32m+[m
[32m+[m[32m    public function getNombreDemandesPourMesMaisons($id_utilisateur_maison)[m
[32m+[m[32m    {[m
[32m+[m[32m        $query = "SELECT COUNT(*) as total[m
[32m+[m[32m                  FROM {$this->table} dl[m
[32m+[m[32m                  INNER JOIN maison m ON dl.id_maison = m.id_maison[m
[32m+[m[32m                  WHERE m.id_utilisateur = :id_utilisateur_maison";[m
[32m+[m[32m        $stmt = $this->conn->prepare($query);[m
[32m+[m[32m        $stmt->bindParam(":id_utilisateur_maison", $id_utilisateur_maison, PDO::PARAM_INT);[m
[32m+[m[32m        $stmt->execute();[m
[32m+[m[32m        $result = $stmt->fetch(PDO::FETCH_ASSOC);[m
[32m+[m[32m        return $result ? (int)$result['total'] : 0;[m
[32m+[m[32m    }[m
[32m+[m
[32m+[m[32m    /**[m
[32m+[m[32m     * Accepte ou refuse une demande de location.[m
[32m+[m[32m     * Si acceptée, annule les autres demandes et notifie les utilisateurs concernés.[m
[32m+[m[32m     * Si refusée, notifie le locataire.[m
[32m+[m[32m     */[m
[32m+[m[32m    public function traiterDemande($id_demande, $action)[m
[32m+[m[32m    {[m
[32m+[m[32m        $demande = $this->getDemande($id_demande);[m
[32m+[m[32m        if (!$demande) {[m
[32m+[m[32m            return false;[m
[32m+[m[32m        }[m
[32m+[m
[32m+[m[32m        $id_maison = $demande['id_maison'];[m
[32m+[m[32m        $id_locataire = $demande['id_utilisateur'];[m
[32m+[m
[32m+[m[32m        $utilisateur = new Utilisateur();[m
[32m+[m[32m        $locataire = $utilisateur->getUtilisateur($id_locataire);[m
[32m+[m
[32m+[m[32m        $query = "SELECT dl.id_demande, u.email, u.nom, dl.id_utilisateur[m
[32m+[m[32m                  FROM {$this->table} dl[m
[32m+[m[32m                  INNER JOIN utilisateurs u ON dl.id_utilisateur = u.id[m
[32m+[m[32m                  WHERE dl.id_maison = :id_maison";[m
[32m+[m[32m        $stmt = $this->conn->prepare($query);[m
[32m+[m[32m        $stmt->bindParam(":id_maison", $id_maison, PDO::PARAM_INT);[m
[32m+[m[32m        $stmt->execute();[m
[32m+[m[32m        $demandes = $stmt->fetchAll(PDO::FETCH_ASSOC);[m
[32m+[m
[32m+[m[32m        if ($action === 'accepter') {[m
[32m+[m[32m            $this->actionStatut($id_demande, 'acceptee');[m
[32m+[m
[32m+[m[32m            // Notifier le demandeur accepté[m
[32m+[m[32m            if ($locataire && !empty($locataire['email'])) {[m
[32m+[m[32m                $this->envoyerMail([m
[32m+[m[32m                    $locataire['email'],[m
[32m+[m[32m                    $locataire['nom'],[m
[32m+[m[32m                    "Demande de location acceptée",[m
[32m+[m[32m                    "Bonjour {$locataire['nom']},\n\nVotre demande de location a été acceptée avec succès. Félicitations !"[m
[32m+[m[32m                );[m
[32m+[m[32m            }[m
[32m+[m
[32m+[m[32m            // Annuler les autres demandes et notifier les autres demandeurs[m
[32m+[m[32m            foreach ($demandes as $d) {[m
[32m+[m[32m                if ($d['id_demande'] != $id_demande) {[m
[32m+[m[32m                    $this->actionStatut($d['id_demande'], 'annulee');[m
[32m+[m[32m                    if (!empty($d['email'])) {[m
[32m+[m[32m                        $this->envoyerMail([m
[32m+[m[32m                            $d['email'],[m
[32m+[m[32m                            $d['nom'],[m
[32m+[m[32m                            "Demande de location refusée",[m
[32m+[m[32m                            "Bonjour {$d['nom']},\n\nVotre demande de location a été refusée car une autre demande a été acceptée."[m
[32m+[m[32m                        );[m
[32m+[m[32m                    }[m
[32m+[m[32m                }[m
[32m+[m[32m            }[m
[32m+[m
[32m+[m[32m            // Mettre à jour le statut de la maison à "indisponible"[m
[32m+[m[32m            $maison = new Maison();[m
[32m+[m[32m            $maison->changerStatut($id_maison, 'indisponible');[m
[32m+[m
[32m+[m[32m        } elseif ($action === 'refuser') {[m
[32m+[m[32m            $this->actionStatut($id_demande, 'refusee');[m
[32m+[m[32m            if ($locataire && !empty($locataire['email'])) {[m
[32m+[m[32m                $this->envoyerMail([m
[32m+[m[32m                    $locataire['email'],[m
[32m+[m[32m                    $locataire['nom'],[m
[32m+[m[32m                    "Demande de location refusée",[m
[32m+[m[32m                    "Bonjour {$locataire['nom']},\n\nVotre demande de location a été refusée."[m
[32m+[m[32m                );[m
[32m+[m[32m            }[m
[32m+[m[32m        } else {[m
[32m+[m[32m            return false;[m
[32m+[m[32m        }[m
[32m+[m[32m        return true;[m
[32m+[m[32m    }[m
[32m+[m
[32m+[m[32m    /**[m
[32m+[m[32m     * Envoie un email via PHPMailer.[m
[32m+[m[32m     */[m
[32m+[m[32m    private function envoyerMail($to, $toName, $subject, $body)[m
[32m+[m[32m    {[m
[32m+[m[32m        $mail = new PHPMailer(true);[m
[32m+[m[32m        try {[m
[32m+[m[32m            $mail->isSMTP();[m
[32m+[m[32m            $mail->Host = 'smtp.gmail.com';[m
[32m+[m[32m            $mail->SMTPAuth = true;[m
[32m+[m[32m            $mail->Username = 'nehemiekasereka2003@gmail.com'; // À sécuriser[m
[32m+[m[32m            $mail->Password = 'naya kwtc bfow qozd'; // À sécuriser[m
[32m+[m[32m            $mail->SMTPSecure = PHPMailer::ENCRYPTION_STARTTLS;[m
[32m+[m[32m            $mail->Port = 587;[m
[32m+[m
[32m+[m[32m            $mail->setFrom('nehemiekasereka2003@gmail.com', 'ACCIAC');[m
[32m+[m[32m            $mail->addAddress($to, $toName);[m
[32m+[m
[32m+[m[32m            $mail->isHTML(false);[m
[32m+[m[32m            $mail->Subject = $subject;[m
[32m+[m[32m            $mail->Body = $body;[m
[32m+[m
[32m+[m[32m            $mail->send();[m
[32m+[m[32m        } catch (Exception $e) {[m
[32m+[m[32m            // Log ou gestion d'erreur si besoin[m
[32m+[m[32m        }[m
[32m+[m[32m    }[m
[32m+[m
[32m+[m[32m    /**[m
[32m+[m[32m     * Récupère les demandes acceptées pour un locataire donné, avec les infos de la maison.[m
[32m+[m[32m     */[m
[32m+[m[32m    public function getDemandesApprouveesPourLocataire($id_utilisateur)[m
[32m+[m[32m    {[m
[32m+[m[32m        $query = "SELECT[m[41m [m
[32m+[m[32m                    dl.id_demande,[m
[32m+[m[32m                    dl.date AS date_demande,[m
[32m+[m[32m                    dl.statut,[m
[32m+[m[32m                    m.id_maison,[m
[32m+[m[32m                    m.adresse,[m
[32m+[m[32m                    m.prix[m
[32m+[m[32m                  FROM {$this->table} dl[m
[32m+[m[32m                  INNER JOIN maison m ON dl.id_maison = m.id_maison[m
[32m+[m[32m                  WHERE dl.id_utilisateur = :id_utilisateur[m
[32m+[m[32m                  AND dl.statut = 'acceptee'[m
[32m+[m[32m                  ORDER BY dl.id_demande DESC";[m
[32m+[m[32m        $stmt = $this->conn->prepare($query);[m
[32m+[m[32m        $stmt->bindParam(":id_utilisateur", $id_utilisateur, PDO::PARAM_INT);[m
[32m+[m[32m        $stmt->execute();[m
[32m+[m[32m        return $stmt->fetchAll(PDO::FETCH_ASSOC);[m
[32m+[m[32m    }[m
[32m+[m
 }[m
 ?>[m
[1mdiff --git a/classe/maison.php b/classe/maison.php[m
[1mindex 85c12b6..987cc64 100644[m
[1m--- a/classe/maison.php[m
[1m+++ b/classe/maison.php[m
[36m@@ -77,9 +77,17 @@[m [mclass Maison[m
 [m
     public function getMaisonsApprouvees()[m
     {[m
[31m-        $query = "SELECT * FROM " . $this->table . " WHERE validite = 'approuver' ORDER BY id_maison DESC";[m
[32m+[m[32m        $query = "SELECT * FROM " . $this->table . " WHERE validite = 'approuver' AND statut='Disponible' ORDER BY id_maison DESC";[m
         $stmt = $this->conn->prepare($query);[m
         $stmt->execute();[m
         return $stmt->fetchAll(PDO::FETCH_ASSOC);[m
     }[m
[32m+[m[32m    public function changerStatut($id_maison, $statut)[m
[32m+[m[32m    {[m
[32m+[m[32m        $query = "UPDATE " . $this->table . " SET statut = :statut WHERE id_maison = :id_maison";[m
[32m+[m[32m        $stmt = $this->conn->prepare($query);[m
[32m+[m[32m        $stmt->bindParam(":statut", $statut);[m
[32m+[m[32m        $stmt->bindParam(":id_maison", $id_maison);[m
[32m+[m[32m        return $stmt->execute();[m
[32m+[m[32m    }[m
 }[m
[1mdiff --git a/composer.json b/composer.json[m
[1mindex b2363f0..ce6ed1f 100644[m
[1m--- a/composer.json[m
[1m+++ b/composer.json[m
[36m@@ -1,5 +1,9 @@[m
 {[m
     "require": {[m
[31m-        "phpmailer/phpmailer": "^6.10"[m
[32m+[m[32m        "phpmailer/phpmailer": "*",[m
[32m+[m[32m        "tecnickcom/tcpdf": "^6.10",[m
[32m+[m[32m        "symfony/var-dumper": "*",[m
[32m+[m[32m        "symfony/console": "*",[m
[32m+[m[32m        "decomplexity/sendoauth2": "^4.1"[m
     }[m
 }[m
[1mdiff --git a/composer.lock b/composer.lock[m
[1mindex bfc8e4e..a32c9c5 100644[m
[1m--- a/composer.lock[m
[1m+++ b/composer.lock[m
[36m@@ -4,88 +4,2372 @@[m
         "Read more about it at https://getcomposer.org/doc/01-basic-usage.md#installing-dependencies",[m
         "This file is @generated automatically"[m
     ],[m
[31m-    "content-hash": "cb5da62d73716ac8a1776f19367bc28f",[m
[32m+[m[32m    "content-hash": "565d24c5d72c387dc5eac28fd0284aba",[m
     "packages": [[m
         {[m
[31m-            "name": "phpmailer/phpmailer",[m
[31m-            "version": "v6.10.0",[m
[32m+[m[32m            "name": "decomplexity/sendoauth2",[m
[32m+[m[32m            "version": "v4.1.0",[m
             "source": {[m
                 "type": "git",[m
[31m-                "url": "https://github.com/PHPMailer/PHPMailer.git",[m
[31m-                "reference": "bf74d75a1fde6beaa34a0ddae2ec5fce0f72a144"[m
[32m+[m[32m                "url": "https://github.com/decomplexity/SendOauth2.git",[m
[32m+[m[32m                "reference": "0ea873dc851f3f96058548cd37879653f2070a87"[m
             },[m
             "dist": {[m
                 "type": "zip",[m
[31m-                "url": "https://api.github.com/repos/PHPMailer/PHPMailer/zipball/bf74d75a1fde6beaa34a0ddae2ec5fce0f72a144",[m
[31m-                "reference": "bf74d75a1fde6beaa34a0ddae2ec5fce0f72a144",[m
[32m+[m[32m                "url": "https://api.github.com/repos/decomplexity/SendOauth2/zipball/0ea873dc851f3f96058548cd37879653f2070a87",[m
[32m+[m[32m                "reference": "0ea873dc851f3f96058548cd37879653f2070a87",[m
                 "shasum": ""[m
             },[m
             "require": {[m
[31m-                "ext-ctype": "*",[m
[31m-                "ext-filter": "*",[m
[31m-                "ext-hash": "*",[m
[31m-                "php": ">=5.5.0"[m
[32m+[m[32m                "google/apiclient": "^2.15.0",[m
[32m+[m[32m                "league/oauth2-google": ">=4.0.1",[m
[32m+[m[32m                "php": ">=7.4.0",[m
[32m+[m[32m                "phpmailer/phpmailer": ">=6.6.0",[m
[32m+[m[32m                "thenetworg/oauth2-azure": ">=2.2.1"[m
[32m+[m[32m            },[m
[32m+[m[32m            "type": "library",[m
[32m+[m[32m            "autoload": {[m
[32m+[m[32m                "psr-4": {[m
[32m+[m[32m                    "decomplexity\\SendOauth2\\": "src/"[m
[32m+[m[32m                }[m
[32m+[m[32m            },[m
[32m+[m[32m            "notification-url": "https://packagist.org/downloads/",[m
[32m+[m[32m            "license": [[m
[32m+[m[32m                "MIT"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "authors": [[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Max Stewart",[m
[32m+[m[32m                    "email": "SendOauth2@decomplexity.com",[m
[32m+[m[32m                    "homepage": "https://www.decomplexity.com"[m
[32m+[m[32m                }[m
[32m+[m[32m            ],[m
[32m+[m[32m            "description": "Wrapper for PHPMailer SMTP",[m
[32m+[m[32m            "homepage": "https://github.com/decomplexity/SendOauth2",[m
[32m+[m[32m            "keywords": [[m
[32m+[m[32m                "oauth2",[m
[32m+[m[32m                "phpmailer"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "support": {[m
[32m+[m[32m                "email": "SendOauth2@decomplexity.com",[m
[32m+[m[32m                "issues": "https://github.com/decomplexity/SendOauth2/issues",[m
[32m+[m[32m                "source": "https://github.com/decomplexity/SendOauth2/tree/v4.1.0"[m
[32m+[m[32m            },[m
[32m+[m[32m            "time": "2024-07-04T14:51:49+00:00"[m
[32m+[m[32m        },[m
[32m+[m[32m        {[m
[32m+[m[32m            "name": "firebase/php-jwt",[m
[32m+[m[32m            "version": "v6.11.1",[m
[32m+[m[32m            "source": {[m
[32m+[m[32m                "type": "git",[m
[32m+[m[32m                "url": "https://github.com/firebase/php-jwt.git",[m
[32m+[m[32m                "reference": "d1e91ecf8c598d073d0995afa8cd5c75c6e19e66"[m
[32m+[m[32m            },[m
[32m+[m[32m            "dist": {[m
[32m+[m[32m                "type": "zip",[m
[32m+[m[32m                "url": "https://api.github.com/repos/firebase/php-jwt/zipball/d1e91ecf8c598d073d0995afa8cd5c75c6e19e66",[m
[32m+[m[32m                "reference": "d1e91ecf8c598d073d0995afa8cd5c75c6e19e66",[m
[32m+[m[32m                "shasum": ""[m
[32m+[m[32m            },[m
[32m+[m[32m            "require": {[m
[32m+[m[32m                "php": "^8.0"[m
             },[m
             "require-dev": {[m
[31m-                "dealerdirect/phpcodesniffer-composer-installer": "^1.0",[m
[31m-                "doctrine/annotations": "^1.2.6 || ^1.13.3",[m
[31m-                "php-parallel-lint/php-console-highlighter": "^1.0.0",[m
[31m-                "php-parallel-lint/php-parallel-lint": "^1.3.2",[m
[31m-                "phpcompatibility/php-compatibility": "^9.3.5",[m
[31m-                "roave/security-advisories": "dev-latest",[m
[31m-                "squizlabs/php_codesniffer": "^3.7.2",[m
[31m-                "yoast/phpunit-polyfills": "^1.0.4"[m
[32m+[m[32m                "guzzlehttp/guzzle": "^7.4",[m
[32m+[m[32m                "phpspec/prophecy-phpunit": "^2.0",[m
[32m+[m[32m                "phpunit/phpunit": "^9.5",[m
[32m+[m[32m                "psr/cache": "^2.0||^3.0",[m
[32m+[m[32m                "psr/http-client": "^1.0",[m
[32m+[m[32m                "psr/http-factory": "^1.0"[m
             },[m
             "suggest": {[m
[31m-                "decomplexity/SendOauth2": "Adapter for using XOAUTH2 authentication",[m
[31m-                "ext-mbstring": "Needed to send email in multibyte encoding charset or decode encoded addresses",[m
[31m-                "ext-openssl": "Needed for secure SMTP sending and DKIM signing",[m
[31m-                "greew/oauth2-azure-provider": "Needed for Microsoft Azure XOAUTH2 authentication",[m
[31m-                "hayageek/oauth2-yahoo": "Needed for Yahoo XOAUTH2 authentication",[m
[31m-                "league/oauth2-google": "Needed for Google XOAUTH2 authentication",[m
[31m-                "psr/log": "For optional PSR-3 debug logging",[m
[31m-                "symfony/polyfill-mbstring": "To support UTF-8 if the Mbstring PHP extension is not enabled (^1.2)",[m
[31m-                "thenetworg/oauth2-azure": "Needed for Microsoft XOAUTH2 authentication"[m
[32m+[m[32m                "ext-sodium": "Support EdDSA (Ed25519) signatures",[m
[32m+[m[32m                "paragonie/sodium_compat": "Support EdDSA (Ed25519) signatures when libsodium is not present"[m
             },[m
             "type": "library",[m
             "autoload": {[m
                 "psr-4": {[m
[31m-                    "PHPMailer\\PHPMailer\\": "src/"[m
[32m+[m[32m                    "Firebase\\JWT\\": "src"[m
                 }[m
             },[m
             "notification-url": "https://packagist.org/downloads/",[m
             "license": [[m
[31m-                "LGPL-2.1-only"[m
[32m+[m[32m                "BSD-3-Clause"[m
             ],[m
             "authors": [[m
                 {[m
[31m-                    "name": "Marcus Bointon",[m
[31m-                    "email": "phpmailer@synchromedia.co.uk"[m
[32m+[m[32m                    "name": "Neuman Vong",[m
[32m+[m[32m                    "email": "neuman+pear@twilio.com",[m
[32m+[m[32m                    "role": "Developer"[m
                 },[m
                 {[m
[31m-                    "name": "Jim Jagielski",[m
[31m-                    "email": "jimjag@gmail.com"[m
[32m+[m[32m                    "name": "Anant Narayanan",[m
[32m+[m[32m                    "email": "anant@php.net",[m
[32m+[m[32m                    "role": "Developer"[m
[32m+[m[32m                }[m
[32m+[m[32m            ],[m
[32m+[m[32m            "description": "A simple library to encode and decode JSON Web Tokens (JWT) in PHP. Should conform to the current spec.",[m
[32m+[m[32m            "homepage": "https://github.com/firebase/php-jwt",[m
[32m+[m[32m            "keywords": [[m
[32m+[m[32m                "jwt",[m
[32m+[m[32m                "php"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "support": {[m
[32m+[m[32m                "issues": "https://github.com/firebase/php-jwt/issues",[m
[32m+[m[32m                "source": "https://github.com/firebase/php-jwt/tree/v6.11.1"[m
[32m+[m[32m            },[m
[32m+[m[32m            "time": "2025-04-09T20:32:01+00:00"[m
[32m+[m[32m        },[m
[32m+[m[32m        {[m
[32m+[m[32m            "name": "google/apiclient",[m
[32m+[m[32m            "version": "v2.18.3",[m
[32m+[m[32m            "source": {[m
[32m+[m[32m                "type": "git",[m
[32m+[m[32m                "url": "https://github.com/googleapis/google-api-php-client.git",[m
[32m+[m[32m                "reference": "4eee42d201eff054428a4836ec132944d271f051"[m
[32m+[m[32m            },[m
[32m+[m[32m            "dist": {[m
[32m+[m[32m                "type": "zip",[m
[32m+[m[32m                "url": "https://api.github.com/repos/googleapis/google-api-php-client/zipball/4eee42d201eff054428a4836ec132944d271f051",[m
[32m+[m[32m                "reference": "4eee42d201eff054428a4836ec132944d271f051",[m
[32m+[m[32m                "shasum": ""[m
[32m+[m[32m            },[m
[32m+[m[32m            "require": {[m
[32m+[m[32m                "firebase/php-jwt": "^6.0",[m
[32m+[m[32m                "google/apiclient-services": "~0.350",[m
[32m+[m[32m                "google/auth": "^1.37",[m
[32m+[m[32m                "guzzlehttp/guzzle": "^7.4.5",[m
[32m+[m[32m                "guzzlehttp/psr7": "^2.6",[m
[32m+[m[32m                "monolog/monolog": "^2.9||^3.0",[m
[32m+[m[32m                "php": "^8.0",[m
[32m+[m[32m                "phpseclib/phpseclib": "^3.0.36"[m
[32m+[m[32m            },[m
[32m+[m[32m            "require-dev": {[m
[32m+[m[32m                "cache/filesystem-adapter": "^1.1",[m
[32m+[m[32m                "composer/composer": "^1.10.23",[m
[32m+[m[32m                "phpcompatibility/php-compatibility": "^9.2",[m
[32m+[m[32m                "phpspec/prophecy-phpunit": "^2.1",[m
[32m+[m[32m                "phpunit/phpunit": "^9.6",[m
[32m+[m[32m                "squizlabs/php_codesniffer": "^3.8",[m
[32m+[m[32m                "symfony/css-selector": "~2.1",[m
[32m+[m[32m                "symfony/dom-crawler": "~2.1"[m
[32m+[m[32m            },[m
[32m+[m[32m            "suggest": {[m
[32m+[m[32m                "cache/filesystem-adapter": "For caching certs and tokens (using Google\\Client::setCache)"[m
[32m+[m[32m            },[m
[32m+[m[32m            "type": "library",[m
[32m+[m[32m            "extra": {[m
[32m+[m[32m                "branch-alias": {[m
[32m+[m[32m                    "dev-main": "2.x-dev"[m
[32m+[m[32m                }[m
[32m+[m[32m            },[m
[32m+[m[32m            "autoload": {[m
[32m+[m[32m                "files": [[m
[32m+[m[32m                    "src/aliases.php"[m
[32m+[m[32m                ],[m
[32m+[m[32m                "psr-4": {[m
[32m+[m[32m                    "Google\\": "src/"[m
[32m+[m[32m                },[m
[32m+[m[32m                "classmap": [[m
[32m+[m[32m                    "src/aliases.php"[m
[32m+[m[32m                ][m
[32m+[m[32m            },[m
[32m+[m[32m            "notification-url": "https://packagist.org/downloads/",[m
[32m+[m[32m            "license": [[m
[32m+[m[32m                "Apache-2.0"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "description": "Client library for Google APIs",[m
[32m+[m[32m            "homepage": "http://developers.google.com/api-client-library/php",[m
[32m+[m[32m            "keywords": [[m
[32m+[m[32m                "google"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "support": {[m
[32m+[m[32m                "issues": "https://github.com/googleapis/google-api-php-client/issues",[m
[32m+[m[32m                "source": "https://github.com/googleapis/google-api-php-client/tree/v2.18.3"[m
[32m+[m[32m            },[m
[32m+[m[32m            "time": "2025-04-08T21:59:36+00:00"[m
[32m+[m[32m        },[m
[32m+[m[32m        {[m
[32m+[m[32m            "name": "google/apiclient-services",[m
[32m+[m[32m            "version": "v0.400.0",[m
[32m+[m[32m            "source": {[m
[32m+[m[32m                "type": "git",[m
[32m+[m[32m                "url": "https://github.com/googleapis/google-api-php-client-services.git",[m
[32m+[m[32m                "reference": "8366037e450b62ffc1c5489459f207640acca2b4"[m
[32m+[m[32m            },[m
[32m+[m[32m            "dist": {[m
[32m+[m[32m                "type": "zip",[m
[32m+[m[32m                "url": "https://api.github.com/repos/googleapis/google-api-php-client-services/zipball/8366037e450b62ffc1c5489459f207640acca2b4",[m
[32m+[m[32m                "reference": "8366037e450b62ffc1c5489459f207640acca2b4",[m
[32m+[m[32m                "shasum": ""[m
[32m+[m[32m            },[m
[32m+[m[32m            "require": {[m
[32m+[m[32m                "php": "^8.0"[m
[32m+[m[32m            },[m
[32m+[m[32m            "require-dev": {[m
[32m+[m[32m                "phpunit/phpunit": "^9.6"[m
[32m+[m[32m            },[m
[32m+[m[32m            "type": "library",[m
[32m+[m[32m            "autoload": {[m
[32m+[m[32m                "files": [[m
[32m+[m[32m                    "autoload.php"[m
[32m+[m[32m                ],[m
[32m+[m[32m                "psr-4": {[m
[32m+[m[32m                    "Google\\Service\\": "src"[m
[32m+[m[32m                }[m
[32m+[m[32m            },[m
[32m+[m[32m            "notification-url": "https://packagist.org/downloads/",[m
[32m+[m[32m            "license": [[m
[32m+[m[32m                "Apache-2.0"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "description": "Client library for Google APIs",[m
[32m+[m[32m            "homepage": "http://developers.google.com/api-client-library/php",[m
[32m+[m[32m            "keywords": [[m
[32m+[m[32m                "google"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "support": {[m
[32m+[m[32m                "issues": "https://github.com/googleapis/google-api-php-client-services/issues",[m
[32m+[m[32m                "source": "https://github.com/googleapis/google-api-php-client-services/tree/v0.400.0"[m
[32m+[m[32m            },[m
[32m+[m[32m            "time": "2025-06-04T17:28:44+00:00"[m
[32m+[m[32m        },[m
[32m+[m[32m        {[m
[32m+[m[32m            "name": "google/auth",[m
[32m+[m[32m            "version": "v1.47.0",[m
[32m+[m[32m            "source": {[m
[32m+[m[32m                "type": "git",[m
[32m+[m[32m                "url": "https://github.com/googleapis/google-auth-library-php.git",[m
[32m+[m[32m                "reference": "d6389aae7c009daceaa8da9b7942d8df6969f6d9"[m
[32m+[m[32m            },[m
[32m+[m[32m            "dist": {[m
[32m+[m[32m                "type": "zip",[m
[32m+[m[32m                "url": "https://api.github.com/repos/googleapis/google-auth-library-php/zipball/d6389aae7c009daceaa8da9b7942d8df6969f6d9",[m
[32m+[m[32m                "reference": "d6389aae7c009daceaa8da9b7942d8df6969f6d9",[m
[32m+[m[32m                "shasum": ""[m
[32m+[m[32m            },[m
[32m+[m[32m            "require": {[m
[32m+[m[32m                "firebase/php-jwt": "^6.0",[m
[32m+[m[32m                "guzzlehttp/guzzle": "^7.4.5",[m
[32m+[m[32m                "guzzlehttp/psr7": "^2.4.5",[m
[32m+[m[32m                "php": "^8.0",[m
[32m+[m[32m                "psr/cache": "^2.0||^3.0",[m
[32m+[m[32m                "psr/http-message": "^1.1||^2.0",[m
[32m+[m[32m                "psr/log": "^3.0"[m
[32m+[m[32m            },[m
[32m+[m[32m            "require-dev": {[m
[32m+[m[32m                "guzzlehttp/promises": "^2.0",[m
[32m+[m[32m                "kelvinmo/simplejwt": "0.7.1",[m
[32m+[m[32m                "phpseclib/phpseclib": "^3.0.35",[m
[32m+[m[32m                "phpspec/prophecy-phpunit": "^2.1",[m
[32m+[m[32m                "phpunit/phpunit": "^9.6",[m
[32m+[m[32m                "sebastian/comparator": ">=1.2.3",[m
[32m+[m[32m                "squizlabs/php_codesniffer": "^3.5",[m
[32m+[m[32m                "symfony/process": "^6.0||^7.0",[m
[32m+[m[32m                "webmozart/assert": "^1.11"[m
[32m+[m[32m            },[m
[32m+[m[32m            "suggest": {[m
[32m+[m[32m                "phpseclib/phpseclib": "May be used in place of OpenSSL for signing strings or for token management. Please require version ^2."[m
[32m+[m[32m            },[m
[32m+[m[32m            "type": "library",[m
[32m+[m[32m            "autoload": {[m
[32m+[m[32m                "psr-4": {[m
[32m+[m[32m                    "Google\\Auth\\": "src"[m
[32m+[m[32m                }[m
[32m+[m[32m            },[m
[32m+[m[32m            "notification-url": "https://packagist.org/downloads/",[m
[32m+[m[32m            "license": [[m
[32m+[m[32m                "Apache-2.0"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "description": "Google Auth Library for PHP",[m
[32m+[m[32m            "homepage": "https://github.com/google/google-auth-library-php",[m
[32m+[m[32m            "keywords": [[m
[32m+[m[32m                "Authentication",[m
[32m+[m[32m                "google",[m
[32m+[m[32m                "oauth2"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "support": {[m
[32m+[m[32m                "docs": "https://cloud.google.com/php/docs/reference/auth/latest",[m
[32m+[m[32m                "issues": "https://github.com/googleapis/google-auth-library-php/issues",[m
[32m+[m[32m                "source": "https://github.com/googleapis/google-auth-library-php/tree/v1.47.0"[m
[32m+[m[32m            },[m
[32m+[m[32m            "time": "2025-04-15T21:47:20+00:00"[m
[32m+[m[32m        },[m
[32m+[m[32m        {[m
[32m+[m[32m            "name": "guzzlehttp/guzzle",[m
[32m+[m[32m            "version": "7.9.3",[m
[32m+[m[32m            "source": {[m
[32m+[m[32m                "type": "git",[m
[32m+[m[32m                "url": "https://github.com/guzzle/guzzle.git",[m
[32m+[m[32m                "reference": "7b2f29fe81dc4da0ca0ea7d42107a0845946ea77"[m
[32m+[m[32m            },[m
[32m+[m[32m            "dist": {[m
[32m+[m[32m                "type": "zip",[m
[32m+[m[32m                "url": "https://api.github.com/repos/guzzle/guzzle/zipball/7b2f29fe81dc4da0ca0ea7d42107a0845946ea77",[m
[32m+[m[32m                "reference": "7b2f29fe81dc4da0ca0ea7d42107a0845946ea77",[m
[32m+[m[32m                "shasum": ""[m
[32m+[m[32m            },[m
[32m+[m[32m            "require": {[m
[32m+[m[32m                "ext-json": "*",[m
[32m+[m[32m                "guzzlehttp/promises": "^1.5.3 || ^2.0.3",[m
[32m+[m[32m                "guzzlehttp/psr7": "^2.7.0",[m
[32m+[m[32m                "php": "^7.2.5 || ^8.0",[m
[32m+[m[32m                "psr/http-client": "^1.0",[m
[32m+[m[32m                "symfony/deprecation-contracts": "^2.2 || ^3.0"[m
[32m+[m[32m            },[m
[32m+[m[32m            "provide": {[m
[32m+[m[32m                "psr/http-client-implementation": "1.0"[m
[32m+[m[32m            },[m
[32m+[m[32m            "require-dev": {[m
[32m+[m[32m                "bamarni/composer-bin-plugin": "^1.8.2",[m
[32m+[m[32m                "ext-curl": "*",[m
[32m+[m[32m                "guzzle/client-integration-tests": "3.0.2",[m
[32m+[m[32m                "php-http/message-factory": "^1.1",[m
[32m+[m[32m                "phpunit/phpunit": "^8.5.39 || ^9.6.20",[m
[32m+[m[32m                "psr/log": "^1.1 || ^2.0 || ^3.0"[m
[32m+[m[32m            },[m
[32m+[m[32m            "suggest": {[m
[32m+[m[32m                "ext-curl": "Required for CURL handler support",[m
[32m+[m[32m                "ext-intl": "Required for Internationalized Domain Name (IDN) support",[m
[32m+[m[32m                "psr/log": "Required for using the Log middleware"[m
[32m+[m[32m            },[m
[32m+[m[32m            "type": "library",[m
[32m+[m[32m            "extra": {[m
[32m+[m[32m                "bamarni-bin": {[m
[32m+[m[32m                    "bin-links": true,[m
[32m+[m[32m                    "forward-command": false[m
[32m+[m[32m                }[m
[32m+[m[32m            },[m
[32m+[m[32m            "autoload": {[m
[32m+[m[32m                "files": [[m
[32m+[m[32m                    "src/functions_include.php"[m
[32m+[m[32m                ],[m
[32m+[m[32m                "psr-4": {[m
[32m+[m[32m                    "GuzzleHttp\\": "src/"[m
[32m+[m[32m                }[m
[32m+[m[32m            },[m
[32m+[m[32m            "notification-url": "https://packagist.org/downloads/",[m
[32m+[m[32m            "license": [[m
[32m+[m[32m                "MIT"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "authors": [[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Graham Campbell",[m
[32m+[m[32m                    "email": "hello@gjcampbell.co.uk",[m
[32m+[m[32m                    "homepage": "https://github.com/GrahamCampbell"[m
                 },[m
                 {[m
[31m-                    "name": "Andy Prevost",[m
[31m-                    "email": "codeworxtech@users.sourceforge.net"[m
[32m+[m[32m                    "name": "Michael Dowling",[m
[32m+[m[32m                    "email": "mtdowling@gmail.com",[m
[32m+[m[32m                    "homepage": "https://github.com/mtdowling"[m
                 },[m
                 {[m
[31m-                    "name": "Brent R. Matzelle"[m
[32m+[m[32m                    "name": "Jeremy Lindblom",[m
[32m+[m[32m                    "email": "jeremeamia@gmail.com",[m
[32m+[m[32m                    "homepage": "https://github.com/jeremeamia"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "George Mponos",[m
[32m+[m[32m                    "email": "gmponos@gmail.com",[m
[32m+[m[32m                    "homepage": "https://github.com/gmponos"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Tobias Nyholm",[m
[32m+[m[32m                    "email": "tobias.nyholm@gmail.com",[m
[32m+[m[32m                    "homepage": "https://github.com/Nyholm"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Márk Sági-Kazár",[m
[32m+[m[32m                    "email": "mark.sagikazar@gmail.com",[m
[32m+[m[32m                    "homepage": "https://github.com/sagikazarmark"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Tobias Schultze",[m
[32m+[m[32m                    "email": "webmaster@tubo-world.de",[m
[32m+[m[32m                    "homepage": "https://github.com/Tobion"[m
                 }[m
             ],[m
[31m-            "description": "PHPMailer is a full-featured email creation and transfer class for PHP",[m
[32m+[m[32m            "description": "Guzzle is a PHP HTTP client library",[m
[32m+[m[32m            "keywords": [[m
[32m+[m[32m                "client",[m
[32m+[m[32m                "curl",[m
[32m+[m[32m                "framework",[m
[32m+[m[32m                "http",[m
[32m+[m[32m                "http client",[m
[32m+[m[32m                "psr-18",[m
[32m+[m[32m                "psr-7",[m
[32m+[m[32m                "rest",[m
[32m+[m[32m                "web service"[m
[32m+[m[32m            ],[m
             "support": {[m
[31m-                "issues": "https://github.com/PHPMailer/PHPMailer/issues",[m
[31m-                "source": "https://github.com/PHPMailer/PHPMailer/tree/v6.10.0"[m
[32m+[m[32m                "issues": "https://github.com/guzzle/guzzle/issues",[m
[32m+[m[32m                "source": "https://github.com/guzzle/guzzle/tree/7.9.3"[m
             },[m
             "funding": [[m
                 {[m
[31m-                    "url": "https://github.com/Synchro",[m
[32m+[m[32m                    "url": "https://github.com/GrahamCampbell",[m
[32m+[m[32m                    "type": "github"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "url": "https://github.com/Nyholm",[m
                     "type": "github"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "url": "https://tidelift.com/funding/github/packagist/guzzlehttp/guzzle",[m
[32m+[m[32m                    "type": "tidelift"[m
                 }[m
             ],[m
[31m-            "time": "2025-04-24T15:19:31+00:00"[m
[32m+[m[32m            "time": "2025-03-27T13:37:11+00:00"[m
[32m+[m[32m        },[m
[32m+[m[32m        {[m
[32m+[m[32m            "name": "guzzlehttp/promises",[m
[32m+[m[32m            "version": "2.2.0",[m
[32m+[m[32m            "source": {[m
[32m+[m[32m                "type": "git",[m
[32m+[m[32m                "url": "https://github.com/guzzle/promises.git",[m
[32m+[m[32m                "reference": "7c69f28996b0a6920945dd20b3857e499d9ca96c"[m
[32m+[m[32m            },[m
[32m+[m[32m            "dist": {[m
[32m+[m[32m                "type": "zip",[m
[32m+[m[32m                "url": "https://api.github.com/repos/guzzle/promises/zipball/7c69f28996b0a6920945dd20b3857e499d9ca96c",[m
[32m+[m[32m                "reference": "7c69f28996b0a6920945dd20b3857e499d9ca96c",[m
[32m+[m[32m                "shasum": ""[m
[32m+[m[32m            },[m
[32m+[m[32m            "require": {[m
[32m+[m[32m                "php": "^7.2.5 || ^8.0"[m
[32m+[m[32m            },[m
[32m+[m[32m            "require-dev": {[m
[32m+[m[32m                "bamarni/composer-bin-plugin": "^1.8.2",[m
[32m+[m[32m                "phpunit/phpunit": "^8.5.39 || ^9.6.20"[m
[32m+[m[32m            },[m
[32m+[m[32m            "type": "library",[m
[32m+[m[32m            "extra": {[m
[32m+[m[32m                "bamarni-bin": {[m
[32m+[m[32m                    "bin-links": true,[m
[32m+[m[32m                    "forward-command": false[m
[32m+[m[32m                }[m
[32m+[m[32m            },[m
[32m+[m[32m            "autoload": {[m
[32m+[m[32m                "psr-4": {[m
[32m+[m[32m                    "GuzzleHttp\\Promise\\": "src/"[m
[32m+[m[32m                }[m
[32m+[m[32m            },[m
[32m+[m[32m            "notification-url": "https://packagist.org/downloads/",[m
[32m+[m[32m            "license": [[m
[32m+[m[32m                "MIT"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "authors": [[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Graham Campbell",[m
[32m+[m[32m                    "email": "hello@gjcampbell.co.uk",[m
[32m+[m[32m                    "homepage": "https://github.com/GrahamCampbell"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Michael Dowling",[m
[32m+[m[32m                    "email": "mtdowling@gmail.com",[m
[32m+[m[32m                    "homepage": "https://github.com/mtdowling"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Tobias Nyholm",[m
[32m+[m[32m                    "email": "tobias.nyholm@gmail.com",[m
[32m+[m[32m                    "homepage": "https://github.com/Nyholm"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Tobias Schultze",[m
[32m+[m[32m                    "email": "webmaster@tubo-world.de",[m
[32m+[m[32m                    "homepage": "https://github.com/Tobion"[m
[32m+[m[32m                }[m
[32m+[m[32m            ],[m
[32m+[m[32m            "description": "Guzzle promises library",[m
[32m+[m[32m            "keywords": [[m
[32m+[m[32m                "promise"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "support": {[m
[32m+[m[32m                "issues": "https://github.com/guzzle/promises/issues",[m
[32m+[m[32m                "source": "https://github.com/guzzle/promises/tree/2.2.0"[m
[32m+[m[32m            },[m
[32m+[m[32m            "funding": [[m
[32m+[m[32m                {[m
[32m+[m[32m                    "url": "https://github.com/GrahamCampbell",[m
[32m+[m[32m                    "type": "github"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "url": "https://github.com/Nyholm",[m
[32m+[m[32m                    "type": "github"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "url": "https://tidelift.com/funding/github/packagist/guzzlehttp/promises",[m
[32m+[m[32m                    "type": "tidelift"[m
[32m+[m[32m                }[m
[32m+[m[32m            ],[m
[32m+[m[32m            "time": "2025-03-27T13:27:01+00:00"[m
[32m+[m[32m        },[m
[32m+[m[32m        {[m
[32m+[m[32m            "name": "guzzlehttp/psr7",[m
[32m+[m[32m            "version": "2.7.1",[m
[32m+[m[32m            "source": {[m
[32m+[m[32m                "type": "git",[m
[32m+[m[32m                "url": "https://github.com/guzzle/psr7.git",[m
[32m+[m[32m                "reference": "c2270caaabe631b3b44c85f99e5a04bbb8060d16"[m
[32m+[m[32m            },[m
[32m+[m[32m            "dist": {[m
[32m+[m[32m                "type": "zip",[m
[32m+[m[32m                "url": "https://api.github.com/repos/guzzle/psr7/zipball/c2270caaabe631b3b44c85f99e5a04bbb8060d16",[m
[32m+[m[32m                "reference": "c2270caaabe631b3b44c85f99e5a04bbb8060d16",[m
[32m+[m[32m                "shasum": ""[m
[32m+[m[32m            },[m
[32m+[m[32m            "require": {[m
[32m+[m[32m                "php": "^7.2.5 || ^8.0",[m
[32m+[m[32m                "psr/http-factory": "^1.0",[m
[32m+[m[32m                "psr/http-message": "^1.1 || ^2.0",[m
[32m+[m[32m                "ralouphie/getallheaders": "^3.0"[m
[32m+[m[32m            },[m
[32m+[m[32m            "provide": {[m
[32m+[m[32m                "psr/http-factory-implementation": "1.0",[m
[32m+[m[32m                "psr/http-message-implementation": "1.0"[m
[32m+[m[32m            },[m
[32m+[m[32m            "require-dev": {[m
[32m+[m[32m                "bamarni/composer-bin-plugin": "^1.8.2",[m
[32m+[m[32m                "http-interop/http-factory-tests": "0.9.0",[m
[32m+[m[32m                "phpunit/phpunit": "^8.5.39 || ^9.6.20"[m
[32m+[m[32m            },[m
[32m+[m[32m            "suggest": {[m
[32m+[m[32m                "laminas/laminas-httphandlerrunner": "Emit PSR-7 responses"[m
[32m+[m[32m            },[m
[32m+[m[32m            "type": "library",[m
[32m+[m[32m            "extra": {[m
[32m+[m[32m                "bamarni-bin": {[m
[32m+[m[32m                    "bin-links": true,[m
[32m+[m[32m                    "forward-command": false[m
[32m+[m[32m                }[m
[32m+[m[32m            },[m
[32m+[m[32m            "autoload": {[m
[32m+[m[32m                "psr-4": {[m
[32m+[m[32m                    "GuzzleHttp\\Psr7\\": "src/"[m
[32m+[m[32m                }[m
[32m+[m[32m            },[m
[32m+[m[32m            "notification-url": "https://packagist.org/downloads/",[m
[32m+[m[32m            "license": [[m
[32m+[m[32m                "MIT"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "authors": [[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Graham Campbell",[m
[32m+[m[32m                    "email": "hello@gjcampbell.co.uk",[m
[32m+[m[32m                    "homepage": "https://github.com/GrahamCampbell"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Michael Dowling",[m
[32m+[m[32m                    "email": "mtdowling@gmail.com",[m
[32m+[m[32m                    "homepage": "https://github.com/mtdowling"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "George Mponos",[m
[32m+[m[32m                    "email": "gmponos@gmail.com",[m
[32m+[m[32m                    "homepage": "https://github.com/gmponos"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Tobias Nyholm",[m
[32m+[m[32m                    "email": "tobias.nyholm@gmail.com",[m
[32m+[m[32m                    "homepage": "https://github.com/Nyholm"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Márk Sági-Kazár",[m
[32m+[m[32m                    "email": "mark.sagikazar@gmail.com",[m
[32m+[m[32m                    "homepage": "https://github.com/sagikazarmark"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Tobias Schultze",[m
[32m+[m[32m                    "email": "webmaster@tubo-world.de",[m
[32m+[m[32m                    "homepage": "https://github.com/Tobion"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Márk Sági-Kazár",[m
[32m+[m[32m                    "email": "mark.sagikazar@gmail.com",[m
[32m+[m[32m                    "homepage": "https://sagikazarmark.hu"[m
[32m+[m[32m                }[m
[32m+[m[32m            ],[m
[32m+[m[32m            "description": "PSR-7 message implementation that also provides common utility methods",[m
[32m+[m[32m            "keywords": [[m
[32m+[m[32m                "http",[m
[32m+[m[32m                "message",[m
[32m+[m[32m                "psr-7",[m
[32m+[m[32m                "request",[m
[32m+[m[32m                "response",[m
[32m+[m[32m                "stream",[m
[32m+[m[32m                "uri",[m
[32m+[m[32m                "url"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "support": {[m
[32m+[m[32m                "issues": "https://github.com/guzzle/psr7/issues",[m
[32m+[m[32m                "source": "https://github.com/guzzle/psr7/tree/2.7.1"[m
[32m+[m[32m            },[m
[32m+[m[32m            "funding": [[m
[32m+[m[32m                {[m
[32m+[m[32m                    "url": "https://github.com/GrahamCampbell",[m
[32m+[m[32m                    "type": "github"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "url": "https://github.com/Nyholm",[m
[32m+[m[32m                    "type": "github"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "url": "https://tidelift.com/funding/github/packagist/guzzlehttp/psr7",[m
[32m+[m[32m                    "type": "tidelift"[m
[32m+[m[32m                }[m
[32m+[m[32m            ],[m
[32m+[m[32m            "time": "2025-03-27T12:30:47+00:00"[m
[32m+[m[32m        },[m
[32m+[m[32m        {[m
[32m+[m[32m            "name": "league/oauth2-client",[m
[32m+[m[32m            "version": "2.8.1",[m
[32m+[m[32m            "source": {[m
[32m+[m[32m                "type": "git",[m
[32m+[m[32m                "url": "https://github.com/thephpleague/oauth2-client.git",[m
[32m+[m[32m                "reference": "9df2924ca644736c835fc60466a3a60390d334f9"[m
[32m+[m[32m            },[m
[32m+[m[32m            "dist": {[m
[32m+[m[32m                "type": "zip",[m
[32m+[m[32m                "url": "https://api.github.com/repos/thephpleague/oauth2-client/zipball/9df2924ca644736c835fc60466a3a60390d334f9",[m
[32m+[m[32m                "reference": "9df2924ca644736c835fc60466a3a60390d334f9",[m
[32m+[m[32m                "shasum": ""[m
[32m+[m[32m            },[m
[32m+[m[32m            "require": {[m
[32m+[m[32m                "ext-json": "*",[m
[32m+[m[32m                "guzzlehttp/guzzle": "^6.5.8 || ^7.4.5",[m
[32m+[m[32m                "php": "^7.1 || >=8.0.0 <8.5.0"[m
[32m+[m[32m            },[m
[32m+[m[32m            "require-dev": {[m
[32m+[m[32m                "mockery/mockery": "^1.3.5",[m
[32m+[m[32m                "php-parallel-lint/php-parallel-lint": "^1.4",[m
[32m+[m[32m                "phpunit/phpunit": "^7 || ^8 || ^9 || ^10 || ^11",[m
[32m+[m[32m                "squizlabs/php_codesniffer": "^3.11"[m
[32m+[m[32m            },[m
[32m+[m[32m            "type": "library",[m
[32m+[m[32m            "autoload": {[m
[32m+[m[32m                "psr-4": {[m
[32m+[m[32m                    "League\\OAuth2\\Client\\": "src/"[m
[32m+[m[32m                }[m
[32m+[m[32m            },[m
[32m+[m[32m            "notification-url": "https://packagist.org/downloads/",[m
[32m+[m[32m            "license": [[m
[32m+[m[32m                "MIT"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "authors": [[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Alex Bilbie",[m
[32m+[m[32m                    "email": "hello@alexbilbie.com",[m
[32m+[m[32m                    "homepage": "http://www.alexbilbie.com",[m
[32m+[m[32m                    "role": "Developer"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Woody Gilk",[m
[32m+[m[32m                    "homepage": "https://github.com/shadowhand",[m
[32m+[m[32m                    "role": "Contributor"[m
[32m+[m[32m                }[m
[32m+[m[32m            ],[m
[32m+[m[32m            "description": "OAuth 2.0 Client Library",[m
[32m+[m[32m            "keywords": [[m
[32m+[m[32m                "Authentication",[m
[32m+[m[32m                "SSO",[m
[32m+[m[32m                "authorization",[m
[32m+[m[32m                "identity",[m
[32m+[m[32m                "idp",[m
[32m+[m[32m                "oauth",[m
[32m+[m[32m                "oauth2",[m
[32m+[m[32m                "single sign on"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "support": {[m
[32m+[m[32m                "issues": "https://github.com/thephpleague/oauth2-client/issues",[m
[32m+[m[32m                "source": "https://github.com/thephpleague/oauth2-client/tree/2.8.1"[m
[32m+[m[32m            },[m
[32m+[m[32m            "time": "2025-02-26T04:37:30+00:00"[m
[32m+[m[32m        },[m
[32m+[m[32m        {[m
[32m+[m[32m            "name": "league/oauth2-google",[m
[32m+[m[32m            "version": "4.0.1",[m
[32m+[m[32m            "source": {[m
[32m+[m[32m                "type": "git",[m
[32m+[m[32m                "url": "https://github.com/thephpleague/oauth2-google.git",[m
[32m+[m[32m                "reference": "1b01ba18ba31b29e88771e3e0979e5c91d4afe76"[m
[32m+[m[32m            },[m
[32m+[m[32m            "dist": {[m
[32m+[m[32m                "type": "zip",[m
[32m+[m[32m                "url": "https://api.github.com/repos/thephpleague/oauth2-google/zipball/1b01ba18ba31b29e88771e3e0979e5c91d4afe76",[m
[32m+[m[32m                "reference": "1b01ba18ba31b29e88771e3e0979e5c91d4afe76",[m
[32m+[m[32m                "shasum": ""[m
[32m+[m[32m            },[m
[32m+[m[32m            "require": {[m
[32m+[m[32m                "league/oauth2-client": "^2.0",[m
[32m+[m[32m                "php": "^7.3 || ^8.0"[m
[32m+[m[32m            },[m
[32m+[m[32m            "require-dev": {[m
[32m+[m[32m                "eloquent/phony-phpunit": "^6.0 || ^7.1",[m
[32m+[m[32m                "phpunit/phpunit": "^8.0 || ^9.0",[m
[32m+[m[32m                "squizlabs/php_codesniffer": "^3.0"[m
[32m+[m[32m            },[m
[32m+[m[32m            "type": "library",[m
[32m+[m[32m            "autoload": {[m
[32m+[m[32m                "psr-4": {[m
[32m+[m[32m                    "League\\OAuth2\\Client\\": "src/"[m
[32m+[m[32m                }[m
[32m+[m[32m            },[m
[32m+[m[32m            "notification-url": "https://packagist.org/downloads/",[m
[32m+[m[32m            "license": [[m
[32m+[m[32m                "MIT"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "authors": [[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Woody Gilk",[m
[32m+[m[32m                    "email": "hello@shadowhand.com",[m
[32m+[m[32m                    "homepage": "https://shadowhand.com"[m
[32m+[m[32m                }[m
[32m+[m[32m            ],[m
[32m+[m[32m            "description": "Google OAuth 2.0 Client Provider for The PHP League OAuth2-Client",[m
[32m+[m[32m            "keywords": [[m
[32m+[m[32m                "Authentication",[m
[32m+[m[32m                "authorization",[m
[32m+[m[32m                "client",[m
[32m+[m[32m                "google",[m
[32m+[m[32m                "oauth",[m
[32m+[m[32m                "oauth2"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "support": {[m
[32m+[m[32m                "issues": "https://github.com/thephpleague/oauth2-google/issues",[m
[32m+[m[32m                "source": "https://github.com/thephpleague/oauth2-google/tree/4.0.1"[m
[32m+[m[32m            },[m
[32m+[m[32m            "time": "2023-03-17T15:20:52+00:00"[m
[32m+[m[32m        },[m
[32m+[m[32m        {[m
[32m+[m[32m            "name": "monolog/monolog",[m
[32m+[m[32m            "version": "3.9.0",[m
[32m+[m[32m            "source": {[m
[32m+[m[32m                "type": "git",[m
[32m+[m[32m                "url": "https://github.com/Seldaek/monolog.git",[m
[32m+[m[32m                "reference": "10d85740180ecba7896c87e06a166e0c95a0e3b6"[m
[32m+[m[32m            },[m
[32m+[m[32m            "dist": {[m
[32m+[m[32m                "type": "zip",[m
[32m+[m[32m                "url": "https://api.github.com/repos/Seldaek/monolog/zipball/10d85740180ecba7896c87e06a166e0c95a0e3b6",[m
[32m+[m[32m                "reference": "10d85740180ecba7896c87e06a166e0c95a0e3b6",[m
[32m+[m[32m                "shasum": ""[m
[32m+[m[32m            },[m
[32m+[m[32m            "require": {[m
[32m+[m[32m                "php": ">=8.1",[m
[32m+[m[32m                "psr/log": "^2.0 || ^3.0"[m
[32m+[m[32m            },[m
[32m+[m[32m            "provide": {[m
[32m+[m[32m                "psr/log-implementation": "3.0.0"[m
[32m+[m[32m            },[m
[32m+[m[32m            "require-dev": {[m
[32m+[m[32m                "aws/aws-sdk-php": "^3.0",[m
[32m+[m[32m                "doctrine/couchdb": "~1.0@dev",[m
[32m+[m[32m                "elasticsearch/elasticsearch": "^7 || ^8",[m
[32m+[m[32m                "ext-json": "*",[m
[32m+[m[32m                "graylog2/gelf-php": "^1.4.2 || ^2.0",[m
[32m+[m[32m                "guzzlehttp/guzzle": "^7.4.5",[m
[32m+[m[32m                "guzzlehttp/psr7": "^2.2",[m
[32m+[m[32m                "mongodb/mongodb": "^1.8",[m
[32m+[m[32m                "php-amqplib/php-amqplib": "~2.4 || ^3",[m
[32m+[m[32m                "php-console/php-console": "^3.1.8",[m
[32m+[m[32m                "phpstan/phpstan": "^2",[m
[32m+[m[32m                "phpstan/phpstan-deprecation-rules": "^2",[m
[32m+[m[32m                "phpstan/phpstan-strict-rules": "^2",[m
[32m+[m[32m                "phpunit/phpunit": "^10.5.17 || ^11.0.7",[m
[32m+[m[32m                "predis/predis": "^1.1 || ^2",[m
[32m+[m[32m                "rollbar/rollbar": "^4.0",[m
[32m+[m[32m                "ruflin/elastica": "^7 || ^8",[m
[32m+[m[32m                "symfony/mailer": "^5.4 || ^6",[m
[32m+[m[32m                "symfony/mime": "^5.4 || ^6"[m
[32m+[m[32m            },[m
[32m+[m[32m            "suggest": {[m
[32m+[m[32m                "aws/aws-sdk-php": "Allow sending log messages to AWS services like DynamoDB",[m
[32m+[m[32m                "doctrine/couchdb": "Allow sending log messages to a CouchDB server",[m
[32m+[m[32m                "elasticsearch/elasticsearch": "Allow sending log messages to an Elasticsearch server via official client",[m
[32m+[m[32m                "ext-amqp": "Allow sending log messages to an AMQP server (1.0+ required)",[m
[32m+[m[32m                "ext-curl": "Required to send log messages using the IFTTTHandler, the LogglyHandler, the SendGridHandler, the SlackWebhookHandler or the TelegramBotHandler",[m
[32m+[m[32m                "ext-mbstring": "Allow to work properly with unicode symbols",[m
[32m+[m[32m                "ext-mongodb": "Allow sending log messages to a MongoDB server (via driver)",[m
[32m+[m[32m                "ext-openssl": "Required to send log messages using SSL",[m
[32m+[m[32m                "ext-sockets": "Allow sending log messages to a Syslog server (via UDP driver)",[m
[32m+[m[32m                "graylog2/gelf-php": "Allow sending log messages to a GrayLog2 server",[m
[32m+[m[32m                "mongodb/mongodb": "Allow sending log messages to a MongoDB server (via library)",[m
[32m+[m[32m                "php-amqplib/php-amqplib": "Allow sending log messages to an AMQP server using php-amqplib",[m
[32m+[m[32m                "rollbar/rollbar": "Allow sending log messages to Rollbar",[m
[32m+[m[32m                "ruflin/elastica": "Allow sending log messages to an Elastic Search server"[m
[32m+[m[32m            },[m
[32m+[m[32m            "type": "library",[m
[32m+[m[32m            "extra": {[m
[32m+[m[32m                "branch-alias": {[m
[32m+[m[32m                    "dev-main": "3.x-dev"[m
[32m+[m[32m                }[m
[32m+[m[32m            },[m
[32m+[m[32m            "autoload": {[m
[32m+[m[32m                "psr-4": {[m
[32m+[m[32m                    "Monolog\\": "src/Monolog"[m
[32m+[m[32m                }[m
[32m+[m[32m            },[m
[32m+[m[32m            "notification-url": "https://packagist.org/downloads/",[m
[32m+[m[32m            "license": [[m
[32m+[m[32m                "MIT"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "authors": [[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Jordi Boggiano",[m
[32m+[m[32m                    "email": "j.boggiano@seld.be",[m
[32m+[m[32m                    "homepage": "https://seld.be"[m
[32m+[m[32m                }[m
[32m+[m[32m            ],[m
[32m+[m[32m            "description": "Sends your logs to files, sockets, inboxes, databases and various web services",[m
[32m+[m[32m            "homepage": "https://github.com/Seldaek/monolog",[m
[32m+[m[32m            "keywords": [[m
[32m+[m[32m                "log",[m
[32m+[m[32m                "logging",[m
[32m+[m[32m                "psr-3"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "support": {[m
[32m+[m[32m                "issues": "https://github.com/Seldaek/monolog/issues",[m
[32m+[m[32m                "source": "https://github.com/Seldaek/monolog/tree/3.9.0"[m
[32m+[m[32m            },[m
[32m+[m[32m            "funding": [[m
[32m+[m[32m                {[m
[32m+[m[32m                    "url": "https://github.com/Seldaek",[m
[32m+[m[32m                    "type": "github"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "url": "https://tidelift.com/funding/github/packagist/monolog/monolog",[m
[32m+[m[32m                    "type": "tidelift"[m
[32m+[m[32m                }[m
[32m+[m[32m            ],[m
[32m+[m[32m            "time": "2025-03-24T10:02:05+00:00"[m
[32m+[m[32m        },[m
[32m+[m[32m        {[m
[32m+[m[32m            "name": "paragonie/constant_time_encoding",[m
[32m+[m[32m            "version": "v3.0.0",[m
[32m+[m[32m            "source": {[m
[32m+[m[32m                "type": "git",[m
[32m+[m[32m                "url": "https://github.com/paragonie/constant_time_encoding.git",[m
[32m+[m[32m                "reference": "df1e7fde177501eee2037dd159cf04f5f301a512"[m
[32m+[m[32m            },[m
[32m+[m[32m            "dist": {[m
[32m+[m[32m                "type": "zip",[m
[32m+[m[32m                "url": "https://api.github.com/repos/paragonie/constant_time_encoding/zipball/df1e7fde177501eee2037dd159cf04f5f301a512",[m
[32m+[m[32m                "reference": "df1e7fde177501eee2037dd159cf04f5f301a512",[m
[32m+[m[32m                "shasum": ""[m
[32m+[m[32m            },[m
[32m+[m[32m            "require": {[m
[32m+[m[32m                "php": "^8"[m
[32m+[m[32m            },[m
[32m+[m[32m            "require-dev": {[m
[32m+[m[32m                "phpunit/phpunit": "^9",[m
[32m+[m[32m                "vimeo/psalm": "^4|^5"[m
[32m+[m[32m            },[m
[32m+[m[32m            "type": "library",[m
[32m+[m[32m            "autoload": {[m
[32m+[m[32m                "psr-4": {[m
[32m+[m[32m                    "ParagonIE\\ConstantTime\\": "src/"[m
[32m+[m[32m                }[m
[32m+[m[32m            },[m
[32m+[m[32m            "notification-url": "https://packagist.org/downloads/",[m
[32m+[m[32m            "license": [[m
[32m+[m[32m                "MIT"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "authors": [[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Paragon Initiative Enterprises",[m
[32m+[m[32m                    "email": "security@paragonie.com",[m
[32m+[m[32m                    "homepage": "https://paragonie.com",[m
[32m+[m[32m                    "role": "Maintainer"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Steve 'Sc00bz' Thomas",[m
[32m+[m[32m                    "email": "steve@tobtu.com",[m
[32m+[m[32m                    "homepage": "https://www.tobtu.com",[m
[32m+[m[32m                    "role": "Original Developer"[m
[32m+[m[32m                }[m
[32m+[m[32m            ],[m
[32m+[m[32m            "description": "Constant-time Implementations of RFC 4648 Encoding (Base-64, Base-32, Base-16)",[m
[32m+[m[32m            "keywords": [[m
[32m+[m[32m                "base16",[m
[32m+[m[32m                "base32",[m
[32m+[m[32m                "base32_decode",[m
[32m+[m[32m                "base32_encode",[m
[32m+[m[32m                "base64",[m
[32m+[m[32m                "base64_decode",[m
[32m+[m[32m                "base64_encode",[m
[32m+[m[32m                "bin2hex",[m
[32m+[m[32m                "encoding",[m
[32m+[m[32m                "hex",[m
[32m+[m[32m                "hex2bin",[m
[32m+[m[32m                "rfc4648"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "support": {[m
[32m+[m[32m                "email": "info@paragonie.com",[m
[32m+[m[32m                "issues": "https://github.com/paragonie/constant_time_encoding/issues",[m
[32m+[m[32m                "source": "https://github.com/paragonie/constant_time_encoding"[m
[32m+[m[32m            },[m
[32m+[m[32m            "time": "2024-05-08T12:36:18+00:00"[m
[32m+[m[32m        },[m
[32m+[m[32m        {[m
[32m+[m[32m            "name": "paragonie/random_compat",[m
[32m+[m[32m            "version": "v9.99.100",[m
[32m+[m[32m            "source": {[m
[32m+[m[32m                "type": "git",[m
[32m+[m[32m                "url": "https://github.com/paragonie/random_compat.git",[m
[32m+[m[32m                "reference": "996434e5492cb4c3edcb9168db6fbb1359ef965a"[m
[32m+[m[32m            },[m
[32m+[m[32m            "dist": {[m
[32m+[m[32m                "type": "zip",[m
[32m+[m[32m                "url": "https://api.github.com/repos/paragonie/random_compat/zipball/996434e5492cb4c3edcb9168db6fbb1359ef965a",[m
[32m+[m[32m                "reference": "996434e5492cb4c3edcb9168db6fbb1359ef965a",[m
[32m+[m[32m                "shasum": ""[m
[32m+[m[32m            },[m
[32m+[m[32m            "require": {[m
[32m+[m[32m                "php": ">= 7"[m
[32m+[m[32m            },[m
[32m+[m[32m            "require-dev": {[m
[32m+[m[32m                "phpunit/phpunit": "4.*|5.*",[m
[32m+[m[32m                "vimeo/psalm": "^1"[m
[32m+[m[32m            },[m
[32m+[m[32m            "suggest": {[m
[32m+[m[32m                "ext-libsodium": "Provides a modern crypto API that can be used to generate random bytes."[m
[32m+[m[32m            },[m
[32m+[m[32m            "type": "library",[m
[32m+[m[32m            "notification-url": "https://packagist.org/downloads/",[m
[32m+[m[32m            "license": [[m
[32m+[m[32m                "MIT"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "authors": [[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Paragon Initiative Enterprises",[m
[32m+[m[32m                    "email": "security@paragonie.com",[m
[32m+[m[32m                    "homepage": "https://paragonie.com"[m
[32m+[m[32m                }[m
[32m+[m[32m            ],[m
[32m+[m[32m            "description": "PHP 5.x polyfill for random_bytes() and random_int() from PHP 7",[m
[32m+[m[32m            "keywords": [[m
[32m+[m[32m                "csprng",[m
[32m+[m[32m                "polyfill",[m
[32m+[m[32m                "pseudorandom",[m
[32m+[m[32m                "random"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "support": {[m
[32m+[m[32m                "email": "info@paragonie.com",[m
[32m+[m[32m                "issues": "https://github.com/paragonie/random_compat/issues",[m
[32m+[m[32m                "source": "https://github.com/paragonie/random_compat"[m
[32m+[m[32m            },[m
[32m+[m[32m            "time": "2020-10-15T08:29:30+00:00"[m
[32m+[m[32m        },[m
[32m+[m[32m        {[m
[32m+[m[32m            "name": "phpmailer/phpmailer",[m
[32m+[m[32m            "version": "v6.10.0",[m
[32m+[m[32m            "source": {[m
[32m+[m[32m                "type": "git",[m
[32m+[m[32m                "url": "https://github.com/PHPMailer/PHPMailer.git",[m
[32m+[m[32m                "reference": "bf74d75a1fde6beaa34a0ddae2ec5fce0f72a144"[m
[32m+[m[32m            },[m
[32m+[m[32m            "dist": {[m
[32m+[m[32m                "type": "zip",[m
[32m+[m[32m                "url": "https://api.github.com/repos/PHPMailer/PHPMailer/zipball/bf74d75a1fde6beaa34a0ddae2ec5fce0f72a144",[m
[32m+[m[32m                "reference": "bf74d75a1fde6beaa34a0ddae2ec5fce0f72a144",[m
[32m+[m[32m                "shasum": ""[m
[32m+[m[32m            },[m
[32m+[m[32m            "require": {[m
[32m+[m[32m                "ext-ctype": "*",[m
[32m+[m[32m                "ext-filter": "*",[m
[32m+[m[32m                "ext-hash": "*",[m
[32m+[m[32m                "php": ">=5.5.0"[m
[32m+[m[32m            },[m
[32m+[m[32m            "require-dev": {[m
[32m+[m[32m                "dealerdirect/phpcodesniffer-composer-installer": "^1.0",[m
[32m+[m[32m                "doctrine/annotations": "^1.2.6 || ^1.13.3",[m
[32m+[m[32m                "php-parallel-lint/php-console-highlighter": "^1.0.0",[m
[32m+[m[32m                "php-parallel-lint/php-parallel-lint": "^1.3.2",[m
[32m+[m[32m                "phpcompatibility/php-compatibility": "^9.3.5",[m
[32m+[m[32m                "roave/security-advisories": "dev-latest",[m
[32m+[m[32m                "squizlabs/php_codesniffer": "^3.7.2",[m
[32m+[m[32m                "yoast/phpunit-polyfills": "^1.0.4"[m
[32m+[m[32m            },[m
[32m+[m[32m            "suggest": {[m
[32m+[m[32m                "decomplexity/SendOauth2": "Adapter for using XOAUTH2 authentication",[m
[32m+[m[32m                "ext-mbstring": "Needed to send email in multibyte encoding charset or decode encoded addresses",[m
[32m+[m[32m                "ext-openssl": "Needed for secure SMTP sending and DKIM signing",[m
[32m+[m[32m                "greew/oauth2-azure-provider": "Needed for Microsoft Azure XOAUTH2 authentication",[m
[32m+[m[32m                "hayageek/oauth2-yahoo": "Needed for Yahoo XOAUTH2 authentication",[m
[32m+[m[32m                "league/oauth2-google": "Needed for Google XOAUTH2 authentication",[m
[32m+[m[32m                "psr/log": "For optional PSR-3 debug logging",[m
[32m+[m[32m                "symfony/polyfill-mbstring": "To support UTF-8 if the Mbstring PHP extension is not enabled (^1.2)",[m
[32m+[m[32m                "thenetworg/oauth2-azure": "Needed for Microsoft XOAUTH2 authentication"[m
[32m+[m[32m            },[m
[32m+[m[32m            "type": "library",[m
[32m+[m[32m            "autoload": {[m
[32m+[m[32m                "psr-4": {[m
[32m+[m[32m                    "PHPMailer\\PHPMailer\\": "src/"[m
[32m+[m[32m                }[m
[32m+[m[32m            },[m
[32m+[m[32m            "notification-url": "https://packagist.org/downloads/",[m
[32m+[m[32m            "license": [[m
[32m+[m[32m                "LGPL-2.1-only"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "authors": [[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Marcus Bointon",[m
[32m+[m[32m                    "email": "phpmailer@synchromedia.co.uk"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Jim Jagielski",[m
[32m+[m[32m                    "email": "jimjag@gmail.com"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Andy Prevost",[m
[32m+[m[32m                    "email": "codeworxtech@users.sourceforge.net"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Brent R. Matzelle"[m
[32m+[m[32m                }[m
[32m+[m[32m            ],[m
[32m+[m[32m            "description": "PHPMailer is a full-featured email creation and transfer class for PHP",[m
[32m+[m[32m            "support": {[m
[32m+[m[32m                "issues": "https://github.com/PHPMailer/PHPMailer/issues",[m
[32m+[m[32m                "source": "https://github.com/PHPMailer/PHPMailer/tree/v6.10.0"[m
[32m+[m[32m            },[m
[32m+[m[32m            "funding": [[m
[32m+[m[32m                {[m
[32m+[m[32m                    "url": "https://github.com/Synchro",[m
[32m+[m[32m                    "type": "github"[m
[32m+[m[32m                }[m
[32m+[m[32m            ],[m
[32m+[m[32m            "time": "2025-04-24T15:19:31+00:00"[m
[32m+[m[32m        },[m
[32m+[m[32m        {[m
[32m+[m[32m            "name": "phpseclib/phpseclib",[m
[32m+[m[32m            "version": "3.0.45",[m
[32m+[m[32m            "source": {[m
[32m+[m[32m                "type": "git",[m
[32m+[m[32m                "url": "https://github.com/phpseclib/phpseclib.git",[m
[32m+[m[32m                "reference": "bd81b90d5963c6b9d87de50357585375223f4dd8"[m
[32m+[m[32m            },[m
[32m+[m[32m            "dist": {[m
[32m+[m[32m                "type": "zip",[m
[32m+[m[32m                "url": "https://api.github.com/repos/phpseclib/phpseclib/zipball/bd81b90d5963c6b9d87de50357585375223f4dd8",[m
[32m+[m[32m                "reference": "bd81b90d5963c6b9d87de50357585375223f4dd8",[m
[32m+[m[32m                "shasum": ""[m
[32m+[m[32m            },[m
[32m+[m[32m            "require": {[m
[32m+[m[32m                "paragonie/constant_time_encoding": "^1|^2|^3",[m
[32m+[m[32m                "paragonie/random_compat": "^1.4|^2.0|^9.99.99",[m
[32m+[m[32m                "php": ">=5.6.1"[m
[32m+[m[32m            },[m
[32m+[m[32m            "require-dev": {[m
[32m+[m[32m                "phpunit/phpunit": "*"[m
[32m+[m[32m            },[m
[32m+[m[32m            "suggest": {[m
[32m+[m[32m                "ext-dom": "Install the DOM extension to load XML formatted public keys.",[m
[32m+[m[32m                "ext-gmp": "Install the GMP (GNU Multiple Precision) extension in order to speed up arbitrary precision integer arithmetic operations.",[m
[32m+[m[32m                "ext-libsodium": "SSH2/SFTP can make use of some algorithms provided by the libsodium-php extension.",[m
[32m+[m[32m                "ext-mcrypt": "Install the Mcrypt extension in order to speed up a few other cryptographic operations.",[m
[32m+[m[32m                "ext-openssl": "Install the OpenSSL extension in order to speed up a wide variety of cryptographic operations."[m
[32m+[m[32m            },[m
[32m+[m[32m            "type": "library",[m
[32m+[m[32m            "autoload": {[m
[32m+[m[32m                "files": [[m
[32m+[m[32m                    "phpseclib/bootstrap.php"[m
[32m+[m[32m                ],[m
[32m+[m[32m                "psr-4": {[m
[32m+[m[32m                    "phpseclib3\\": "phpseclib/"[m
[32m+[m[32m                }[m
[32m+[m[32m            },[m
[32m+[m[32m            "notification-url": "https://packagist.org/downloads/",[m
[32m+[m[32m            "license": [[m
[32m+[m[32m                "MIT"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "authors": [[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Jim Wigginton",[m
[32m+[m[32m                    "email": "terrafrost@php.net",[m
[32m+[m[32m                    "role": "Lead Developer"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Patrick Monnerat",[m
[32m+[m[32m                    "email": "pm@datasphere.ch",[m
[32m+[m[32m                    "role": "Developer"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Andreas Fischer",[m
[32m+[m[32m                    "email": "bantu@phpbb.com",[m
[32m+[m[32m                    "role": "Developer"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Hans-Jürgen Petrich",[m
[32m+[m[32m                    "email": "petrich@tronic-media.com",[m
[32m+[m[32m                    "role": "Developer"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Graham Campbell",[m
[32m+[m[32m                    "email": "graham@alt-three.com",[m
[32m+[m[32m                    "role": "Developer"[m
[32m+[m[32m                }[m
[32m+[m[32m            ],[m
[32m+[m[32m            "description": "PHP Secure Communications Library - Pure-PHP implementations of RSA, AES, SSH2, SFTP, X.509 etc.",[m
[32m+[m[32m            "homepage": "http://phpseclib.sourceforge.net",[m
[32m+[m[32m            "keywords": [[m
[32m+[m[32m                "BigInteger",[m
[32m+[m[32m                "aes",[m
[32m+[m[32m                "asn.1",[m
[32m+[m[32m                "asn1",[m
[32m+[m[32m                "blowfish",[m
[32m+[m[32m                "crypto",[m
[32m+[m[32m                "cryptography",[m
[32m+[m[32m                "encryption",[m
[32m+[m[32m                "rsa",[m
[32m+[m[32m                "security",[m
[32m+[m[32m                "sftp",[m
[32m+[m[32m                "signature",[m
[32m+[m[32m                "signing",[m
[32m+[m[32m                "ssh",[m
[32m+[m[32m                "twofish",[m
[32m+[m[32m                "x.509",[m
[32m+[m[32m                "x509"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "support": {[m
[32m+[m[32m                "issues": "https://github.com/phpseclib/phpseclib/issues",[m
[32m+[m[32m                "source": "https://github.com/phpseclib/phpseclib/tree/3.0.45"[m
[32m+[m[32m            },[m
[32m+[m[32m            "funding": [[m
[32m+[m[32m                {[m
[32m+[m[32m                    "url": "https://github.com/terrafrost",[m
[32m+[m[32m                    "type": "github"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "url": "https://www.patreon.com/phpseclib",[m
[32m+[m[32m                    "type": "patreon"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "url": "https://tidelift.com/funding/github/packagist/phpseclib/phpseclib",[m
[32m+[m[32m                    "type": "tidelift"[m
[32m+[m[32m                }[m
[32m+[m[32m            ],[m
[32m+[m[32m            "time": "2025-06-22T22:54:43+00:00"[m
[32m+[m[32m        },[m
[32m+[m[32m        {[m
[32m+[m[32m            "name": "psr/cache",[m
[32m+[m[32m            "version": "3.0.0",[m
[32m+[m[32m            "source": {[m
[32m+[m[32m                "type": "git",[m
[32m+[m[32m                "url": "https://github.com/php-fig/cache.git",[m
[32m+[m[32m                "reference": "aa5030cfa5405eccfdcb1083ce040c2cb8d253bf"[m
[32m+[m[32m            },[m
[32m+[m[32m            "dist": {[m
[32m+[m[32m                "type": "zip",[m
[32m+[m[32m                "url": "https://api.github.com/repos/php-fig/cache/zipball/aa5030cfa5405eccfdcb1083ce040c2cb8d253bf",[m
[32m+[m[32m                "reference": "aa5030cfa5405eccfdcb1083ce040c2cb8d253bf",[m
[32m+[m[32m                "shasum": ""[m
[32m+[m[32m            },[m
[32m+[m[32m            "require": {[m
[32m+[m[32m                "php": ">=8.0.0"[m
[32m+[m[32m            },[m
[32m+[m[32m            "type": "library",[m
[32m+[m[32m            "extra": {[m
[32m+[m[32m                "branch-alias": {[m
[32m+[m[32m                    "dev-master": "1.0.x-dev"[m
[32m+[m[32m                }[m
[32m+[m[32m            },[m
[32m+[m[32m            "autoload": {[m
[32m+[m[32m                "psr-4": {[m
[32m+[m[32m                    "Psr\\Cache\\": "src/"[m
[32m+[m[32m                }[m
[32m+[m[32m            },[m
[32m+[m[32m            "notification-url": "https://packagist.org/downloads/",[m
[32m+[m[32m            "license": [[m
[32m+[m[32m                "MIT"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "authors": [[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "PHP-FIG",[m
[32m+[m[32m                    "homepage": "https://www.php-fig.org/"[m
[32m+[m[32m                }[m
[32m+[m[32m            ],[m
[32m+[m[32m            "description": "Common interface for caching libraries",[m
[32m+[m[32m            "keywords": [[m
[32m+[m[32m                "cache",[m
[32m+[m[32m                "psr",[m
[32m+[m[32m                "psr-6"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "support": {[m
[32m+[m[32m                "source": "https://github.com/php-fig/cache/tree/3.0.0"[m
[32m+[m[32m            },[m
[32m+[m[32m            "time": "2021-02-03T23:26:27+00:00"[m
[32m+[m[32m        },[m
[32m+[m[32m        {[m
[32m+[m[32m            "name": "psr/container",[m
[32m+[m[32m            "version": "2.0.2",[m
[32m+[m[32m            "source": {[m
[32m+[m[32m                "type": "git",[m
[32m+[m[32m                "url": "https://github.com/php-fig/container.git",[m
[32m+[m[32m                "reference": "c71ecc56dfe541dbd90c5360474fbc405f8d5963"[m
[32m+[m[32m            },[m
[32m+[m[32m            "dist": {[m
[32m+[m[32m                "type": "zip",[m
[32m+[m[32m                "url": "https://api.github.com/repos/php-fig/container/zipball/c71ecc56dfe541dbd90c5360474fbc405f8d5963",[m
[32m+[m[32m                "reference": "c71ecc56dfe541dbd90c5360474fbc405f8d5963",[m
[32m+[m[32m                "shasum": ""[m
[32m+[m[32m            },[m
[32m+[m[32m            "require": {[m
[32m+[m[32m                "php": ">=7.4.0"[m
[32m+[m[32m            },[m
[32m+[m[32m            "type": "library",[m
[32m+[m[32m            "extra": {[m
[32m+[m[32m                "branch-alias": {[m
[32m+[m[32m                    "dev-master": "2.0.x-dev"[m
[32m+[m[32m                }[m
[32m+[m[32m            },[m
[32m+[m[32m            "autoload": {[m
[32m+[m[32m                "psr-4": {[m
[32m+[m[32m                    "Psr\\Container\\": "src/"[m
[32m+[m[32m                }[m
[32m+[m[32m            },[m
[32m+[m[32m            "notification-url": "https://packagist.org/downloads/",[m
[32m+[m[32m            "license": [[m
[32m+[m[32m                "MIT"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "authors": [[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "PHP-FIG",[m
[32m+[m[32m                    "homepage": "https://www.php-fig.org/"[m
[32m+[m[32m                }[m
[32m+[m[32m            ],[m
[32m+[m[32m            "description": "Common Container Interface (PHP FIG PSR-11)",[m
[32m+[m[32m            "homepage": "https://github.com/php-fig/container",[m
[32m+[m[32m            "keywords": [[m
[32m+[m[32m                "PSR-11",[m
[32m+[m[32m                "container",[m
[32m+[m[32m                "container-interface",[m
[32m+[m[32m                "container-interop",[m
[32m+[m[32m                "psr"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "support": {[m
[32m+[m[32m                "issues": "https://github.com/php-fig/container/issues",[m
[32m+[m[32m                "source": "https://github.com/php-fig/container/tree/2.0.2"[m
[32m+[m[32m            },[m
[32m+[m[32m            "time": "2021-11-05T16:47:00+00:00"[m
[32m+[m[32m        },[m
[32m+[m[32m        {[m
[32m+[m[32m            "name": "psr/http-client",[m
[32m+[m[32m            "version": "1.0.3",[m
[32m+[m[32m            "source": {[m
[32m+[m[32m                "type": "git",[m
[32m+[m[32m                "url": "https://github.com/php-fig/http-client.git",[m
[32m+[m[32m                "reference": "bb5906edc1c324c9a05aa0873d40117941e5fa90"[m
[32m+[m[32m            },[m
[32m+[m[32m            "dist": {[m
[32m+[m[32m                "type": "zip",[m
[32m+[m[32m                "url": "https://api.github.com/repos/php-fig/http-client/zipball/bb5906edc1c324c9a05aa0873d40117941e5fa90",[m
[32m+[m[32m                "reference": "bb5906edc1c324c9a05aa0873d40117941e5fa90",[m
[32m+[m[32m                "shasum": ""[m
[32m+[m[32m            },[m
[32m+[m[32m            "require": {[m
[32m+[m[32m                "php": "^7.0 || ^8.0",[m
[32m+[m[32m                "psr/http-message": "^1.0 || ^2.0"[m
[32m+[m[32m            },[m
[32m+[m[32m            "type": "library",[m
[32m+[m[32m            "extra": {[m
[32m+[m[32m                "branch-alias": {[m
[32m+[m[32m                    "dev-master": "1.0.x-dev"[m
[32m+[m[32m                }[m
[32m+[m[32m            },[m
[32m+[m[32m            "autoload": {[m
[32m+[m[32m                "psr-4": {[m
[32m+[m[32m                    "Psr\\Http\\Client\\": "src/"[m
[32m+[m[32m                }[m
[32m+[m[32m            },[m
[32m+[m[32m            "notification-url": "https://packagist.org/downloads/",[m
[32m+[m[32m            "license": [[m
[32m+[m[32m                "MIT"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "authors": [[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "PHP-FIG",[m
[32m+[m[32m                    "homepage": "https://www.php-fig.org/"[m
[32m+[m[32m                }[m
[32m+[m[32m            ],[m
[32m+[m[32m            "description": "Common interface for HTTP clients",[m
[32m+[m[32m            "homepage": "https://github.com/php-fig/http-client",[m
[32m+[m[32m            "keywords": [[m
[32m+[m[32m                "http",[m
[32m+[m[32m                "http-client",[m
[32m+[m[32m                "psr",[m
[32m+[m[32m                "psr-18"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "support": {[m
[32m+[m[32m                "source": "https://github.com/php-fig/http-client"[m
[32m+[m[32m            },[m
[32m+[m[32m            "time": "2023-09-23T14:17:50+00:00"[m
[32m+[m[32m        },[m
[32m+[m[32m        {[m
[32m+[m[32m            "name": "psr/http-factory",[m
[32m+[m[32m            "version": "1.1.0",[m
[32m+[m[32m            "source": {[m
[32m+[m[32m                "type": "git",[m
[32m+[m[32m                "url": "https://github.com/php-fig/http-factory.git",[m
[32m+[m[32m                "reference": "2b4765fddfe3b508ac62f829e852b1501d3f6e8a"[m
[32m+[m[32m            },[m
[32m+[m[32m            "dist": {[m
[32m+[m[32m                "type": "zip",[m
[32m+[m[32m                "url": "https://api.github.com/repos/php-fig/http-factory/zipball/2b4765fddfe3b508ac62f829e852b1501d3f6e8a",[m
[32m+[m[32m                "reference": "2b4765fddfe3b508ac62f829e852b1501d3f6e8a",[m
[32m+[m[32m                "shasum": ""[m
[32m+[m[32m            },[m
[32m+[m[32m            "require": {[m
[32m+[m[32m                "php": ">=7.1",[m
[32m+[m[32m                "psr/http-message": "^1.0 || ^2.0"[m
[32m+[m[32m            },[m
[32m+[m[32m            "type": "library",[m
[32m+[m[32m            "extra": {[m
[32m+[m[32m                "branch-alias": {[m
[32m+[m[32m                    "dev-master": "1.0.x-dev"[m
[32m+[m[32m                }[m
[32m+[m[32m            },[m
[32m+[m[32m            "autoload": {[m
[32m+[m[32m                "psr-4": {[m
[32m+[m[32m                    "Psr\\Http\\Message\\": "src/"[m
[32m+[m[32m                }[m
[32m+[m[32m            },[m
[32m+[m[32m            "notification-url": "https://packagist.org/downloads/",[m
[32m+[m[32m            "license": [[m
[32m+[m[32m                "MIT"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "authors": [[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "PHP-FIG",[m
[32m+[m[32m                    "homepage": "https://www.php-fig.org/"[m
[32m+[m[32m                }[m
[32m+[m[32m            ],[m
[32m+[m[32m            "description": "PSR-17: Common interfaces for PSR-7 HTTP message factories",[m
[32m+[m[32m            "keywords": [[m
[32m+[m[32m                "factory",[m
[32m+[m[32m                "http",[m
[32m+[m[32m                "message",[m
[32m+[m[32m                "psr",[m
[32m+[m[32m                "psr-17",[m
[32m+[m[32m                "psr-7",[m
[32m+[m[32m                "request",[m
[32m+[m[32m                "response"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "support": {[m
[32m+[m[32m                "source": "https://github.com/php-fig/http-factory"[m
[32m+[m[32m            },[m
[32m+[m[32m            "time": "2024-04-15T12:06:14+00:00"[m
[32m+[m[32m        },[m
[32m+[m[32m        {[m
[32m+[m[32m            "name": "psr/http-message",[m
[32m+[m[32m            "version": "2.0",[m
[32m+[m[32m            "source": {[m
[32m+[m[32m                "type": "git",[m
[32m+[m[32m                "url": "https://github.com/php-fig/http-message.git",[m
[32m+[m[32m                "reference": "402d35bcb92c70c026d1a6a9883f06b2ead23d71"[m
[32m+[m[32m            },[m
[32m+[m[32m            "dist": {[m
[32m+[m[32m                "type": "zip",[m
[32m+[m[32m                "url": "https://api.github.com/repos/php-fig/http-message/zipball/402d35bcb92c70c026d1a6a9883f06b2ead23d71",[m
[32m+[m[32m                "reference": "402d35bcb92c70c026d1a6a9883f06b2ead23d71",[m
[32m+[m[32m                "shasum": ""[m
[32m+[m[32m            },[m
[32m+[m[32m            "require": {[m
[32m+[m[32m                "php": "^7.2 || ^8.0"[m
[32m+[m[32m            },[m
[32m+[m[32m            "type": "library",[m
[32m+[m[32m            "extra": {[m
[32m+[m[32m                "branch-alias": {[m
[32m+[m[32m                    "dev-master": "2.0.x-dev"[m
[32m+[m[32m                }[m
[32m+[m[32m            },[m
[32m+[m[32m            "autoload": {[m
[32m+[m[32m                "psr-4": {[m
[32m+[m[32m                    "Psr\\Http\\Message\\": "src/"[m
[32m+[m[32m                }[m
[32m+[m[32m            },[m
[32m+[m[32m            "notification-url": "https://packagist.org/downloads/",[m
[32m+[m[32m            "license": [[m
[32m+[m[32m                "MIT"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "authors": [[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "PHP-FIG",[m
[32m+[m[32m                    "homepage": "https://www.php-fig.org/"[m
[32m+[m[32m                }[m
[32m+[m[32m            ],[m
[32m+[m[32m            "description": "Common interface for HTTP messages",[m
[32m+[m[32m            "homepage": "https://github.com/php-fig/http-message",[m
[32m+[m[32m            "keywords": [[m
[32m+[m[32m                "http",[m
[32m+[m[32m                "http-message",[m
[32m+[m[32m                "psr",[m
[32m+[m[32m                "psr-7",[m
[32m+[m[32m                "request",[m
[32m+[m[32m                "response"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "support": {[m
[32m+[m[32m                "source": "https://github.com/php-fig/http-message/tree/2.0"[m
[32m+[m[32m            },[m
[32m+[m[32m            "time": "2023-04-04T09:54:51+00:00"[m
[32m+[m[32m        },[m
[32m+[m[32m        {[m
[32m+[m[32m            "name": "psr/log",[m
[32m+[m[32m            "version": "3.0.2",[m
[32m+[m[32m            "source": {[m
[32m+[m[32m                "type": "git",[m
[32m+[m[32m                "url": "https://github.com/php-fig/log.git",[m
[32m+[m[32m                "reference": "f16e1d5863e37f8d8c2a01719f5b34baa2b714d3"[m
[32m+[m[32m            },[m
[32m+[m[32m            "dist": {[m
[32m+[m[32m                "type": "zip",[m
[32m+[m[32m                "url": "https://api.github.com/repos/php-fig/log/zipball/f16e1d5863e37f8d8c2a01719f5b34baa2b714d3",[m
[32m+[m[32m                "reference": "f16e1d5863e37f8d8c2a01719f5b34baa2b714d3",[m
[32m+[m[32m                "shasum": ""[m
[32m+[m[32m            },[m
[32m+[m[32m            "require": {[m
[32m+[m[32m                "php": ">=8.0.0"[m
[32m+[m[32m            },[m
[32m+[m[32m            "type": "library",[m
[32m+[m[32m            "extra": {[m
[32m+[m[32m                "branch-alias": {[m
[32m+[m[32m                    "dev-master": "3.x-dev"[m
[32m+[m[32m                }[m
[32m+[m[32m            },[m
[32m+[m[32m            "autoload": {[m
[32m+[m[32m                "psr-4": {[m
[32m+[m[32m                    "Psr\\Log\\": "src"[m
[32m+[m[32m                }[m
[32m+[m[32m            },[m
[32m+[m[32m            "notification-url": "https://packagist.org/downloads/",[m
[32m+[m[32m            "license": [[m
[32m+[m[32m                "MIT"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "authors": [[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "PHP-FIG",[m
[32m+[m[32m                    "homepage": "https://www.php-fig.org/"[m
[32m+[m[32m                }[m
[32m+[m[32m            ],[m
[32m+[m[32m            "description": "Common interface for logging libraries",[m
[32m+[m[32m            "homepage": "https://github.com/php-fig/log",[m
[32m+[m[32m            "keywords": [[m
[32m+[m[32m                "log",[m
[32m+[m[32m                "psr",[m
[32m+[m[32m                "psr-3"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "support": {[m
[32m+[m[32m                "source": "https://github.com/php-fig/log/tree/3.0.2"[m
[32m+[m[32m            },[m
[32m+[m[32m            "time": "2024-09-11T13:17:53+00:00"[m
[32m+[m[32m        },[m
[32m+[m[32m        {[m
[32m+[m[32m            "name": "ralouphie/getallheaders",[m
[32m+[m[32m            "version": "3.0.3",[m
[32m+[m[32m            "source": {[m
[32m+[m[32m                "type": "git",[m
[32m+[m[32m                "url": "https://github.com/ralouphie/getallheaders.git",[m
[32m+[m[32m                "reference": "120b605dfeb996808c31b6477290a714d356e822"[m
[32m+[m[32m            },[m
[32m+[m[32m            "dist": {[m
[32m+[m[32m                "type": "zip",[m
[32m+[m[32m                "url": "https://api.github.com/repos/ralouphie/getallheaders/zipball/120b605dfeb996808c31b6477290a714d356e822",[m
[32m+[m[32m                "reference": "120b605dfeb996808c31b6477290a714d356e822",[m
[32m+[m[32m                "shasum": ""[m
[32m+[m[32m            },[m
[32m+[m[32m            "require": {[m
[32m+[m[32m                "php": ">=5.6"[m
[32m+[m[32m            },[m
[32m+[m[32m            "require-dev": {[m
[32m+[m[32m                "php-coveralls/php-coveralls": "^2.1",[m
[32m+[m[32m                "phpunit/phpunit": "^5 || ^6.5"[m
[32m+[m[32m            },[m
[32m+[m[32m            "type": "library",[m
[32m+[m[32m            "autoload": {[m
[32m+[m[32m                "files": [[m
[32m+[m[32m                    "src/getallheaders.php"[m
[32m+[m[32m                ][m
[32m+[m[32m            },[m
[32m+[m[32m            "notification-url": "https://packagist.org/downloads/",[m
[32m+[m[32m            "license": [[m
[32m+[m[32m                "MIT"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "authors": [[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Ralph Khattar",[m
[32m+[m[32m                    "email": "ralph.khattar@gmail.com"[m
[32m+[m[32m                }[m
[32m+[m[32m            ],[m
[32m+[m[32m            "description": "A polyfill for getallheaders.",[m
[32m+[m[32m            "support": {[m
[32m+[m[32m                "issues": "https://github.com/ralouphie/getallheaders/issues",[m
[32m+[m[32m                "source": "https://github.com/ralouphie/getallheaders/tree/develop"[m
[32m+[m[32m            },[m
[32m+[m[32m            "time": "2019-03-08T08:55:37+00:00"[m
[32m+[m[32m        },[m
[32m+[m[32m        {[m
[32m+[m[32m            "name": "symfony/console",[m
[32m+[m[32m            "version": "v7.3.0",[m
[32m+[m[32m            "source": {[m
[32m+[m[32m                "type": "git",[m
[32m+[m[32m                "url": "https://github.com/symfony/console.git",[m
[32m+[m[32m                "reference": "66c1440edf6f339fd82ed6c7caa76cb006211b44"[m
[32m+[m[32m            },[m
[32m+[m[32m            "dist": {[m
[32m+[m[32m                "type": "zip",[m
[32m+[m[32m                "url": "https://api.github.com/repos/symfony/console/zipball/66c1440edf6f339fd82ed6c7caa76cb006211b44",[m
[32m+[m[32m                "reference": "66c1440edf6f339fd82ed6c7caa76cb006211b44",[m
[32m+[m[32m                "shasum": ""[m
[32m+[m[32m            },[m
[32m+[m[32m            "require": {[m
[32m+[m[32m                "php": ">=8.2",[m
[32m+[m[32m                "symfony/deprecation-contracts": "^2.5|^3",[m
[32m+[m[32m                "symfony/polyfill-mbstring": "~1.0",[m
[32m+[m[32m                "symfony/service-contracts": "^2.5|^3",[m
[32m+[m[32m                "symfony/string": "^7.2"[m
[32m+[m[32m            },[m
[32m+[m[32m            "conflict": {[m
[32m+[m[32m                "symfony/dependency-injection": "<6.4",[m
[32m+[m[32m                "symfony/dotenv": "<6.4",[m
[32m+[m[32m                "symfony/event-dispatcher": "<6.4",[m
[32m+[m[32m                "symfony/lock": "<6.4",[m
[32m+[m[32m                "symfony/process": "<6.4"[m
[32m+[m[32m            },[m
[32m+[m[32m            "provide": {[m
[32m+[m[32m                "psr/log-implementation": "1.0|2.0|3.0"[m
[32m+[m[32m            },[m
[32m+[m[32m            "require-dev": {[m
[32m+[m[32m                "psr/log": "^1|^2|^3",[m
[32m+[m[32m                "symfony/config": "^6.4|^7.0",[m
[32m+[m[32m                "symfony/dependency-injection": "^6.4|^7.0",[m
[32m+[m[32m                "symfony/event-dispatcher": "^6.4|^7.0",[m
[32m+[m[32m                "symfony/http-foundation": "^6.4|^7.0",[m
[32m+[m[32m                "symfony/http-kernel": "^6.4|^7.0",[m
[32m+[m[32m                "symfony/lock": "^6.4|^7.0",[m
[32m+[m[32m                "symfony/messenger": "^6.4|^7.0",[m
[32m+[m[32m                "symfony/process": "^6.4|^7.0",[m
[32m+[m[32m                "symfony/stopwatch": "^6.4|^7.0",[m
[32m+[m[32m                "symfony/var-dumper": "^6.4|^7.0"[m
[32m+[m[32m            },[m
[32m+[m[32m            "type": "library",[m
[32m+[m[32m            "autoload": {[m
[32m+[m[32m                "psr-4": {[m
[32m+[m[32m                    "Symfony\\Component\\Console\\": ""[m
[32m+[m[32m                },[m
[32m+[m[32m                "exclude-from-classmap": [[m
[32m+[m[32m                    "/Tests/"[m
[32m+[m[32m                ][m
[32m+[m[32m            },[m
[32m+[m[32m            "notification-url": "https://packagist.org/downloads/",[m
[32m+[m[32m            "license": [[m
[32m+[m[32m                "MIT"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "authors": [[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Fabien Potencier",[m
[32m+[m[32m                    "email": "fabien@symfony.com"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Symfony Community",[m
[32m+[m[32m                    "homepage": "https://symfony.com/contributors"[m
[32m+[m[32m                }[m
[32m+[m[32m            ],[m
[32m+[m[32m            "description": "Eases the creation of beautiful and testable command line interfaces",[m
[32m+[m[32m            "homepage": "https://symfony.com",[m
[32m+[m[32m            "keywords": [[m
[32m+[m[32m                "cli",[m
[32m+[m[32m                "command-line",[m
[32m+[m[32m                "console",[m
[32m+[m[32m                "terminal"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "support": {[m
[32m+[m[32m                "source": "https://github.com/symfony/console/tree/v7.3.0"[m
[32m+[m[32m            },[m
[32m+[m[32m            "funding": [[m
[32m+[m[32m                {[m
[32m+[m[32m                    "url": "https://symfony.com/sponsor",[m
[32m+[m[32m                    "type": "custom"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "url": "https://github.com/fabpot",[m
[32m+[m[32m                    "type": "github"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "url": "https://tidelift.com/funding/github/packagist/symfony/symfony",[m
[32m+[m[32m                    "type": "tidelift"[m
[32m+[m[32m                }[m
[32m+[m[32m            ],[m
[32m+[m[32m            "time": "2025-05-24T10:34:04+00:00"[m
[32m+[m[32m        },[m
[32m+[m[32m        {[m
[32m+[m[32m            "name": "symfony/deprecation-contracts",[m
[32m+[m[32m            "version": "v3.6.0",[m
[32m+[m[32m            "source": {[m
[32m+[m[32m                "type": "git",[m
[32m+[m[32m                "url": "https://github.com/symfony/deprecation-contracts.git",[m
[32m+[m[32m                "reference": "63afe740e99a13ba87ec199bb07bbdee937a5b62"[m
[32m+[m[32m            },[m
[32m+[m[32m            "dist": {[m
[32m+[m[32m                "type": "zip",[m
[32m+[m[32m                "url": "https://api.github.com/repos/symfony/deprecation-contracts/zipball/63afe740e99a13ba87ec199bb07bbdee937a5b62",[m
[32m+[m[32m                "reference": "63afe740e99a13ba87ec199bb07bbdee937a5b62",[m
[32m+[m[32m                "shasum": ""[m
[32m+[m[32m            },[m
[32m+[m[32m            "require": {[m
[32m+[m[32m                "php": ">=8.1"[m
[32m+[m[32m            },[m
[32m+[m[32m            "type": "library",[m
[32m+[m[32m            "extra": {[m
[32m+[m[32m                "thanks": {[m
[32m+[m[32m                    "url": "https://github.com/symfony/contracts",[m
[32m+[m[32m                    "name": "symfony/contracts"[m
[32m+[m[32m                },[m
[32m+[m[32m                "branch-alias": {[m
[32m+[m[32m                    "dev-main": "3.6-dev"[m
[32m+[m[32m                }[m
[32m+[m[32m            },[m
[32m+[m[32m            "autoload": {[m
[32m+[m[32m                "files": [[m
[32m+[m[32m                    "function.php"[m
[32m+[m[32m                ][m
[32m+[m[32m            },[m
[32m+[m[32m            "notification-url": "https://packagist.org/downloads/",[m
[32m+[m[32m            "license": [[m
[32m+[m[32m                "MIT"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "authors": [[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Nicolas Grekas",[m
[32m+[m[32m                    "email": "p@tchwork.com"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Symfony Community",[m
[32m+[m[32m                    "homepage": "https://symfony.com/contributors"[m
[32m+[m[32m                }[m
[32m+[m[32m            ],[m
[32m+[m[32m            "description": "A generic function and convention to trigger deprecation notices",[m
[32m+[m[32m            "homepage": "https://symfony.com",[m
[32m+[m[32m            "support": {[m
[32m+[m[32m                "source": "https://github.com/symfony/deprecation-contracts/tree/v3.6.0"[m
[32m+[m[32m            },[m
[32m+[m[32m            "funding": [[m
[32m+[m[32m                {[m
[32m+[m[32m                    "url": "https://symfony.com/sponsor",[m
[32m+[m[32m                    "type": "custom"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "url": "https://github.com/fabpot",[m
[32m+[m[32m                    "type": "github"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "url": "https://tidelift.com/funding/github/packagist/symfony/symfony",[m
[32m+[m[32m                    "type": "tidelift"[m
[32m+[m[32m                }[m
[32m+[m[32m            ],[m
[32m+[m[32m            "time": "2024-09-25T14:21:43+00:00"[m
[32m+[m[32m        },[m
[32m+[m[32m        {[m
[32m+[m[32m            "name": "symfony/polyfill-ctype",[m
[32m+[m[32m            "version": "v1.32.0",[m
[32m+[m[32m            "source": {[m
[32m+[m[32m                "type": "git",[m
[32m+[m[32m                "url": "https://github.com/symfony/polyfill-ctype.git",[m
[32m+[m[32m                "reference": "a3cc8b044a6ea513310cbd48ef7333b384945638"[m
[32m+[m[32m            },[m
[32m+[m[32m            "dist": {[m
[32m+[m[32m                "type": "zip",[m
[32m+[m[32m                "url": "https://api.github.com/repos/symfony/polyfill-ctype/zipball/a3cc8b044a6ea513310cbd48ef7333b384945638",[m
[32m+[m[32m                "reference": "a3cc8b044a6ea513310cbd48ef7333b384945638",[m
[32m+[m[32m                "shasum": ""[m
[32m+[m[32m            },[m
[32m+[m[32m            "require": {[m
[32m+[m[32m                "php": ">=7.2"[m
[32m+[m[32m            },[m
[32m+[m[32m            "provide": {[m
[32m+[m[32m                "ext-ctype": "*"[m
[32m+[m[32m            },[m
[32m+[m[32m            "suggest": {[m
[32m+[m[32m                "ext-ctype": "For best performance"[m
[32m+[m[32m            },[m
[32m+[m[32m            "type": "library",[m
[32m+[m[32m            "extra": {[m
[32m+[m[32m                "thanks": {[m
[32m+[m[32m                    "url": "https://github.com/symfony/polyfill",[m
[32m+[m[32m                    "name": "symfony/polyfill"[m
[32m+[m[32m                }[m
[32m+[m[32m            },[m
[32m+[m[32m            "autoload": {[m
[32m+[m[32m                "files": [[m
[32m+[m[32m                    "bootstrap.php"[m
[32m+[m[32m                ],[m
[32m+[m[32m                "psr-4": {[m
[32m+[m[32m                    "Symfony\\Polyfill\\Ctype\\": ""[m
[32m+[m[32m                }[m
[32m+[m[32m            },[m
[32m+[m[32m            "notification-url": "https://packagist.org/downloads/",[m
[32m+[m[32m            "license": [[m
[32m+[m[32m                "MIT"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "authors": [[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Gert de Pagter",[m
[32m+[m[32m                    "email": "BackEndTea@gmail.com"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Symfony Community",[m
[32m+[m[32m                    "homepage": "https://symfony.com/contributors"[m
[32m+[m[32m                }[m
[32m+[m[32m            ],[m
[32m+[m[32m            "description": "Symfony polyfill for ctype functions",[m
[32m+[m[32m            "homepage": "https://symfony.com",[m
[32m+[m[32m            "keywords": [[m
[32m+[m[32m                "compatibility",[m
[32m+[m[32m                "ctype",[m
[32m+[m[32m                "polyfill",[m
[32m+[m[32m                "portable"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "support": {[m
[32m+[m[32m                "source": "https://github.com/symfony/polyfill-ctype/tree/v1.32.0"[m
[32m+[m[32m            },[m
[32m+[m[32m            "funding": [[m
[32m+[m[32m                {[m
[32m+[m[32m                    "url": "https://symfony.com/sponsor",[m
[32m+[m[32m                    "type": "custom"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "url": "https://github.com/fabpot",[m
[32m+[m[32m                    "type": "github"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "url": "https://tidelift.com/funding/github/packagist/symfony/symfony",[m
[32m+[m[32m                    "type": "tidelift"[m
[32m+[m[32m                }[m
[32m+[m[32m            ],[m
[32m+[m[32m            "time": "2024-09-09T11:45:10+00:00"[m
[32m+[m[32m        },[m
[32m+[m[32m        {[m
[32m+[m[32m            "name": "symfony/polyfill-intl-grapheme",[m
[32m+[m[32m            "version": "v1.32.0",[m
[32m+[m[32m            "source": {[m
[32m+[m[32m                "type": "git",[m
[32m+[m[32m                "url": "https://github.com/symfony/polyfill-intl-grapheme.git",[m
[32m+[m[32m                "reference": "b9123926e3b7bc2f98c02ad54f6a4b02b91a8abe"[m
[32m+[m[32m            },[m
[32m+[m[32m            "dist": {[m
[32m+[m[32m                "type": "zip",[m
[32m+[m[32m                "url": "https://api.github.com/repos/symfony/polyfill-intl-grapheme/zipball/b9123926e3b7bc2f98c02ad54f6a4b02b91a8abe",[m
[32m+[m[32m                "reference": "b9123926e3b7bc2f98c02ad54f6a4b02b91a8abe",[m
[32m+[m[32m                "shasum": ""[m
[32m+[m[32m            },[m
[32m+[m[32m            "require": {[m
[32m+[m[32m                "php": ">=7.2"[m
[32m+[m[32m            },[m
[32m+[m[32m            "suggest": {[m
[32m+[m[32m                "ext-intl": "For best performance"[m
[32m+[m[32m            },[m
[32m+[m[32m            "type": "library",[m
[32m+[m[32m            "extra": {[m
[32m+[m[32m                "thanks": {[m
[32m+[m[32m                    "url": "https://github.com/symfony/polyfill",[m
[32m+[m[32m                    "name": "symfony/polyfill"[m
[32m+[m[32m                }[m
[32m+[m[32m            },[m
[32m+[m[32m            "autoload": {[m
[32m+[m[32m                "files": [[m
[32m+[m[32m                    "bootstrap.php"[m
[32m+[m[32m                ],[m
[32m+[m[32m                "psr-4": {[m
[32m+[m[32m                    "Symfony\\Polyfill\\Intl\\Grapheme\\": ""[m
[32m+[m[32m                }[m
[32m+[m[32m            },[m
[32m+[m[32m            "notification-url": "https://packagist.org/downloads/",[m
[32m+[m[32m            "license": [[m
[32m+[m[32m                "MIT"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "authors": [[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Nicolas Grekas",[m
[32m+[m[32m                    "email": "p@tchwork.com"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Symfony Community",[m
[32m+[m[32m                    "homepage": "https://symfony.com/contributors"[m
[32m+[m[32m                }[m
[32m+[m[32m            ],[m
[32m+[m[32m            "description": "Symfony polyfill for intl's grapheme_* functions",[m
[32m+[m[32m            "homepage": "https://symfony.com",[m
[32m+[m[32m            "keywords": [[m
[32m+[m[32m                "compatibility",[m
[32m+[m[32m                "grapheme",[m
[32m+[m[32m                "intl",[m
[32m+[m[32m                "polyfill",[m
[32m+[m[32m                "portable",[m
[32m+[m[32m                "shim"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "support": {[m
[32m+[m[32m                "source": "https://github.com/symfony/polyfill-intl-grapheme/tree/v1.32.0"[m
[32m+[m[32m            },[m
[32m+[m[32m            "funding": [[m
[32m+[m[32m                {[m
[32m+[m[32m                    "url": "https://symfony.com/sponsor",[m
[32m+[m[32m                    "type": "custom"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "url": "https://github.com/fabpot",[m
[32m+[m[32m                    "type": "github"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "url": "https://tidelift.com/funding/github/packagist/symfony/symfony",[m
[32m+[m[32m                    "type": "tidelift"[m
[32m+[m[32m                }[m
[32m+[m[32m            ],[m
[32m+[m[32m            "time": "2024-09-09T11:45:10+00:00"[m
[32m+[m[32m        },[m
[32m+[m[32m        {[m
[32m+[m[32m            "name": "symfony/polyfill-intl-normalizer",[m
[32m+[m[32m            "version": "v1.32.0",[m
[32m+[m[32m            "source": {[m
[32m+[m[32m                "type": "git",[m
[32m+[m[32m                "url": "https://github.com/symfony/polyfill-intl-normalizer.git",[m
[32m+[m[32m                "reference": "3833d7255cc303546435cb650316bff708a1c75c"[m
[32m+[m[32m            },[m
[32m+[m[32m            "dist": {[m
[32m+[m[32m                "type": "zip",[m
[32m+[m[32m                "url": "https://api.github.com/repos/symfony/polyfill-intl-normalizer/zipball/3833d7255cc303546435cb650316bff708a1c75c",[m
[32m+[m[32m                "reference": "3833d7255cc303546435cb650316bff708a1c75c",[m
[32m+[m[32m                "shasum": ""[m
[32m+[m[32m            },[m
[32m+[m[32m            "require": {[m
[32m+[m[32m                "php": ">=7.2"[m
[32m+[m[32m            },[m
[32m+[m[32m            "suggest": {[m
[32m+[m[32m                "ext-intl": "For best performance"[m
[32m+[m[32m            },[m
[32m+[m[32m            "type": "library",[m
[32m+[m[32m            "extra": {[m
[32m+[m[32m                "thanks": {[m
[32m+[m[32m                    "url": "https://github.com/symfony/polyfill",[m
[32m+[m[32m                    "name": "symfony/polyfill"[m
[32m+[m[32m                }[m
[32m+[m[32m            },[m
[32m+[m[32m            "autoload": {[m
[32m+[m[32m                "files": [[m
[32m+[m[32m                    "bootstrap.php"[m
[32m+[m[32m                ],[m
[32m+[m[32m                "psr-4": {[m
[32m+[m[32m                    "Symfony\\Polyfill\\Intl\\Normalizer\\": ""[m
[32m+[m[32m                },[m
[32m+[m[32m                "classmap": [[m
[32m+[m[32m                    "Resources/stubs"[m
[32m+[m[32m                ][m
[32m+[m[32m            },[m
[32m+[m[32m            "notification-url": "https://packagist.org/downloads/",[m
[32m+[m[32m            "license": [[m
[32m+[m[32m                "MIT"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "authors": [[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Nicolas Grekas",[m
[32m+[m[32m                    "email": "p@tchwork.com"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Symfony Community",[m
[32m+[m[32m                    "homepage": "https://symfony.com/contributors"[m
[32m+[m[32m                }[m
[32m+[m[32m            ],[m
[32m+[m[32m            "description": "Symfony polyfill for intl's Normalizer class and related functions",[m
[32m+[m[32m            "homepage": "https://symfony.com",[m
[32m+[m[32m            "keywords": [[m
[32m+[m[32m                "compatibility",[m
[32m+[m[32m                "intl",[m
[32m+[m[32m                "normalizer",[m
[32m+[m[32m                "polyfill",[m
[32m+[m[32m                "portable",[m
[32m+[m[32m                "shim"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "support": {[m
[32m+[m[32m                "source": "https://github.com/symfony/polyfill-intl-normalizer/tree/v1.32.0"[m
[32m+[m[32m            },[m
[32m+[m[32m            "funding": [[m
[32m+[m[32m                {[m
[32m+[m[32m                    "url": "https://symfony.com/sponsor",[m
[32m+[m[32m                    "type": "custom"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "url": "https://github.com/fabpot",[m
[32m+[m[32m                    "type": "github"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "url": "https://tidelift.com/funding/github/packagist/symfony/symfony",[m
[32m+[m[32m                    "type": "tidelift"[m
[32m+[m[32m                }[m
[32m+[m[32m            ],[m
[32m+[m[32m            "time": "2024-09-09T11:45:10+00:00"[m
[32m+[m[32m        },[m
[32m+[m[32m        {[m
[32m+[m[32m            "name": "symfony/polyfill-mbstring",[m
[32m+[m[32m            "version": "v1.32.0",[m
[32m+[m[32m            "source": {[m
[32m+[m[32m                "type": "git",[m
[32m+[m[32m                "url": "https://github.com/symfony/polyfill-mbstring.git",[m
[32m+[m[32m                "reference": "6d857f4d76bd4b343eac26d6b539585d2bc56493"[m
[32m+[m[32m            },[m
[32m+[m[32m            "dist": {[m
[32m+[m[32m                "type": "zip",[m
[32m+[m[32m                "url": "https://api.github.com/repos/symfony/polyfill-mbstring/zipball/6d857f4d76bd4b343eac26d6b539585d2bc56493",[m
[32m+[m[32m                "reference": "6d857f4d76bd4b343eac26d6b539585d2bc56493",[m
[32m+[m[32m                "shasum": ""[m
[32m+[m[32m            },[m
[32m+[m[32m            "require": {[m
[32m+[m[32m                "ext-iconv": "*",[m
[32m+[m[32m                "php": ">=7.2"[m
[32m+[m[32m            },[m
[32m+[m[32m            "provide": {[m
[32m+[m[32m                "ext-mbstring": "*"[m
[32m+[m[32m            },[m
[32m+[m[32m            "suggest": {[m
[32m+[m[32m                "ext-mbstring": "For best performance"[m
[32m+[m[32m            },[m
[32m+[m[32m            "type": "library",[m
[32m+[m[32m            "extra": {[m
[32m+[m[32m                "thanks": {[m
[32m+[m[32m                    "url": "https://github.com/symfony/polyfill",[m
[32m+[m[32m                    "name": "symfony/polyfill"[m
[32m+[m[32m                }[m
[32m+[m[32m            },[m
[32m+[m[32m            "autoload": {[m
[32m+[m[32m                "files": [[m
[32m+[m[32m                    "bootstrap.php"[m
[32m+[m[32m                ],[m
[32m+[m[32m                "psr-4": {[m
[32m+[m[32m                    "Symfony\\Polyfill\\Mbstring\\": ""[m
[32m+[m[32m                }[m
[32m+[m[32m            },[m
[32m+[m[32m            "notification-url": "https://packagist.org/downloads/",[m
[32m+[m[32m            "license": [[m
[32m+[m[32m                "MIT"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "authors": [[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Nicolas Grekas",[m
[32m+[m[32m                    "email": "p@tchwork.com"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Symfony Community",[m
[32m+[m[32m                    "homepage": "https://symfony.com/contributors"[m
[32m+[m[32m                }[m
[32m+[m[32m            ],[m
[32m+[m[32m            "description": "Symfony polyfill for the Mbstring extension",[m
[32m+[m[32m            "homepage": "https://symfony.com",[m
[32m+[m[32m            "keywords": [[m
[32m+[m[32m                "compatibility",[m
[32m+[m[32m                "mbstring",[m
[32m+[m[32m                "polyfill",[m
[32m+[m[32m                "portable",[m
[32m+[m[32m                "shim"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "support": {[m
[32m+[m[32m                "source": "https://github.com/symfony/polyfill-mbstring/tree/v1.32.0"[m
[32m+[m[32m            },[m
[32m+[m[32m            "funding": [[m
[32m+[m[32m                {[m
[32m+[m[32m                    "url": "https://symfony.com/sponsor",[m
[32m+[m[32m                    "type": "custom"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "url": "https://github.com/fabpot",[m
[32m+[m[32m                    "type": "github"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "url": "https://tidelift.com/funding/github/packagist/symfony/symfony",[m
[32m+[m[32m                    "type": "tidelift"[m
[32m+[m[32m                }[m
[32m+[m[32m            ],[m
[32m+[m[32m            "time": "2024-12-23T08:48:59+00:00"[m
[32m+[m[32m        },[m
[32m+[m[32m        {[m
[32m+[m[32m            "name": "symfony/service-contracts",[m
[32m+[m[32m            "version": "v3.6.0",[m
[32m+[m[32m            "source": {[m
[32m+[m[32m                "type": "git",[m
[32m+[m[32m                "url": "https://github.com/symfony/service-contracts.git",[m
[32m+[m[32m                "reference": "f021b05a130d35510bd6b25fe9053c2a8a15d5d4"[m
[32m+[m[32m            },[m
[32m+[m[32m            "dist": {[m
[32m+[m[32m                "type": "zip",[m
[32m+[m[32m                "url": "https://api.github.com/repos/symfony/service-contracts/zipball/f021b05a130d35510bd6b25fe9053c2a8a15d5d4",[m
[32m+[m[32m                "reference": "f021b05a130d35510bd6b25fe9053c2a8a15d5d4",[m
[32m+[m[32m                "shasum": ""[m
[32m+[m[32m            },[m
[32m+[m[32m            "require": {[m
[32m+[m[32m                "php": ">=8.1",[m
[32m+[m[32m                "psr/container": "^1.1|^2.0",[m
[32m+[m[32m                "symfony/deprecation-contracts": "^2.5|^3"[m
[32m+[m[32m            },[m
[32m+[m[32m            "conflict": {[m
[32m+[m[32m                "ext-psr": "<1.1|>=2"[m
[32m+[m[32m            },[m
[32m+[m[32m            "type": "library",[m
[32m+[m[32m            "extra": {[m
[32m+[m[32m                "thanks": {[m
[32m+[m[32m                    "url": "https://github.com/symfony/contracts",[m
[32m+[m[32m                    "name": "symfony/contracts"[m
[32m+[m[32m                },[m
[32m+[m[32m                "branch-alias": {[m
[32m+[m[32m                    "dev-main": "3.6-dev"[m
[32m+[m[32m                }[m
[32m+[m[32m            },[m
[32m+[m[32m            "autoload": {[m
[32m+[m[32m                "psr-4": {[m
[32m+[m[32m                    "Symfony\\Contracts\\Service\\": ""[m
[32m+[m[32m                },[m
[32m+[m[32m                "exclude-from-classmap": [[m
[32m+[m[32m                    "/Test/"[m
[32m+[m[32m                ][m
[32m+[m[32m            },[m
[32m+[m[32m            "notification-url": "https://packagist.org/downloads/",[m
[32m+[m[32m            "license": [[m
[32m+[m[32m                "MIT"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "authors": [[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Nicolas Grekas",[m
[32m+[m[32m                    "email": "p@tchwork.com"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Symfony Community",[m
[32m+[m[32m                    "homepage": "https://symfony.com/contributors"[m
[32m+[m[32m                }[m
[32m+[m[32m            ],[m
[32m+[m[32m            "description": "Generic abstractions related to writing services",[m
[32m+[m[32m            "homepage": "https://symfony.com",[m
[32m+[m[32m            "keywords": [[m
[32m+[m[32m                "abstractions",[m
[32m+[m[32m                "contracts",[m
[32m+[m[32m                "decoupling",[m
[32m+[m[32m                "interfaces",[m
[32m+[m[32m                "interoperability",[m
[32m+[m[32m                "standards"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "support": {[m
[32m+[m[32m                "source": "https://github.com/symfony/service-contracts/tree/v3.6.0"[m
[32m+[m[32m            },[m
[32m+[m[32m            "funding": [[m
[32m+[m[32m                {[m
[32m+[m[32m                    "url": "https://symfony.com/sponsor",[m
[32m+[m[32m                    "type": "custom"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "url": "https://github.com/fabpot",[m
[32m+[m[32m                    "type": "github"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "url": "https://tidelift.com/funding/github/packagist/symfony/symfony",[m
[32m+[m[32m                    "type": "tidelift"[m
[32m+[m[32m                }[m
[32m+[m[32m            ],[m
[32m+[m[32m            "time": "2025-04-25T09:37:31+00:00"[m
[32m+[m[32m        },[m
[32m+[m[32m        {[m
[32m+[m[32m            "name": "symfony/string",[m
[32m+[m[32m            "version": "v7.3.0",[m
[32m+[m[32m            "source": {[m
[32m+[m[32m                "type": "git",[m
[32m+[m[32m                "url": "https://github.com/symfony/string.git",[m
[32m+[m[32m                "reference": "f3570b8c61ca887a9e2938e85cb6458515d2b125"[m
[32m+[m[32m            },[m
[32m+[m[32m            "dist": {[m
[32m+[m[32m                "type": "zip",[m
[32m+[m[32m                "url": "https://api.github.com/repos/symfony/string/zipball/f3570b8c61ca887a9e2938e85cb6458515d2b125",[m
[32m+[m[32m                "reference": "f3570b8c61ca887a9e2938e85cb6458515d2b125",[m
[32m+[m[32m                "shasum": ""[m
[32m+[m[32m            },[m
[32m+[m[32m            "require": {[m
[32m+[m[32m                "php": ">=8.2",[m
[32m+[m[32m                "symfony/polyfill-ctype": "~1.8",[m
[32m+[m[32m                "symfony/polyfill-intl-grapheme": "~1.0",[m
[32m+[m[32m                "symfony/polyfill-intl-normalizer": "~1.0",[m
[32m+[m[32m                "symfony/polyfill-mbstring": "~1.0"[m
[32m+[m[32m            },[m
[32m+[m[32m            "conflict": {[m
[32m+[m[32m                "symfony/translation-contracts": "<2.5"[m
[32m+[m[32m            },[m
[32m+[m[32m            "require-dev": {[m
[32m+[m[32m                "symfony/emoji": "^7.1",[m
[32m+[m[32m                "symfony/error-handler": "^6.4|^7.0",[m
[32m+[m[32m                "symfony/http-client": "^6.4|^7.0",[m
[32m+[m[32m                "symfony/intl": "^6.4|^7.0",[m
[32m+[m[32m                "symfony/translation-contracts": "^2.5|^3.0",[m
[32m+[m[32m                "symfony/var-exporter": "^6.4|^7.0"[m
[32m+[m[32m            },[m
[32m+[m[32m            "type": "library",[m
[32m+[m[32m            "autoload": {[m
[32m+[m[32m                "files": [[m
[32m+[m[32m                    "Resources/functions.php"[m
[32m+[m[32m                ],[m
[32m+[m[32m                "psr-4": {[m
[32m+[m[32m                    "Symfony\\Component\\String\\": ""[m
[32m+[m[32m                },[m
[32m+[m[32m                "exclude-from-classmap": [[m
[32m+[m[32m                    "/Tests/"[m
[32m+[m[32m                ][m
[32m+[m[32m            },[m
[32m+[m[32m            "notification-url": "https://packagist.org/downloads/",[m
[32m+[m[32m            "license": [[m
[32m+[m[32m                "MIT"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "authors": [[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Nicolas Grekas",[m
[32m+[m[32m                    "email": "p@tchwork.com"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Symfony Community",[m
[32m+[m[32m                    "homepage": "https://symfony.com/contributors"[m
[32m+[m[32m                }[m
[32m+[m[32m            ],[m
[32m+[m[32m            "description": "Provides an object-oriented API to strings and deals with bytes, UTF-8 code points and grapheme clusters in a unified way",[m
[32m+[m[32m            "homepage": "https://symfony.com",[m
[32m+[m[32m            "keywords": [[m
[32m+[m[32m                "grapheme",[m
[32m+[m[32m                "i18n",[m
[32m+[m[32m                "string",[m
[32m+[m[32m                "unicode",[m
[32m+[m[32m                "utf-8",[m
[32m+[m[32m                "utf8"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "support": {[m
[32m+[m[32m                "source": "https://github.com/symfony/string/tree/v7.3.0"[m
[32m+[m[32m            },[m
[32m+[m[32m            "funding": [[m
[32m+[m[32m                {[m
[32m+[m[32m                    "url": "https://symfony.com/sponsor",[m
[32m+[m[32m                    "type": "custom"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "url": "https://github.com/fabpot",[m
[32m+[m[32m                    "type": "github"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "url": "https://tidelift.com/funding/github/packagist/symfony/symfony",[m
[32m+[m[32m                    "type": "tidelift"[m
[32m+[m[32m                }[m
[32m+[m[32m            ],[m
[32m+[m[32m            "time": "2025-04-20T20:19:01+00:00"[m
[32m+[m[32m        },[m
[32m+[m[32m        {[m
[32m+[m[32m            "name": "symfony/var-dumper",[m
[32m+[m[32m            "version": "v7.3.0",[m
[32m+[m[32m            "source": {[m
[32m+[m[32m                "type": "git",[m
[32m+[m[32m                "url": "https://github.com/symfony/var-dumper.git",[m
[32m+[m[32m                "reference": "548f6760c54197b1084e1e5c71f6d9d523f2f78e"[m
[32m+[m[32m            },[m
[32m+[m[32m            "dist": {[m
[32m+[m[32m                "type": "zip",[m
[32m+[m[32m                "url": "https://api.github.com/repos/symfony/var-dumper/zipball/548f6760c54197b1084e1e5c71f6d9d523f2f78e",[m
[32m+[m[32m                "reference": "548f6760c54197b1084e1e5c71f6d9d523f2f78e",[m
[32m+[m[32m                "shasum": ""[m
[32m+[m[32m            },[m
[32m+[m[32m            "require": {[m
[32m+[m[32m                "php": ">=8.2",[m
[32m+[m[32m                "symfony/deprecation-contracts": "^2.5|^3",[m
[32m+[m[32m                "symfony/polyfill-mbstring": "~1.0"[m
[32m+[m[32m            },[m
[32m+[m[32m            "conflict": {[m
[32m+[m[32m                "symfony/console": "<6.4"[m
[32m+[m[32m            },[m
[32m+[m[32m            "require-dev": {[m
[32m+[m[32m                "ext-iconv": "*",[m
[32m+[m[32m                "symfony/console": "^6.4|^7.0",[m
[32m+[m[32m                "symfony/http-kernel": "^6.4|^7.0",[m
[32m+[m[32m                "symfony/process": "^6.4|^7.0",[m
[32m+[m[32m                "symfony/uid": "^6.4|^7.0",[m
[32m+[m[32m                "twig/twig": "^3.12"[m
[32m+[m[32m            },[m
[32m+[m[32m            "bin": [[m
[32m+[m[32m                "Resources/bin/var-dump-server"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "type": "library",[m
[32m+[m[32m            "autoload": {[m
[32m+[m[32m                "files": [[m
[32m+[m[32m                    "Resources/functions/dump.php"[m
[32m+[m[32m                ],[m
[32m+[m[32m                "psr-4": {[m
[32m+[m[32m                    "Symfony\\Component\\VarDumper\\": ""[m
[32m+[m[32m                },[m
[32m+[m[32m                "exclude-from-classmap": [[m
[32m+[m[32m                    "/Tests/"[m
[32m+[m[32m                ][m
[32m+[m[32m            },[m
[32m+[m[32m            "notification-url": "https://packagist.org/downloads/",[m
[32m+[m[32m            "license": [[m
[32m+[m[32m                "MIT"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "authors": [[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Nicolas Grekas",[m
[32m+[m[32m                    "email": "p@tchwork.com"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Symfony Community",[m
[32m+[m[32m                    "homepage": "https://symfony.com/contributors"[m
[32m+[m[32m                }[m
[32m+[m[32m            ],[m
[32m+[m[32m            "description": "Provides mechanisms for walking through any arbitrary PHP variable",[m
[32m+[m[32m            "homepage": "https://symfony.com",[m
[32m+[m[32m            "keywords": [[m
[32m+[m[32m                "debug",[m
[32m+[m[32m                "dump"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "support": {[m
[32m+[m[32m                "source": "https://github.com/symfony/var-dumper/tree/v7.3.0"[m
[32m+[m[32m            },[m
[32m+[m[32m            "funding": [[m
[32m+[m[32m                {[m
[32m+[m[32m                    "url": "https://symfony.com/sponsor",[m
[32m+[m[32m                    "type": "custom"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "url": "https://github.com/fabpot",[m
[32m+[m[32m                    "type": "github"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "url": "https://tidelift.com/funding/github/packagist/symfony/symfony",[m
[32m+[m[32m                    "type": "tidelift"[m
[32m+[m[32m                }[m
[32m+[m[32m            ],[m
[32m+[m[32m            "time": "2025-04-27T18:39:23+00:00"[m
[32m+[m[32m        },[m
[32m+[m[32m        {[m
[32m+[m[32m            "name": "tecnickcom/tcpdf",[m
[32m+[m[32m            "version": "6.10.0",[m
[32m+[m[32m            "source": {[m
[32m+[m[32m                "type": "git",[m
[32m+[m[32m                "url": "https://github.com/tecnickcom/TCPDF.git",[m
[32m+[m[32m                "reference": "ca5b6de294512145db96bcbc94e61696599c391d"[m
[32m+[m[32m            },[m
[32m+[m[32m            "dist": {[m
[32m+[m[32m                "type": "zip",[m
[32m+[m[32m                "url": "https://api.github.com/repos/tecnickcom/TCPDF/zipball/ca5b6de294512145db96bcbc94e61696599c391d",[m
[32m+[m[32m                "reference": "ca5b6de294512145db96bcbc94e61696599c391d",[m
[32m+[m[32m                "shasum": ""[m
[32m+[m[32m            },[m
[32m+[m[32m            "require": {[m
[32m+[m[32m                "ext-curl": "*",[m
[32m+[m[32m                "php": ">=7.1.0"[m
[32m+[m[32m            },[m
[32m+[m[32m            "type": "library",[m
[32m+[m[32m            "autoload": {[m
[32m+[m[32m                "classmap": [[m
[32m+[m[32m                    "config",[m
[32m+[m[32m                    "include",[m
[32m+[m[32m                    "tcpdf.php",[m
[32m+[m[32m                    "tcpdf_barcodes_1d.php",[m
[32m+[m[32m                    "tcpdf_barcodes_2d.php",[m
[32m+[m[32m                    "include/tcpdf_colors.php",[m
[32m+[m[32m                    "include/tcpdf_filters.php",[m
[32m+[m[32m                    "include/tcpdf_font_data.php",[m
[32m+[m[32m                    "include/tcpdf_fonts.php",[m
[32m+[m[32m                    "include/tcpdf_images.php",[m
[32m+[m[32m                    "include/tcpdf_static.php",[m
[32m+[m[32m                    "include/barcodes/datamatrix.php",[m
[32m+[m[32m                    "include/barcodes/pdf417.php",[m
[32m+[m[32m                    "include/barcodes/qrcode.php"[m
[32m+[m[32m                ][m
[32m+[m[32m            },[m
[32m+[m[32m            "notification-url": "https://packagist.org/downloads/",[m
[32m+[m[32m            "license": [[m
[32m+[m[32m                "LGPL-3.0-or-later"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "authors": [[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Nicola Asuni",[m
[32m+[m[32m                    "email": "info@tecnick.com",[m
[32m+[m[32m                    "role": "lead"[m
[32m+[m[32m                }[m
[32m+[m[32m            ],[m
[32m+[m[32m            "description": "TCPDF is a PHP class for generating PDF documents and barcodes.",[m
[32m+[m[32m            "homepage": "http://www.tcpdf.org/",[m
[32m+[m[32m            "keywords": [[m
[32m+[m[32m                "PDFD32000-2008",[m
[32m+[m[32m                "TCPDF",[m
[32m+[m[32m                "barcodes",[m
[32m+[m[32m                "datamatrix",[m
[32m+[m[32m                "pdf",[m
[32m+[m[32m                "pdf417",[m
[32m+[m[32m                "qrcode"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "support": {[m
[32m+[m[32m                "issues": "https://github.com/tecnickcom/TCPDF/issues",[m
[32m+[m[32m                "source": "https://github.com/tecnickcom/TCPDF/tree/6.10.0"[m
[32m+[m[32m            },[m
[32m+[m[32m            "funding": [[m
[32m+[m[32m                {[m
[32m+[m[32m                    "url": "https://www.paypal.com/donate/?hosted_button_id=NZUEC5XS8MFBJ",[m
[32m+[m[32m                    "type": "custom"[m
[32m+[m[32m                }[m
[32m+[m[32m            ],[m
[32m+[m[32m            "time": "2025-05-27T18:02:28+00:00"[m
[32m+[m[32m        },[m
[32m+[m[32m        {[m
[32m+[m[32m            "name": "thenetworg/oauth2-azure",[m
[32m+[m[32m            "version": "v2.2.2",[m
[32m+[m[32m            "source": {[m
[32m+[m[32m                "type": "git",[m
[32m+[m[32m                "url": "https://github.com/TheNetworg/oauth2-azure.git",[m
[32m+[m[32m                "reference": "be204a5135f016470a9c33e82ab48785bbc11af2"[m
[32m+[m[32m            },[m
[32m+[m[32m            "dist": {[m
[32m+[m[32m                "type": "zip",[m
[32m+[m[32m                "url": "https://api.github.com/repos/TheNetworg/oauth2-azure/zipball/be204a5135f016470a9c33e82ab48785bbc11af2",[m
[32m+[m[32m                "reference": "be204a5135f016470a9c33e82ab48785bbc11af2",[m
[32m+[m[32m                "shasum": ""[m
[32m+[m[32m            },[m
[32m+[m[32m            "require": {[m
[32m+[m[32m                "ext-json": "*",[m
[32m+[m[32m                "ext-openssl": "*",[m
[32m+[m[32m                "firebase/php-jwt": "~3.0||~4.0||~5.0||~6.0",[m
[32m+[m[32m                "league/oauth2-client": "~2.0",[m
[32m+[m[32m                "php": "^7.1|^8.0"[m
[32m+[m[32m            },[m
[32m+[m[32m            "require-dev": {[m
[32m+[m[32m                "phpunit/phpunit": "^9.6"[m
[32m+[m[32m            },[m
[32m+[m[32m            "type": "library",[m
[32m+[m[32m            "autoload": {[m
[32m+[m[32m                "psr-4": {[m
[32m+[m[32m                    "TheNetworg\\OAuth2\\Client\\": "src/"[m
[32m+[m[32m                }[m
[32m+[m[32m            },[m
[32m+[m[32m            "notification-url": "https://packagist.org/downloads/",[m
[32m+[m[32m            "license": [[m
[32m+[m[32m                "MIT"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "authors": [[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Jan Hajek",[m
[32m+[m[32m                    "email": "jan.hajek@thenetw.org",[m
[32m+[m[32m                    "homepage": "https://thenetw.org"[m
[32m+[m[32m                }[m
[32m+[m[32m            ],[m
[32m+[m[32m            "description": "Azure Active Directory OAuth 2.0 Client Provider for The PHP League OAuth2-Client",[m
[32m+[m[32m            "keywords": [[m
[32m+[m[32m                "SSO",[m
[32m+[m[32m                "aad",[m
[32m+[m[32m                "authorization",[m
[32m+[m[32m                "azure",[m
[32m+[m[32m                "azure active directory",[m
[32m+[m[32m                "client",[m
[32m+[m[32m                "microsoft",[m
[32m+[m[32m                "oauth",[m
[32m+[m[32m                "oauth2",[m
[32m+[m[32m                "windows azure"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "support": {[m
[32m+[m[32m                "issues": "https://github.com/TheNetworg/oauth2-azure/issues",[m
[32m+[m[32m                "source": "https://github.com/TheNetworg/oauth2-azure/tree/v2.2.2"[m
[32m+[m[32m            },[m
[32m+[m[32m            "time": "2023-12-19T12:10:48+00:00"[m
         }[m
     ],[m
     "packages-dev": [],[m
[1mdiff --git a/locataire/lc_index.php b/locataire/lc_index.php[m
[1mindex 04d6b16..3a7058c 100644[m
[1m--- a/locataire/lc_index.php[m
[1m+++ b/locataire/lc_index.php[m
[36m@@ -2,13 +2,20 @@[m
 session_start();[m
 require_once(__DIR__ . "/../classe/utilisateurs.php");[m
 require_once(__DIR__ . "/../classe/maison.php");[m
[32m+[m[32mrequire_once(__DIR__ . "/../classe/demande_location.php");[m
[32m+[m
 $us = new Utilisateur();[m
 $maison = new Maison();[m
[32m+[m[32m$location = new DemandeLocation();[m
 $id_utilisateur = isset($_SESSION['user_id']) ? $_SESSION['user_id'] : null;[m
 $demandes = [];[m
 if ($id_utilisateur) {[m
     $demandes = $maison->getMaisonsByUtilisateur($id_utilisateur);[m
 }[m
[32m+[m[32m$maisons = $maison->getMaisonsApprouvees();[m
[32m+[m[32m// Compteur pour badge notification[m
[32m+[m[32m$nbDemandes = is_array($demandes) ? count($demandes) : 0;[m
[32m+[m[32m$accept=$location-> getDemandesApprouveesPourLocataire($_SESSION['user_id']);[m
 ?>[m
 <!DOCTYPE html>[m
 <html lang="fr">[m
[36m@@ -16,6 +23,7 @@[m [mif ($id_utilisateur) {[m
     <meta charset="UTF-8">[m
     <title>Tableau de bord Locataire</title>[m
     <meta name="viewport" content="width=device-width, initial-scale=1">[m
[32m+[m[32m    <link rel="icon" type="image/png" href="../images/logo/logos.avif">[m
     <link rel="stylesheet" href="../asset/css/adm_index.css">[m
     <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">[m
     <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">[m
[36m@@ -24,6 +32,7 @@[m [mif ($id_utilisateur) {[m
         .notif-badge { position: absolute; top: 8px; right: 16px; background: red; color: #fff; border-radius: 50%; padding: 2px 7px; font-size: 12px; }[m
         .main-section { display: none; }[m
         .main-section.active { display: block; }[m
[32m+[m[32m        #search-loader { display: none; }[m
     </style>[m
 </head>[m
 <body>[m
[36m@@ -47,7 +56,7 @@[m [mif ($id_utilisateur) {[m
                     <li class="nav-item mb-2 position-relative">[m
                         <a class="nav-link d-flex align-items-center text-white" href="#" data-section="demandes">[m
                             <i class="fas fa-list-ol me-2"></i> Mes demandes[m
[31m-                            <span class="notif-badge">2</span>[m
[32m+[m[32m                            <span class="notif-badge" id="notifDemandes"><?php echo $nbDemandes; ?></span>[m
                         </a>[m
                     </li>[m
                     <li class="nav-item mb-2">[m
[36m@@ -56,7 +65,7 @@[m [mif ($id_utilisateur) {[m
                         </a>[m
                     </li>[m
                     <li class="nav-item mt-4">[m
[31m-                        <a class="nav-link text-danger d-flex align-items-center bg-white" href="#">[m
[32m+[m[32m                        <a class="nav-link text-danger d-flex align-items-center bg-white" href="../logout.php">[m
                             <i class="fas fa-sign-out-alt me-2"></i> Déconnexion[m
                         </a>[m
                     </li>[m
[36m@@ -128,131 +137,150 @@[m [mif ($id_utilisateur) {[m
                     <h2 class="h4"><i class="fas fa-search me-2 text-primary"></i>Recherche de maison</h2>[m
                     <button class="btn btn-outline-secondary" onclick="showSection('dashboard')">Retour</button>[m
                 </div>[m
[31m-                <form method="get" action="#maisonsResults" class="mb-4">[m
[31m-                    <div class="row g-2">[m
[31m-                        <div class="col-md-4">[m
[31m-                            <input type="text" class="form-control" name="motcle" placeholder="Ville, quartier, ..." />[m
[31m-                        </div>[m
[31m-                        <div class="col-md-3">[m
[31m-                            <input type="number" class="form-control" name="min_prix" placeholder="Prix min" />[m
[31m-                        </div>[m
[31m-                        <div class="col-md-3">[m
[31m-                            <input type="number" class="form-control" name="max_prix" placeholder="Prix max" />[m
[31m-                        </div>[m
[31m-                        <div class="col-md-2">[m
[31m-                            <button class="btn btn-primary w-100">Rechercher</button>[m
[31m-                        </div>[m
[32m+[m[32m                <div class="mb-4">[m
[32m+[m[32m                    <input type="text" class="form-control" id="searchMaisonInput" placeholder="Rechercher par ville, quartier, prix, etc..." onkeyup="showResult(this.value)">[m
[32m+[m[32m                </div>[m
[32m+[m[32m                <div id="search-loader" class="text-center mb-2">[m
[32m+[m[32m                    <div class="spinner-border text-primary" role="status"><span class="visually-hidden">Chargement...</span></div>[m
[32m+[m[32m                </div>[m
[32m+[m[32m                <!-- Résultats AJAX -->[m
[32m+[m[32m                <div class="col-md-12">[m
[32m+[m[32m                    <div id="livesearch">[m
                     </div>[m
[31m-                </form>[m
[31m-                <!-- Résultats (exemple statique pour la démo) -->[m
[31m-                <div class="row" id="maisonsResults">[m
[31m-                    <!-- Cards maisons test -->[m
[31m-                    <div class="col-md-4 mb-3">[m
[31m-                        <div class="card shadow">[m
[31m-                            <img src="maison1.jpg" class="card-img-top" alt="Maison 1">[m
[31m-                            <div class="card-body">[m
[31m-                                <h5 class="card-title">Appartement spacieux à Lyon</h5>[m
[31m-                                <p>550 € / mois <br>2 chambres, quartier Part-Dieu</p>[m
[31m-                                <div class="d-flex gap-2">[m
[31m-                                    <form method="post" action="#" onsubmit="alert('Notification envoyée !'); return false;">[m
[31m-                                        <input type="hidden" name="maison_id" value="101">[m
[31m-                                        <button type="submit" class="btn btn-success">Demander à louer</button>[m
[31m-                                    </form>[m
[31m-                                    <button type="button" class="btn btn-outline-primary" onclick="showMaisonDetail('maison1')">Voir le détail</button>[m
[32m+[m[32m                </div>[m
[32m+[m[32m                <!-- Les résultats s'affichent ici -->[m
[32m+[m[32m                <!-- Modal Détails Maison -->[m
[32m+[m[32m                <script>[m
[32m+[m[32m                function showResult(str) {[m
[32m+[m[32m                    var loader = document.getElementById("search-loader");[m
[32m+[m[32m                    if (loader) loader.style.display = "block";[m
[32m+[m[32m                    if (str.length==0) {[m
[32m+[m[32m                        document.getElementById("livesearch").innerHTML="";[m
[32m+[m[32m                        document.getElementById("livesearch").style.border="0px";[m
[32m+[m[32m                        if (loader) loader.style.display = "none";[m
[32m+[m[32m                        return;[m
[32m+[m[32m                    }[m
[32m+[m[32m                    var xmlhttp=new XMLHttpRequest();[m
[32m+[m[32m                    xmlhttp.onreadystatechange=function() {[m
[32m+[m[32m                        if (this.readyState==4 && this.status==200) {[m
[32m+[m[32m                            document.getElementById("livesearch").innerHTML=this.responseText;[m
[32m+[m[32m                            document.getElementById("livesearch").style.border="1px solid #A5ACB2";[m
[32m+[m[32m                            if (loader) loader.style.display = "none";[m
[32m+[m[32m                        }[m
[32m+[m[32m                    }[m
[32m+[m[32m                    xmlhttp.open("GET","../ajax/recherche_maison.php?q="+encodeURIComponent(str),true);[m
[32m+[m[32m                    xmlhttp.send();[m
[32m+[m[32m                }[m
[32m+[m[32m                </script>[m
[32m+[m[32m                <div class="modal fade" id="maisonDetailsModal" tabindex="-1" aria-labelledby="maisonDetailsModalLabel" aria-hidden="true">[m
[32m+[m[32m                    <div class="modal-dialog modal-lg modal-dialog-centered">[m
[32m+[m[32m                        <div class="modal-content">[m
[32m+[m[32m                            <div class="modal-header">[m
[32m+[m[32m                                <h5 class="modal-title" id="maisonDetailsModalLabel">Détails de la maison</h5>[m
[32m+[m[32m                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Fermer"></button>[m
[32m+[m[32m                            </div>[m
[32m+[m[32m                            <div class="modal-body">[m
[32m+[m[32m                                <div class="row g-3 align-items-center">[m
[32m+[m[32m                                    <div class="col-12 col-md-5 mb-3 mb-md-0">[m
[32m+[m[32m                                        <img id="maisonDetailsPhoto" src="" alt="Maison" class="img-fluid rounded w-100" style="object-fit:cover;max-height:300px;">[m
[32m+[m[32m                                    </div>[m
[32m+[m[32m                                    <div class="col-12 col-md-7">[m
[32m+[m[32m                                        <h4 id="maisonDetailsAdresse"></h4>[m
[32m+[m[32m                                        <p class="mb-1"><i class="fas fa-bed"></i> <span id="maisonDetailsChambres"></span> chambres</p>[m
[32m+[m[32m                                        <p class="mb-1"><i class="fas fa-info-circle"></i> Statut : <span id="maisonDetailsStatut"></span></p>[m
[32m+[m[32m                                        <p class="fw-bold text-primary fs-5 mb-2" id="maisonDetailsPrix"></p>[m
[32m+[m[32m                                        <hr>[m
[32m+[m[32m                                        <p id="maisonDetailsDescription"></p>[m
[32m+[m[32m                                        <p class="mb-1 text-muted">ID utilisateur : <span id="maisonDetailsIdUtilisateur"></span></p>[m
[32m+[m[32m                                        <p class="mb-1 text-muted">ID maison : <span id="maisonDetailsIdMaison"></span></p>[m
[32m+[m[32m                                    </div>[m
                                 </div>[m
                             </div>[m
[31m-                        </div>[m
[31m-                    </div>[m
[31m-                    <!-- Autres maisons en démo/simple -->[m
[31m-                    <div class="col-md-4 mb-3">[m
[31m-                        <div class="card shadow">[m
[31m-                            <img src="maison2.jpg" class="card-img-top" alt="Maison 2">[m
[31m-                            <div class="card-body">[m
[31m-                                <h5 class="card-title">Studio moderne à Bordeaux</h5>[m
[31m-                                <p>420 € / mois <br> Bonne proximité transports.</p>[m
[31m-                                <div class="d-flex gap-2">[m
[31m-                                    <form method="post" action="#" onsubmit="alert('Notification envoyée !'); return false;">[m
[31m-                                        <input type="hidden" name="maison_id" value="102">[m
[31m-                                        <button type="submit" class="btn btn-success">Demander à louer</button>[m
[31m-                                    </form>[m
[31m-                                    <button type="button" class="btn btn-outline-primary" onclick="showMaisonDetail('maison2')">Voir le détail</button>[m
[32m+[m[32m                            <div class="modal-footer">[m
[32m+[m[32m                                <form class="d-flex gap-2" method="post" action="../demande/demande_location.php" id="demandeForm">[m
[32m+[m[32m                                    <input type="hidden" name="maison_id" id="maisonDetailsHiddenId">[m
[32m+[m[32m                                    <input type="hidden" name="id_utilisateur" id="maisonDetailsHiddenIdUtilisateur" value="<?php echo isset($_SESSION['user_id']) ? htmlspecialchars($_SESSION['user_id']) : ''; ?>">[m
[32m+[m[32m                                    <button type="submit" class="btn btn-primary" id="commanderBtn">Commander</button>[m
[32m+[m[32m                                    <button type="button" class="btn btn-warning" id="avisBtn">Envoyer avis</button>[m
[32m+[m[32m                                </form>[m
[32m+[m[32m                                <!-- Modal Avis -->[m
[32m+[m[32m                                <div class="modal fade" id="avisModal" tabindex="-1" aria-labelledby="avisModalLabel" aria-hidden="true">[m
[32m+[m[32m                                    <div class="modal-dialog">[m
[32m+[m[32m                                        <div class="modal-content">[m
[32m+[m[32m                                            <form method="post" action="../avis/avis.php">[m
[32m+[m[32m                                                <div class="modal-header">[m
[32m+[m[32m                                                    <h5 class="modal-title" id="avisModalLabel">Envoyer un avis</h5>[m
[32m+[m[32m                                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Fermer"></button>[m
[32m+[m[32m                                                </div>[m
[32m+[m[32m                                                <div class="modal-body">[m
[32m+[m[32m                                                    <input type="text" name="maison_id" id="avisMaisonId" readonly class="form-control mb-3" style="pointer-events:none;background:#f8f9fa;">[m
[32m+[m[32m                                                    <input type="text" name="id_utilisateur" id="avisIdUtilisateur" readonly class="form-control mb-3" style="pointer-events:none;background:#f8f9fa;" value="<?php echo isset($_SESSION['user_id']) ? htmlspecialchars($_SESSION['user_id']) : ''; ?>">[m
[32m+[m[32m                                                    <div class="mb-3">[m
[32m+[m[32m                                                        <label for="avisNote" class="form-label">Note</label>[m
[32m+[m[32m                                                        <select class="form-select" id="avisNote" name="note" required>[m
[32m+[m[32m                                                            <option value="">Choisir une note...</option>[m
[32m+[m[32m                                                            <option value="1">&#9733; 1/5</option>[m
[32m+[m[32m                                                            <option value="2">&#9733;&#9733; 2/5</option>[m
[32m+[m[32m                                                            <option value="3">&#9733;&#9733;&#9733; 3/5</option>[m
[32m+[m[32m                                                            <option value="4">&#9733;&#9733;&#9733;&#9733; 4/5</option>[m
[32m+[m[32m                                                            <option value="5">&#9733;&#9733;&#9733;&#9733;&#9733; 5/5</option>[m
[32m+[m[32m                                                        </select>[m
[32m+[m[32m                                                    </div>[m
[32m+[m[32m                                                    <div class="mb-3">[m
[32m+[m[32m                                                        <label for="avisMessage" class="form-label">Votre message</label>[m
[32m+[m[32m                                                        <textarea class="form-control" id="avisMessage" name="message" rows="4" required></textarea>[m
[32m+[m[32m                                                    </div>[m
[32m+[m[32m                                                </div>[m
[32m+[m[32m                                                <div class="modal-footer">[m
[32m+[m[32m                                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>[m
[32m+[m[32m                                                    <button type="submit" class="btn btn-warning">Envoyer</button>[m
[32m+[m[32m                                                </div>[m
[32m+[m[32m                                            </form>[m
[32m+[m[32m                                        </div>[m
[32m+[m[32m                                    </div>[m
                                 </div>[m
[32m+[m[32m                                <script>[m
[32m+[m[32m                                // Séparation du submit et du bouton commander[m
[32m+[m[32m                                document.getElementById('commanderBtn').onclick = function(e) {[m
[32m+[m[32m                                    // Laisser le submit du formulaire faire son travail[m
[32m+[m[32m                                };[m
[32m+[m[32m                                document.getElementById('avisBtn').onclick = function() {[m
[32m+[m[32m                                    var maisonId = document.getElementById('maisonDetailsHiddenId').value;[m
[32m+[m[32m                                    document.getElementById('avisMaisonId').value = maisonId;[m
[32m+[m[32m                                    var avisModal = new bootstrap.Modal(document.getElementById('avisModal'));[m
[32m+[m[32m                                    avisModal.show();[m
[32m+[m[32m                                };[m
[32m+[m[32m                                </script>[m
[32m+[m[32m                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Fermer</button>[m
                             </div>[m
                         </div>[m
                     </div>[m
                 </div>[m
[31m-                <!-- Fin Résultats -->[m
[31m-            </div>[m
[31m-[m
[31m-            <!-- Modal Détail Maison -->[m
[31m-            <div class="modal fade" id="modalMaisonDetail" tabindex="-1" aria-labelledby="modalMaisonDetailLabel" aria-hidden="true">[m
[31m-              <div class="modal-dialog modal-lg modal-dialog-centered">[m
[31m-                <div class="modal-content">[m
[31m-                  <div class="modal-header">[m
[31m-                    <h5 class="modal-title" id="modalMaisonDetailLabel">Détail de la maison</h5>[m
[31m-                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>[m
[31m-                  </div>[m
[31m-                  <div class="modal-body">[m
[31m-                    <div class="row">[m
[31m-                      <div class="col-md-5" id="detailMaisonImg">[m
[31m-                        <!-- Image maison -->[m
[31m-                      </div>[m
[31m-                      <div class="col-md-7" id="detailMaisonInfos">[m
[31m-                        <!-- Infos maison -->[m
[31m-                      </div>[m
[31m-                    </div>[m
[31m-                  </div>[m
[31m-                  <div class="modal-footer">[m
[31m-                    <form method="post" action="#" id="formDemandeLocation" onsubmit="alert('Notification envoyée !');$('#modalMaisonDetail').modal('hide');return false;">[m
[31m-                      <input type="hidden" name="maison_id" id="modalMaisonId" value="">[m
[31m-                      <button type="submit" class="btn btn-success">Demander la location maintenant</button>[m
[31m-                    </form>[m
[31m-                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Fermer</button>[m
[31m-                  </div>[m
[31m-                </div>[m
[31m-              </div>[m
[31m-            </div>[m
[31m-[m
[31m-            <script>[m
[31m-            // Données de démo pour les maisons[m
[31m-            const maisonsDemo = {[m
[31m-                maison1: {[m
[31m-                    id: 101,[m
[31m-                    titre: "Appartement spacieux à Lyon",[m
[31m-                    prix: "550 € / mois",[m
[31m-                    chambres: "2 chambres",[m
[31m-                    quartier: "Part-Dieu",[m
[31m-                    description: "Bel appartement lumineux, proche de toutes commodités, cuisine équipée, balcon.",[m
[31m-                    image: "maison1.jpg"[m
[31m-                },[m
[31m-                maison2: {[m
[31m-                    id: 102,[m
[31m-                    titre: "Studio moderne à Bordeaux",[m
[31m-                    prix: "420 € / mois",[m
[31m-                    chambres: "1 pièce",[m
[31m-                    quartier: "Proximité transports",[m
[31m-                    description: "Studio rénové, idéal étudiant ou jeune actif, accès tramway, commerces à pied.",[m
[31m-                    image: "maison2.jpg"[m
[32m+[m[32m                <script>[m
[32m+[m[32m                function showMaisonDetails(data) {[m
[32m+[m[32m                    var img = document.getElementById('maisonDetailsPhoto');[m
[32m+[m[32m                    img.src = data.photo && data.photo.trim() !== "" ? data.photo : '../images/maison/default.jpg';[m
[32m+[m[32m                    img.onerror = function() { this.src = '../images/maison/default.jpg'; };[m
[32m+[m[32m                    document.getElementById('maisonDetailsAdresse').textContent = data.adresse;[m
[32m+[m[32m                    document.getElementById('maisonDetailsChambres').textContent = data.nombre_de_chambre;[m
[32m+[m[32m                    document.getElementById('maisonDetailsStatut').textContent = data.statut;[m
[32m+[m[32m                    document.getElementById('maisonDetailsPrix').textContent = data.prix + " $";[m
[32m+[m[32m                    document.getElementById('maisonDetailsDescription').textContent = data.description;[m
[32m+[m[32m                    document.getElementById('maisonDetailsIdUtilisateur').textContent = data.id_utilisateur;[m
[32m+[m[32m                    document.getElementById('maisonDetailsIdMaison').textContent = data.id || '';[m
[32m+[m[32m                    document.getElementById('maisonDetailsHiddenId').value = data.id || '';[m
[32m+[m[32m                    var modal = new bootstrap.Modal(document.getElementById('maisonDetailsModal'));[m
[32m+[m[32m                    modal.show();[m
                 }[m
[31m-            };[m
[31m-[m
[31m-            function showMaisonDetail(maisonKey) {[m
[31m-                const maison = maisonsDemo[maisonKey];[m
[31m-                if (!maison) return;[m
[31m-                document.getElementById('modalMaisonDetailLabel').textContent = maison.titre;[m
[31m-                document.getElementById('detailMaisonImg').innerHTML = `<img src="${maison.image}" alt="${maison.titre}" class="img-fluid rounded shadow">`;[m
[31m-                document.getElementById('detailMaisonInfos').innerHTML = `[m
[31m-                    <h4>${maison.titre}</h4>[m
[31m-                    <p><strong>Prix :</strong> ${maison.prix}</p>[m
[31m-                    <p><strong>Chambres :</strong> ${maison.chambres}</p>[m
[31m-                    <p><strong>Quartier :</strong> ${maison.quartier}</p>[m
[31m-                    <p>${maison.description}</p>[m
[31m-                `;[m
[31m-                document.getElementById('modalMaisonId').value = maison.id;[m
[31m-                var modal = new bootstrap.Modal(document.getElementById('modalMaisonDetail'));[m
[31m-                modal.show();[m
[31m-            }[m
[31m-            </script>[m
[32m+[m[32m                // Ajout de la fonction toggleAnnoncesSection si absente[m
[32m+[m[32m                function toggleAnnoncesSection() {[m
[32m+[m[32m                    var section = document.getElementById('section-annonces');[m
[32m+[m[32m                    if (section) {[m
[32m+[m[32m                        section.style.display = (section.style.display === 'none' || section.style.display === '') ? 'block' : 'none';[m
[32m+[m[32m                    }[m
[32m+[m[32m                }[m
[32m+[m[32m                </script>[m
[32m+[m[32m            </div>[m
             <!-- SECTION DEMANDES -->[m
             <div class="main-section" id="demandes">[m
                 <div class="d-flex justify-content-between align-items-center pt-3 pb-2 mb-3 border-bottom">[m
[36m@@ -267,13 +295,19 @@[m [mif ($id_utilisateur) {[m
                                 <div>[m
                                     <strong>[m
                                         <?php echo htmlspecialchars($demande['adresse'] ?? 'Maison'); ?> – [m
[31m-                                        <?php echo htmlspecialchars($demande['prix'] ?? ''); ?> €[m
[32m+[m[32m                                        <?php echo htmlspecialchars($demande['prix'] ?? ''); ?> $[m
                                         <?php echo isset($demande['nombre_de_chambre']) ? htmlspecialchars($demande['nombre_de_chambre']) . ' chambre(s)' : ''; ?>[m
                                     </strong>[m
                                     <br>[m
                                     <span class="small">[m
                                         Demande envoyée le [m
[31m-                                        <?php echo isset($demande['date_demande']) ? date('d/m/Y', strtotime($demande['date_demande'])) : ''; ?>[m
[32m+[m[32m                                        <?php[m
[32m+[m[32m                                        if (!empty($demande['date']) && strtotime($demande['date']) !== false) {[m
[32m+[m[32m                                            echo date('d/m/Y', strtotime($demande['date']));[m
[32m+[m[32m                                        } else {[m
[32m+[m[32m                                            echo '';[m
[32m+[m[32m                                        }[m
[32m+[m[32m                                        ?>[m
                                     </span>[m
                                 </div>[m
                                 <div>[m
[36m@@ -316,11 +350,19 @@[m [mif ($id_utilisateur) {[m
                         </tr>[m
                     </thead>[m
                     <tbody>[m
[32m+[m[32m                        <?php if (!empty($accept)) : ?>[m
[32m+[m[32m                                <?php foreach ($accept as $accep) :    ?>[m
                         <tr>[m
[31m-                            <td><strong>Studio ludique, Bordeaux</strong><br>(Montant : 420 €)</td>[m
[32m+[m[32m                            <td><strong><?php echo htmlspecialchars($accep['adresse']).', '. htmlspecialchars($accep['date_demande']); ?>[m
[32m+[m[32m                            </strong><br><?php echo htmlspecialchars($accep['prix']); ?></td>[m
[32m+[m[41m                              [m
                             <td><span class="badge bg-success">En cours</span></td>[m
                             <td>[m
[31m-                                <button class="btn btn-outline-secondary btn-sm me-2">Voir signer <i class="fas fa-pen"></i></button>[m
[32m+[m[32m                                <form action="../contrat/contrat.php" method="post">[m
[32m+[m[32m                                    <input type="hidden" name="id_maison" value="<?php echo htmlspecialchars($accep['id_maison']); ?>">[m
[32m+[m[32m                                    <input type="hidden" name="id_utilisateur" value="<?php echo htmlspecialchars($_SESSION['user_id']); ?>">[m
[32m+[m[32m                                    <button type="submit" class="btn btn-outline-secondary btn-sm me-2">Voir signer <i class="fas fa-pen"></i></button>[m
[32m+[m[32m                                </form>[m
                             </td>[m
                             <td>[m
                                 <form method="post" onsubmit="alert('Paiement effectué !'); return false;">[m
[36m@@ -330,6 +372,12 @@[m [mif ($id_utilisateur) {[m
                             <td>[m
                                 <button class="btn btn-outline-primary btn-sm" onclick="showModal('modAvisMaison')">Laisser un avis</button>[m
                             </td>[m
[32m+[m[32m                               <?php endforeach; ?>[m
[32m+[m[32m                            <?php else: ?>[m
[32m+[m[32m                                <div class="col-12">[m
[32m+[m[32m                                    <div class="alert alert-info text-center">Aucune annonce trouvée.</div>[m
[32m+[m[32m                                </div>[m
[32m+[m[32m                            <?php endif; ?>[m
                         </tr>[m
                         <tr>[m
                             <td><strong>Appart cosy, Lyon</strong><br>(Montant : 550 €)</td>[m
[36m@@ -354,7 +402,7 @@[m [mif ($id_utilisateur) {[m
                     <button class="btn btn-outline-secondary" onclick="showSection('dashboard')">Retour</button>[m
                 </div>[m
                 <div>[m
[31m-                    <!-- multiple avis, recommandations à la flexibilité -->[m
[32m+[m[32m                    <!-- Plusieurs avis, recommandations à la flexibilité -->[m
                     <button class="btn btn-primary mb-2" data-bs-toggle="modal" data-bs-target="#modAvisMaison">Donner un avis sur une location</button>[m
                     <div><!-- Afficher les avis déjà laissés ici (dummy/demo) --></div>[m
                 </div>[m
[1mdiff --git a/page/login.php b/page/login.php[m
[1mindex 4b86836..073bac6 100644[m
[1m--- a/page/login.php[m
[1m+++ b/page/login.php[m
[36m@@ -141,6 +141,7 @@[m [mif (isset($_POST['conxx'])) {[m
 <head>[m
     <meta charset="UTF-8">[m
     <meta name="viewport" content="width=device-width, initial-scale=1.0">[m
[32m+[m[32m    <link rel="icon" type="image/png" href="../images/logo/logos.avif">[m
     <title>Connexion / Inscription</title>[m
     <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">[m
     <link rel="stylesheet" href="../asset/css/login.css">[m
[1mdiff --git a/proprietaire/pr_index.php b/proprietaire/pr_index.php[m
[1mindex 56dfd4a..e37347c 100644[m
[1m--- a/proprietaire/pr_index.php[m
[1m+++ b/proprietaire/pr_index.php[m
[36m@@ -1,6 +1,9 @@[m
 <?php[m
 session_start();[m
[32m+[m[32mrequire_once(__DIR__."/../classe/utilisateurs.php");[m
 require_once(__DIR__ . "/../classe/maison.php");[m
[32m+[m[32mrequire_once(__DIR__ . '/../classe/demande_location.php');[m
[32m+[m
 [m
 // Vérifier si l'utilisateur est connecté[m
 if (!isset($_SESSION['user_id'])) {[m
[36m@@ -10,6 +13,9 @@[m [mif (!isset($_SESSION['user_id'])) {[m
 [m
 // Instancier la classe Maison[m
 $maison = new Maison();[m
[32m+[m[32m$demande = new DemandeLocation();[m
[32m+[m[32m// Récupérer les demandes envoyées aux maisons du propriétaire[m
[32m+[m[32m$demandesEnvoyees = $demande->getDemandesEnvoyeesAMaMaison($_SESSION['user_id']);[m
 [m
 $user_id = intval($_SESSION['user_id']);[m
 [m
[36m@@ -84,6 +90,11 @@[m [mif (isset($_POST['publier'])) {[m
         // Vous pouvez afficher $message dans la page pour informer l'utilisateur[m
         // Exemple : echo '<div class="alert alert-danger">'.$message.'</div>';[m
     }[m
[32m+[m[32m    // Fonction pour obtenir le nombre total de demandes pour les maisons du propriétaire[m
[32m+[m[41m  [m
[32m+[m
[32m+[m[32m    // Exemple d'utilisation pour afficher le nombre total de demandes dans une variable[m
[32m+[m[41m   [m
 }[m
 ?>[m
 <!DOCTYPE html>[m
[36m@@ -92,6 +103,7 @@[m [mif (isset($_POST['publier'])) {[m
     <meta charset="UTF-8">[m
     <title>Tableau de bord Propriétaire</title>[m
     <meta name="viewport" content="width=device-width, initial-scale=1">[m
[32m+[m[32m    <link rel="icon" type="image/png" href="../images/logo/logos.avif">[m
     <link rel="stylesheet" href="../asset/css/adm_index.css">[m
     <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">[m
     <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">[m
[36m@@ -123,7 +135,7 @@[m [mif (isset($_POST['publier'])) {[m
                     <li class="nav-item mb-2 position-relative">[m
                         <a class="nav-link d-flex align-items-center text-white" href="#" data-section="demandes">[m
                             <i class="fas fa-bell me-2"></i> Demandes[m
[31m-                            <span class="notif-badge">3</span>[m
[32m+[m[32m                            <span class="notif-badge"><?php echo  $nombreDemandes =$demande->getNombreDemandesPourMesMaisons($user_id);?></span>[m
                         </a>[m
                     </li>[m
                     <li class="nav-item mb-2">[m
[36m@@ -202,14 +214,61 @@[m [mif (isset($_POST['publier'])) {[m
                     <h2><i class="fas fa-bell me-2 text-primary"></i>Demandes reçues</h2>[m
                     <button class="btn btn-outline-secondary" onclick="showSection('dashboard')">Retour</button>[m
                 </div>[m
[31m-                <!-- Liste des demandes (exemple statique) -->[m
[32m+[m[32m                <!-- Liste des demandes dynamiques -->[m
                 <div class="list-group">[m
[31m-                    <a href="#" class="list-group-item list-group-item-action" data-bs-toggle="modal" data-bs-target="#modalDemande1">[m
[31m-                        <strong>Demande de location</strong> - Jean Dupont <span class="badge bg-info ms-2">Nouveau</span>[m
[31m-                    </a>[m
[31m-                    <a href="#" class="list-group-item list-group-item-action" data-bs-toggle="modal" data-bs-target="#modalDemande2">[m
[31m-                        <strong>Demande de visite</strong> - Marie Martin[m
[31m-                    </a>[m
[32m+[m[32m                    <?php if (!empty($demandesEnvoyees)) : ?>[m
[32m+[m[32m                        <?php foreach ($demandesEnvoyees as $demande) : ?>[m
[32m+[m[32m                            <a href="#"[m
[32m+[m[32m                               class="list-group-item list-group-item-action"[m
[32m+[m[32m                               data-bs-toggle="modal"[m
[32m+[m[32m                               data-bs-target="#modalDemande<?php echo intval($demande['id_demande']); ?>">[m
[32m+[m[32m                                <strong>[m
[32m+[m[32m                                    <?php echo htmlspecialchars($demande["nom_locataire"] ?? 'Locataire inconnu'); ?>[m
[32m+[m[32m                                </strong>[m
[32m+[m[32m                                - <?php echo htmlspecialchars($demande["email_locataire"] ?? 'Demande de location'); ?>[m
[32m+[m[32m                                <span class="badge bg-<?php echo ($demande["statut"] === 'Nouveau') ? 'info' : 'secondary'; ?> ms-2">[m
[32m+[m[32m                                    <?php echo htmlspecialchars($demande["statut"]); ?>[m
[32m+[m[32m                                </span>[m
[32m+[m[32m                            </a>[m
[32m+[m[32m                            <!-- Modale dynamique pour chaque demande -->[m
[32m+[m[32m                            <div class="modal fade" id="modalDemande<?php echo intval($demande['id_demande']); ?>" tabindex="-1" aria-labelledby="modalDemandeLabel<?php echo intval($demande['id_demande']); ?>" aria-hidden="true">[m
[32m+[m[32m                                <div class="modal-dialog">[m
[32m+[m[32m                                    <div class="modal-content">[m
[32m+[m[32m                                        <div class="modal-header">[m
[32m+[m[32m                                            <h5 class="modal-title" id="modalDemandeLabel<?php echo intval($demande['id_demande']); ?>">[m
[32m+[m[32m                                                <?php echo htmlspecialchars($demande["statut"] ?? 'Demande'); ?> - <?php echo htmlspecialchars($demande["nom_locataire"] ?? 'Locataire'); ?>[m
[32m+[m[32m                                            </h5>[m
[32m+[m[32m                                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>[m
[32m+[m[32m                                        </div>[m
[32m+[m[32m                                        <div class="modal-body">[m
[32m+[m[32m                                            <p><strong>Email :</strong> <?php echo htmlspecialchars($demande["email_locataire"] ?? ''); ?></p>[m
[32m+[m[41m                [m
[32m+[m[32m                                            <p><strong>nom :</strong> <?php echo nl2br(htmlspecialchars($demande["nom_locataire"] ?? '')); ?></p>[m
[32m+[m[32m                                            <p><strong>Adresse du bien :</strong> <?php echo htmlspecialchars($demande["adresse"] ?? ''); ?></p>[m
[32m+[m[32m                                            <p><strong>Statut :</strong>[m
[32m+[m[32m                                                <span class="badge bg-<?php echo ($demande["statut"] === 'Nouveau') ? 'info' : 'secondary'; ?>">[m
[32m+[m[32m                                                    <?php echo htmlspecialchars($demande["statut"]); ?>[m
[32m+[m[32m                                                </span>[m
[32m+[m[32m                                            </p>[m
[32m+[m[32m                                        </div>[m
[32m+[m[32m                                        <div class="modal-footer">[m
[32m+[m[32m                                            <form method="post" action="action.php" class="d-inline">[m
[32m+[m[32m                                                <input type="hidden" name="id_demande" value="<?php echo intval($demande['id_demande']); ?>">[m
[32m+[m[32m                                                <button type="submit" name="accepter" class="btn btn-success">Accepter</button>[m
[32m+[m[32m                                            </form>[m
[32m+[m[32m                                            <form method="post" action="action.php" class="d-inline ms-2">[m
[32m+[m[32m                                                <input type="hidden" name="id_demande" value="<?php echo intval($demande['id_demande']); ?>">[m
[32m+[m[32m                                                <button type="submit" name="refuser" class="btn btn-danger">Refuser</button>[m
[32m+[m[32m                                            </form>[m
[32m+[m[32m                                            <button class="btn btn-outline-secondary" data-bs-dismiss="modal">Fermer</button>[m
[32m+[m[32m                                        </div>[m
[32m+[m[32m                                    </div>[m
[32m+[m[32m                                </div>[m
[32m+[m[32m                            </div>[m
[32m+[m[32m                        <?php endforeach; ?>[m
[32m+[m[32m                    <?php else : ?>[m
[32m+[m[32m                        <div class="alert alert-info">Aucune demande reçue pour le moment.</div>[m
[32m+[m[32m                    <?php endif; ?>[m
                 </div>[m
             </div>[m
             <!-- Section Paiements -->[m
[1mdiff --git a/vendor/autoload.php b/vendor/autoload.php[m
[1mindex be8f792..ef38bf4 100644[m
[1m--- a/vendor/autoload.php[m
[1m+++ b/vendor/autoload.php[m
[36m@@ -14,10 +14,7 @@[m [mif (PHP_VERSION_ID < 50600) {[m
             echo $err;[m
         }[m
     }[m
[31m-    trigger_error([m
[31m-        $err,[m
[31m-        E_USER_ERROR[m
[31m-    );[m
[32m+[m[32m    throw new RuntimeException($err);[m
 }[m
 [m
 require_once __DIR__ . '/composer/autoload_real.php';[m
[1mdiff --git a/vendor/composer/InstalledVersions.php b/vendor/composer/InstalledVersions.php[m
[1mindex 51e734a..2052022 100644[m
[1m--- a/vendor/composer/InstalledVersions.php[m
[1m+++ b/vendor/composer/InstalledVersions.php[m
[36m@@ -26,12 +26,23 @@[m [muse Composer\Semver\VersionParser;[m
  */[m
 class InstalledVersions[m
 {[m
[32m+[m[32m    /**[m
[32m+[m[32m     * @var string|null if set (by reflection by Composer), this should be set to the path where this class is being copied to[m
[32m+[m[32m     * @internal[m
[32m+[m[32m     */[m
[32m+[m[32m    private static $selfDir = null;[m
[32m+[m
     /**[m
      * @var mixed[]|null[m
      * @psalm-var array{root: array{name: string, pretty_version: string, version: string, reference: string|null, type: string, install_path: string, aliases: string[], dev: bool}, versions: array<string, array{pretty_version?: string, version?: string, reference?: string|null, type?: string, install_path?: string, aliases?: string[], dev_requirement: bool, replaced?: string[], provided?: string[]}>}|array{}|null[m
      */[m
     private static $installed;[m
 [m
[32m+[m[32m    /**[m
[32m+[m[32m     * @var bool[m
[32m+[m[32m     */[m
[32m+[m[32m    private static $installedIsLocalDir;[m
[32m+[m
     /**[m
      * @var bool|null[m
      */[m
[36m@@ -309,6 +320,24 @@[m [mclass InstalledVersions[m
     {[m
         self::$installed = $data;[m
         self::$installedByVendor = array();[m
[32m+[m
[32m+[m[32m        // when using reload, we disable the duplicate protection to ensure that self::$installed data is[m
[32m+[m[32m        // always returned, but we cannot know whether it comes from the installed.php in __DIR__ or not,[m
[32m+[m[32m        // so we have to assume it does not, and that may result in duplicate data being returned when listing[m
[32m+[m[32m        // all installed packages for example[m
[32m+[m[32m        self::$installedIsLocalDir = false;[m
[32m+[m[32m    }[m
[32m+[m
[32m+[m[32m    /**[m
[32m+[m[32m     * @return string[m
[32m+[m[32m     */[m
[32m+[m[32m    private static function getSelfDir()[m
[32m+[m[32m    {[m
[32m+[m[32m        if (self::$selfDir === null) {[m
[32m+[m[32m            self::$selfDir = strtr(__DIR__, '\\', '/');[m
[32m+[m[32m        }[m
[32m+[m
[32m+[m[32m        return self::$selfDir;[m
     }[m
 [m
     /**[m
[36m@@ -322,19 +351,27 @@[m [mclass InstalledVersions[m
         }[m
 [m
         $installed = array();[m
[32m+[m[32m        $copiedLocalDir = false;[m
 [m
         if (self::$canGetVendors) {[m
[32m+[m[32m            $selfDir = self::getSelfDir();[m
             foreach (ClassLoader::getRegisteredLoaders() as $vendorDir => $loader) {[m
[32m+[m[32m                $vendorDir = strtr($vendorDir, '\\', '/');[m
                 if (isset(self::$installedByVendor[$vendorDir])) {[m
                     $installed[] = self::$installedByVendor[$vendorDir];[m
                 } elseif (is_file($vendorDir.'/composer/installed.php')) {[m
                     /** @var array{root: array{name: string, pretty_version: string, version: string, reference: string|null, type: string, install_path: string, aliases: string[], dev: bool}, versions: array<string, array{pretty_version?: string, version?: string, reference?: string|null, type?: string, install_path?: string, aliases?: string[], dev_requirement: bool, replaced?: string[], provided?: string[]}>} $required */[m
                     $required = require $vendorDir.'/composer/installed.php';[m
[31m-                    $installed[] = self::$installedByVendor[$vendorDir] = $required;[m
[31m-                    if (null === self::$installed && strtr($vendorDir.'/composer', '\\', '/') === strtr(__DIR__, '\\', '/')) {[m
[31m-                        self::$installed = $installed[count($installed) - 1];[m
[32m+[m[32m                    self::$installedByVendor[$vendorDir] = $required;[m
[32m+[m[32m                    $installed[] = $required;[m
[32m+[m[32m                    if (self::$installed === null && $vendorDir.'/composer' === $selfDir) {[m
[32m+[m[32m                        self::$installed = $required;[m
[32m+[m[32m                        self::$installedIsLocalDir = true;[m
                     }[m
                 }[m
[32m+[m[32m                if (self::$installedIsLocalDir && $vendorDir.'/composer' === $selfDir) {[m
[32m+[m[32m                    $copiedLocalDir = true;[m
[32m+[m[32m                }[m
             }[m
         }[m
 [m
[36m@@ -350,7 +387,7 @@[m [mclass InstalledVersions[m
             }[m
         }[m
 [m
[31m-        if (self::$installed !== array()) {[m
[32m+[m[32m        if (self::$installed !== array() && !$copiedLocalDir) {[m
             $installed[] = self::$installed;[m
         }[m
 [m
[1mdiff --git a/vendor/composer/autoload_classmap.php b/vendor/composer/autoload_classmap.php[m
[1mindex 0fb0a2c..652f9c9 100644[m
[1m--- a/vendor/composer/autoload_classmap.php[m
[1m+++ b/vendor/composer/autoload_classmap.php[m
[36m@@ -7,4 +7,37 @@[m [m$baseDir = dirname($vendorDir);[m
 [m
 return array([m
     'Composer\\InstalledVersions' => $vendorDir . '/composer/InstalledVersions.php',[m
[32m+[m[32m    'Datamatrix' => $vendorDir . '/tecnickcom/tcpdf/include/barcodes/datamatrix.php',[m
[32m+[m[32m    'Google_AccessToken_Revoke' => $vendorDir . '/google/apiclient/src/aliases.php',[m
[32m+[m[32m    'Google_AccessToken_Verify' => $vendorDir . '/google/apiclient/src/aliases.php',[m
[32m+[m[32m    'Google_AuthHandler_AuthHandlerFactory' => $vendorDir . '/google/apiclient/src/aliases.php',[m
[32m+[m[32m    'Google_AuthHandler_Guzzle6AuthHandler' => $vendorDir . '/google/apiclient/src/aliases.php',[m
[32m+[m[32m    'Google_AuthHandler_Guzzle7AuthHandler' => $vendorDir . '/google/apiclient/src/aliases.php',[m
[32m+[m[32m    'Google_Client' => $vendorDir . '/google/apiclient/src/aliases.php',[m
[32m+[m[32m    'Google_Collection' => $vendorDir . '/google/apiclient/src/aliases.php',[m
[32m+[m[32m    'Google_Exception' => $vendorDir . '/google/apiclient/src/aliases.php',[m
[32m+[m[32m    'Google_Http_Batch' => $vendorDir . '/google/apiclient/src/aliases.php',[m
[32m+[m[32m    'Google_Http_MediaFileUpload' => $vendorDir . '/google/apiclient/src/aliases.php',[m
[32m+[m[32m    'Google_Http_REST' => $vendorDir . '/google/apiclient/src/aliases.php',[m
[32m+[m[32m    'Google_Model' => $vendorDir . '/google/apiclient/src/aliases.php',[m
[32m+[m[32m    'Google_Service' => $vendorDir . '/google/apiclient/src/aliases.php',[m
[32m+[m[32m    'Google_Service_Exception' => $vendorDir . '/google/apiclient/src/aliases.php',[m
[32m+[m[32m    'Google_Service_Resource' => $vendorDir . '/google/apiclient/src/aliases.php',[m
[32m+[m[32m    'Google_Task_Composer' => $vendorDir . '/google/apiclient/src/aliases.php',[m
[32m+[m[32m    'Google_Task_Exception' => $vendorDir . '/google/apiclient/src/aliases.php',[m
[32m+[m[32m    'Google_Task_Retryable' => $vendorDir . '/google/apiclient/src/aliases.php',[m
[32m+[m[32m    'Google_Task_Runner' => $vendorDir . '/google/apiclient/src/aliases.php',[m
[32m+[m[32m    'Google_Utils_UriTemplate' => $vendorDir . '/google/apiclient/src/aliases.php',[m
[32m+[m[32m    'Normalizer' => $vendorDir . '/symfony/polyfill-intl-normalizer/Resources/stubs/Normalizer.php',[m
[32m+[m[32m    'PDF417' => $vendorDir . '/tecnickcom/tcpdf/include/barcodes/pdf417.php',[m
[32m+[m[32m    'QRcode' => $vendorDir . '/tecnickcom/tcpdf/include/barcodes/qrcode.php',[m
[32m+[m[32m    'TCPDF' => $vendorDir . '/tecnickcom/tcpdf/tcpdf.php',[m
[32m+[m[32m    'TCPDF2DBarcode' => $vendorDir . '/tecnickcom/tcpdf/tcpdf_barcodes_2d.php',[m
[32m+[m[32m    'TCPDFBarcode' => $vendorDir . '/tecnickcom/tcpdf/tcpdf_barcodes_1d.php',[m
[32m+[m[32m    'TCPDF_COLORS' => $vendorDir . '/tecnickcom/tcpdf/include/tcpdf_colors.php',[m
[32m+[m[32m    'TCPDF_FILTERS' => $vendorDir . '/tecnickcom/tcpdf/include/tcpdf_filters.php',[m
[32m+[m[32m    'TCPDF_FONTS' => $vendorDir . '/tecnickcom/tcpdf/include/tcpdf_fonts.php',[m
[32m+[m[32m    'TCPDF_FONT_DATA' => $vendorDir . '/tecnickcom/tcpdf/include/tcpdf_font_data.php',[m
[32m+[m[32m    'TCPDF_IMAGES' => $vendorDir . '/tecnickcom/tcpdf/include/tcpdf_images.php',[m
[32m+[m[32m    'TCPDF_STATIC' => $vendorDir . '/tecnickcom/tcpdf/include/tcpdf_static.php',[m
 );[m
[1mdiff --git a/vendor/composer/autoload_psr4.php b/vendor/composer/autoload_psr4.php[m
[1mindex 28567a0..8a416fa 100644[m
[1m--- a/vendor/composer/autoload_psr4.php[m
[1m+++ b/vendor/composer/autoload_psr4.php[m
[36m@@ -6,5 +6,31 @@[m [m$vendorDir = dirname(__DIR__);[m
 $baseDir = dirname($vendorDir);[m
 [m
 return array([m
[32m+[m[32m    'phpseclib3\\' => array($vendorDir . '/phpseclib/phpseclib/phpseclib'),[m
[32m+[m[32m    'decomplexity\\SendOauth2\\' => array($vendorDir . '/decomplexity/sendoauth2/src'),[m
[32m+[m[32m    'TheNetworg\\OAuth2\\Client\\' => array($vendorDir . '/thenetworg/oauth2-azure/src'),[m
[32m+[m[32m    'Symfony\\Polyfill\\Mbstring\\' => array($vendorDir . '/symfony/polyfill-mbstring'),[m
[32m+[m[32m    'Symfony\\Polyfill\\Intl\\Normalizer\\' => array($vendorDir . '/symfony/polyfill-intl-normalizer'),[m
[32m+[m[32m    'Symfony\\Polyfill\\Intl\\Grapheme\\' => array($vendorDir . '/symfony/polyfill-intl-grapheme'),[m
[32m+[m[32m    'Symfony\\Polyfill\\Ctype\\' => array($vendorDir . '/symfony/polyfill-ctype'),[m
[32m+[m[32m    'Symfony\\Contracts\\Service\\' => array($vendorDir . '/symfony/service-contracts'),[m
[32m+[m[32m    'Symfony\\Component\\VarDumper\\' => array($vendorDir . '/symfony/var-dumper'),[m
[32m+[m[32m    'Symfony\\Component\\String\\' => array($vendorDir . '/symfony/string'),[m
[32m+[m[32m    'Symfony\\Component\\Console\\' => array($vendorDir . '/symfony/console'),[m
[32m+[m[32m    'Psr\\Log\\' => array($vendorDir . '/psr/log/src'),[m
[32m+[m[32m    'Psr\\Http\\Message\\' => array($vendorDir . '/psr/http-factory/src', $vendorDir . '/psr/http-message/src'),[m
[32m+[m[32m    'Psr\\Http\\Client\\' => array($vendorDir . '/psr/http-client/src'),[m
[32m+[m[32m    'Psr\\Container\\' => array($vendorDir . '/psr/container/src'),[m
[32m+[m[32m    'Psr\\Cache\\' => array($vendorDir . '/psr/cache/src'),[m
[32m+[m[32m    'ParagonIE\\ConstantTime\\' => array($vendorDir . '/paragonie/constant_time_encoding/src'),[m
     'PHPMailer\\PHPMailer\\' => array($vendorDir . '/phpmailer/phpmailer/src'),[m
[32m+[m[32m    'Monolog\\' => array($vendorDir . '/monolog/monolog/src/Monolog'),[m
[32m+[m[32m    'League\\OAuth2\\Client\\' => array($vendorDir . '/league/oauth2-google/src', $vendorDir . '/league/oauth2-client/src'),[m
[32m+[m[32m    'GuzzleHttp\\Psr7\\' => array($vendorDir . '/guzzlehttp/psr7/src'),[m
[32m+[m[32m    'GuzzleHttp\\Promise\\' => array($vendorDir . '/guzzlehttp/promises/src'),[m
[32m+[m[32m    'GuzzleHttp\\' => array($vendorDir . '/guzzlehttp/guzzle/src'),[m
[32m+[m[32m    'Google\\Service\\' => array($vendorDir . '/google/apiclient-services/src'),[m
[32m+[m[32m    'Google\\Auth\\' => array($vendorDir . '/google/auth/src'),[m
[32m+[m[32m    'Google\\' => array($vendorDir . '/google/apiclient/src'),[m
[32m+[m[32m    'Firebase\\JWT\\' => array($vendorDir . '/firebase/php-jwt/src'),[m
 );[m
[1mdiff --git a/vendor/composer/autoload_real.php b/vendor/composer/autoload_real.php[m
[1mindex 963fcc8..28dc091 100644[m
[1m--- a/vendor/composer/autoload_real.php[m
[1m+++ b/vendor/composer/autoload_real.php[m
[36m@@ -33,6 +33,18 @@[m [mclass ComposerAutoloaderInit2185d2f99bcd56787481d9357a5972d3[m
 [m
         $loader->register(true);[m
 [m
[32m+[m[32m        $filesToLoad = \Composer\Autoload\ComposerStaticInit2185d2f99bcd56787481d9357a5972d3::$files;[m
[32m+[m[32m        $requireFile = \Closure::bind(static function ($fileIdentifier, $file) {[m
[32m+[m[32m            if (empty($GLOBALS['__composer_autoload_files'][$fileIdentifier])) {[m
[32m+[m[32m                $GLOBALS['__composer_autoload_files'][$fileIdentifier] = true;[m
[32m+[m
[32m+[m[32m                require $file;[m
[32m+[m[32m            }[m
[32m+[m[32m        }, null, null);[m
[32m+[m[32m        foreach ($filesToLoad as $fileIdentifier => $file) {[m
[32m+[m[32m            $requireFile($fileIdentifier, $file);[m
[32m+[m[32m        }[m
[32m+[m
         return $loader;[m
     }[m
 }[m
[1mdiff --git a/vendor/composer/autoload_static.php b/vendor/composer/autoload_static.php[m
[1mindex 66e80a7..075f69d 100644[m
[1m--- a/vendor/composer/autoload_static.php[m
[1m+++ b/vendor/composer/autoload_static.php[m
[36m@@ -6,22 +6,226 @@[m [mnamespace Composer\Autoload;[m
 [m
 class ComposerStaticInit2185d2f99bcd56787481d9357a5972d3[m
 {[m
[32m+[m[32m    public static $files = array ([m
[32m+[m[32m        '7b11c4dc42b3b3023073cb14e519683c' => __DIR__ . '/..' . '/ralouphie/getallheaders/src/getallheaders.php',[m
[32m+[m[32m        '6e3fae29631ef280660b3cdad06f25a8' => __DIR__ . '/..' . '/symfony/deprecation-contracts/function.php',[m
[32m+[m[32m        '37a3dc5111fe8f707ab4c132ef1dbc62' => __DIR__ . '/..' . '/guzzlehttp/guzzle/src/functions_include.php',[m
[32m+[m[32m        '0e6d7bf4a5811bfa5cf40c5ccd6fae6a' => __DIR__ . '/..' . '/symfony/polyfill-mbstring/bootstrap.php',[m
[32m+[m[32m        '1f87db08236948d07391152dccb70f04' => __DIR__ . '/..' . '/google/apiclient-services/autoload.php',[m
[32m+[m[32m        'decc78cc4436b1292c6c0d151b19445c' => __DIR__ . '/..' . '/phpseclib/phpseclib/phpseclib/bootstrap.php',[m
[32m+[m[32m        '320cde22f66dd4f5d3fd621d3e88b98f' => __DIR__ . '/..' . '/symfony/polyfill-ctype/bootstrap.php',[m
[32m+[m[32m        '8825ede83f2f289127722d4e842cf7e8' => __DIR__ . '/..' . '/symfony/polyfill-intl-grapheme/bootstrap.php',[m
[32m+[m[32m        'e69f7f6ee287b969198c3c9d6777bd38' => __DIR__ . '/..' . '/symfony/polyfill-intl-normalizer/bootstrap.php',[m
[32m+[m[32m        'a8d3953fd9959404dd22d3dfcd0a79f0' => __DIR__ . '/..' . '/google/apiclient/src/aliases.php',[m
[32m+[m[32m        'b6b991a57620e2fb6b2f66f03fe9ddc2' => __DIR__ . '/..' . '/symfony/string/Resources/functions.php',[m
[32m+[m[32m        '667aeda72477189d0494fecd327c3641' => __DIR__ . '/..' . '/symfony/var-dumper/Resources/functions/dump.php',[m
[32m+[m[32m    );[m
[32m+[m
     public static $prefixLengthsPsr4 = array ([m
[32m+[m[32m        'p' =>[m[41m [m
[32m+[m[32m        array ([m
[32m+[m[32m            'phpseclib3\\' => 11,[m
[32m+[m[32m        ),[m
[32m+[m[32m        'd' =>[m[41m [m
[32m+[m[32m        array ([m
[32m+[m[32m            'decomplexity\\SendOauth2\\' => 24,[m
[32m+[m[32m        ),[m
[32m+[m[32m        'T' =>[m[41m [m
[32m+[m[32m        array ([m
[32m+[m[32m            'TheNetworg\\OAuth2\\Client\\' => 25,[m
[32m+[m[32m        ),[m
[32m+[m[32m        'S' =>[m[41m [m
[32m+[m[32m        array ([m
[32m+[m[32m            'Symfony\\Polyfill\\Mbstring\\' => 26,[m
[32m+[m[32m            'Symfony\\Polyfill\\Intl\\Normalizer\\' => 33,[m
[32m+[m[32m            'Symfony\\Polyfill\\Intl\\Grapheme\\' => 31,[m
[32m+[m[32m            'Symfony\\Polyfill\\Ctype\\' => 23,[m
[32m+[m[32m            'Symfony\\Contracts\\Service\\' => 26,[m
[32m+[m[32m            'Symfony\\Component\\VarDumper\\' => 28,[m
[32m+[m[32m            'Symfony\\Component\\String\\' => 25,[m
[32m+[m[32m            'Symfony\\Component\\Console\\' => 26,[m
[32m+[m[32m        ),[m
         'P' => [m
         array ([m
[32m+[m[32m            'Psr\\Log\\' => 8,[m
[32m+[m[32m            'Psr\\Http\\Message\\' => 17,[m
[32m+[m[32m            'Psr\\Http\\Client\\' => 16,[m
[32m+[m[32m            'Psr\\Container\\' => 14,[m
[32m+[m[32m            'Psr\\Cache\\' => 10,[m
[32m+[m[32m            'ParagonIE\\ConstantTime\\' => 23,[m
             'PHPMailer\\PHPMailer\\' => 20,[m
         ),[m
[32m+[m[32m        'M' =>[m[41m [m
[32m+[m[32m        array ([m
[32m+[m[32m            'Monolog\\' => 8,[m
[32m+[m[32m        ),[m
[32m+[m[32m        'L' =>[m[41m [m
[32m+[m[32m        array ([m
[32m+[m[32m            'League\\OAuth2\\Client\\' => 21,[m
[32m+[m[32m        ),[m
[32m+[m[32m        'G' =>[m[41m [m
[32m+[m[32m        array ([m
[32m+[m[32m            'GuzzleHttp\\Psr7\\' => 16,[m
[32m+[m[32m            'GuzzleHttp\\Promise\\' => 19,[m
[32m+[m[32m            'GuzzleHttp\\' => 11,[m
[32m+[m[32m            'Google\\Service\\' => 15,[m
[32m+[m[32m            'Google\\Auth\\' => 12,[m
[32m+[m[32m            'Google\\' => 7,[m
[32m+[m[32m        ),[m
[32m+[m[32m        'F' =>[m[41m [m
[32m+[m[32m        array ([m
[32m+[m[32m            'Firebase\\JWT\\' => 13,[m
[32m+[m[32m        ),[m
     );[m
 [m
     public static $prefixDirsPsr4 = array ([m
[32m+[m[32m        'phpseclib3\\' =>[m[41m [m
[32m+[m[32m        array ([m
[32m+[m[32m            0 => __DIR__ . '/..' . '/phpseclib/phpseclib/phpseclib',[m
[32m+[m[32m        ),[m
[32m+[m[32m        'decomplexity\\SendOauth2\\' =>[m[41m [m
[32m+[m[32m        array ([m
[32m+[m[32m            0 => __DIR__ . '/..' . '/decomplexity/sendoauth2/src',[m
[32m+[m[32m        ),[m
[32m+[m[32m        'TheNetworg\\OAuth2\\Client\\' =>[m[41m [m
[32m+[m[32m        array ([m
[32m+[m[32m            0 => __DIR__ . '/..' . '/thenetworg/oauth2-azure/src',[m
[32m+[m[32m        ),[m
[32m+[m[32m        'Symfony\\Polyfill\\Mbstring\\' =>[m[41m [m
[32m+[m[32m        array ([m
[32m+[m[32m            0 => __DIR__ . '/..' . '/symfony/polyfill-mbstring',[m
[32m+[m[32m        ),[m
[32m+[m[32m        'Symfony\\Polyfill\\Intl\\Normalizer\\' =>[m[41m [m
[32m+[m[32m        array ([m
[32m+[m[32m            0 => __DIR__ . '/..' . '/symfony/polyfill-intl-normalizer',[m
[32m+[m[32m        ),[m
[32m+[m[32m        'Symfony\\Polyfill\\Intl\\Grapheme\\' =>[m[41m [m
[32m+[m[32m        array ([m
[32m+[m[32m            0 => __DIR__ . '/..' . '/symfony/polyfill-intl-grapheme',[m
[32m+[m[32m        ),[m
[32m+[m[32m        'Symfony\\Polyfill\\Ctype\\' =>[m[41m [m
[32m+[m[32m        array ([m
[32m+[m[32m            0 => __DIR__ . '/..' . '/symfony/polyfill-ctype',[m
[32m+[m[32m        ),[m
[32m+[m[32m        'Symfony\\Contracts\\Service\\' =>[m[41m [m
[32m+[m[32m        array ([m
[32m+[m[32m            0 => __DIR__ . '/..' . '/symfony/service-contracts',[m
[32m+[m[32m        ),[m
[32m+[m[32m        'Symfony\\Component\\VarDumper\\' =>[m[41m [m
[32m+[m[32m        array ([m
[32m+[m[32m            0 => __DIR__ . '/..' . '/symfony/var-dumper',[m
[32m+[m[32m        ),[m
[32m+[m[32m        'Symfony\\Component\\String\\' =>[m[41m [m
[32m+[m[32m        array ([m
[32m+[m[32m            0 => __DIR__ . '/..' . '/symfony/string',[m
[32m+[m[32m        ),[m
[32m+[m[32m        'Symfony\\Component\\Console\\' =>[m[41m [m
[32m+[m[32m        array ([m
[32m+[m[32m            0 => __DIR__ . '/..' . '/symfony/console',[m
[32m+[m[32m        ),[m
[32m+[m[32m        'Psr\\Log\\' =>[m[41m [m
[32m+[m[32m        array ([m
[32m+[m[32m            0 => __DIR__ . '/..' . '/psr/log/src',[m
[32m+[m[32m        ),[m
[32m+[m[32m        'Psr\\Http\\Message\\' =>[m[41m [m
[32m+[m[32m        array ([m
[32m+[m[32m            0 => __DIR__ . '/..' . '/psr/http-factory/src',[m
[32m+[m[32m            1 => __DIR__ . '/..' . '/psr/http-message/src',[m
[32m+[m[32m        ),[m
[32m+[m[32m        'Psr\\Http\\Client\\' =>[m[41m [m
[32m+[m[32m        array ([m
[32m+[m[32m            0 => __DIR__ . '/..' . '/psr/http-client/src',[m
[32m+[m[32m        ),[m
[32m+[m[32m        'Psr\\Container\\' =>[m[41m [m
[32m+[m[32m        array ([m
[32m+[m[32m            0 => __DIR__ . '/..' . '/psr/container/src',[m
[32m+[m[32m        ),[m
[32m+[m[32m        'Psr\\Cache\\' =>[m[41m [m
[32m+[m[32m        array ([m
[32m+[m[32m            0 => __DIR__ . '/..' . '/psr/cache/src',[m
[32m+[m[32m        ),[m
[32m+[m[32m        'ParagonIE\\ConstantTime\\' =>[m[41m [m
[32m+[m[32m        array ([m
[32m+[m[32m            0 => __DIR__ . '/..' . '/paragonie/constant_time_encoding/src',[m
[32m+[m[32m        ),[m
         'PHPMailer\\PHPMailer\\' => [m
         array ([m
             0 => __DIR__ . '/..' . '/phpmailer/phpmailer/src',[m
         ),[m
[32m+[m[32m        'Monolog\\' =>[m[41m [m
[32m+[m[32m        array ([m
[32m+[m[32m            0 => __DIR__ . '/..' . '/monolog/monolog/src/Monolog',[m
[32m+[m[32m        ),[m
[32m+[m[32m        'League\\OAuth2\\Client\\' =>[m[41m [m
[32m+[m[32m        array ([m
[32m+[m[32m            0 => __DIR__ . '/..' . '/league/oauth2-google/src',[m
[32m+[m[32m            1 => __DIR__ . '/..' . '/league/oauth2-client/src',[m
[32m+[m[32m        ),[m
[32m+[m[32m        'GuzzleHttp\\Psr7\\' =>[m[41m [m
[32m+[m[32m        array ([m
[32m+[m[32m            0 => __DIR__ . '/..' . '/guzzlehttp/psr7/src',[m
[32m+[m[32m        ),[m
[32m+[m[32m        'GuzzleHttp\\Promise\\' =>[m[41m [m
[32m+[m[32m        array ([m
[32m+[m[32m            0 => __DIR__ . '/..' . '/guzzlehttp/promises/src',[m
[32m+[m[32m        ),[m
[32m+[m[32m        'GuzzleHttp\\' =>[m[41m [m
[32m+[m[32m        array ([m
[32m+[m[32m            0 => __DIR__ . '/..' . '/guzzlehttp/guzzle/src',[m
[32m+[m[32m        ),[m
[32m+[m[32m        'Google\\Service\\' =>[m[41m [m
[32m+[m[32m        array ([m
[32m+[m[32m            0 => __DIR__ . '/..' . '/google/apiclient-services/src',[m
[32m+[m[32m        ),[m
[32m+[m[32m        'Google\\Auth\\' =>[m[41m [m
[32m+[m[32m        array ([m
[32m+[m[32m            0 => __DIR__ . '/..' . '/google/auth/src',[m
[32m+[m[32m        ),[m
[32m+[m[32m        'Google\\' =>[m[41m [m
[32m+[m[32m        array ([m
[32m+[m[32m            0 => __DIR__ . '/..' . '/google/apiclient/src',[m
[32m+[m[32m        ),[m
[32m+[m[32m        'Firebase\\JWT\\' =>[m[41m [m
[32m+[m[32m        array ([m
[32m+[m[32m            0 => __DIR__ . '/..' . '/firebase/php-jwt/src',[m
[32m+[m[32m        ),[m
     );[m
 [m
     public static $classMap = array ([m
         'Composer\\InstalledVersions' => __DIR__ . '/..' . '/composer/InstalledVersions.php',[m
[32m+[m[32m        'Datamatrix' => __DIR__ . '/..' . '/tecnickcom/tcpdf/include/barcodes/datamatrix.php',[m
[32m+[m[32m        'Google_AccessToken_Revoke' => __DIR__ . '/..' . '/google/apiclient/src/aliases.php',[m
[32m+[m[32m        'Google_AccessToken_Verify' => __DIR__ . '/..' . '/google/apiclient/src/aliases.php',[m
[32m+[m[32m        'Google_AuthHandler_AuthHandlerFactory' => __DIR__ . '/..' . '/google/apiclient/src/aliases.php',[m
[32m+[m[32m        'Google_AuthHandler_Guzzle6AuthHandler' => __DIR__ . '/..' . '/google/apiclient/src/aliases.php',[m
[32m+[m[32m        'Google_AuthHandler_Guzzle7AuthHandler' => __DIR__ . '/..' . '/google/apiclient/src/aliases.php',[m
[32m+[m[32m        'Google_Client' => __DIR__ . '/..' . '/google/apiclient/src/aliases.php',[m
[32m+[m[32m        'Google_Collection' => __DIR__ . '/..' . '/google/apiclient/src/aliases.php',[m
[32m+[m[32m        'Google_Exception' => __DIR__ . '/..' . '/google/apiclient/src/aliases.php',[m
[32m+[m[32m        'Google_Http_Batch' => __DIR__ . '/..' . '/google/apiclient/src/aliases.php',[m
[32m+[m[32m        'Google_Http_MediaFileUpload' => __DIR__ . '/..' . '/google/apiclient/src/aliases.php',[m
[32m+[m[32m        'Google_Http_REST' => __DIR__ . '/..' . '/google/apiclient/src/aliases.php',[m
[32m+[m[32m        'Google_Model' => __DIR__ . '/..' . '/google/apiclient/src/aliases.php',[m
[32m+[m[32m        'Google_Service' => __DIR__ . '/..' . '/google/apiclient/src/aliases.php',[m
[32m+[m[32m        'Google_Service_Exception' => __DIR__ . '/..' . '/google/apiclient/src/aliases.php',[m
[32m+[m[32m        'Google_Service_Resource' => __DIR__ . '/..' . '/google/apiclient/src/aliases.php',[m
[32m+[m[32m        'Google_Task_Composer' => __DIR__ . '/..' . '/google/apiclient/src/aliases.php',[m
[32m+[m[32m        'Google_Task_Exception' => __DIR__ . '/..' . '/google/apiclient/src/aliases.php',[m
[32m+[m[32m        'Google_Task_Retryable' => __DIR__ . '/..' . '/google/apiclient/src/aliases.php',[m
[32m+[m[32m        'Google_Task_Runner' => __DIR__ . '/..' . '/google/apiclient/src/aliases.php',[m
[32m+[m[32m        'Google_Utils_UriTemplate' => __DIR__ . '/..' . '/google/apiclient/src/aliases.php',[m
[32m+[m[32m        'Normalizer' => __DIR__ . '/..' . '/symfony/polyfill-intl-normalizer/Resources/stubs/Normalizer.php',[m
[32m+[m[32m        'PDF417' => __DIR__ . '/..' . '/tecnickcom/tcpdf/include/barcodes/pdf417.php',[m
[32m+[m[32m        'QRcode' => __DIR__ . '/..' . '/tecnickcom/tcpdf/include/barcodes/qrcode.php',[m
[32m+[m[32m        'TCPDF' => __DIR__ . '/..' . '/tecnickcom/tcpdf/tcpdf.php',[m
[32m+[m[32m        'TCPDF2DBarcode' => __DIR__ . '/..' . '/tecnickcom/tcpdf/tcpdf_barcodes_2d.php',[m
[32m+[m[32m        'TCPDFBarcode' => __DIR__ . '/..' . '/tecnickcom/tcpdf/tcpdf_barcodes_1d.php',[m
[32m+[m[32m        'TCPDF_COLORS' => __DIR__ . '/..' . '/tecnickcom/tcpdf/include/tcpdf_colors.php',[m
[32m+[m[32m        'TCPDF_FILTERS' => __DIR__ . '/..' . '/tecnickcom/tcpdf/include/tcpdf_filters.php',[m
[32m+[m[32m        'TCPDF_FONTS' => __DIR__ . '/..' . '/tecnickcom/tcpdf/include/tcpdf_fonts.php',[m
[32m+[m[32m        'TCPDF_FONT_DATA' => __DIR__ . '/..' . '/tecnickcom/tcpdf/include/tcpdf_font_data.php',[m
[32m+[m[32m        'TCPDF_IMAGES' => __DIR__ . '/..' . '/tecnickcom/tcpdf/include/tcpdf_images.php',[m
[32m+[m[32m        'TCPDF_STATIC' => __DIR__ . '/..' . '/tecnickcom/tcpdf/include/tcpdf_static.php',[m
     );[m
 [m
     public static function getInitializer(ClassLoader $loader)[m
[1mdiff --git a/vendor/composer/installed.json b/vendor/composer/installed.json[m
[1mindex 6a697b3..0b632d9 100644[m
[1m--- a/vendor/composer/installed.json[m
[1m+++ b/vendor/composer/installed.json[m
[36m@@ -1,88 +1,2468 @@[m
 {[m
     "packages": [[m
         {[m
[31m-            "name": "phpmailer/phpmailer",[m
[31m-            "version": "v6.9.3",[m
[31m-            "version_normalized": "6.9.3.0",[m
[32m+[m[32m            "name": "decomplexity/sendoauth2",[m
[32m+[m[32m            "version": "v4.1.0",[m
[32m+[m[32m            "version_normalized": "4.1.0.0",[m
             "source": {[m
                 "type": "git",[m
[31m-                "url": "https://github.com/PHPMailer/PHPMailer.git",[m
[31m-                "reference": "2f5c94fe7493efc213f643c23b1b1c249d40f47e"[m
[32m+[m[32m                "url": "https://github.com/decomplexity/SendOauth2.git",[m
[32m+[m[32m                "reference": "0ea873dc851f3f96058548cd37879653f2070a87"[m
             },[m
             "dist": {[m
                 "type": "zip",[m
[31m-                "url": "https://api.github.com/repos/PHPMailer/PHPMailer/zipball/2f5c94fe7493efc213f643c23b1b1c249d40f47e",[m
[31m-                "reference": "2f5c94fe7493efc213f643c23b1b1c249d40f47e",[m
[32m+[m[32m                "url": "https://api.github.com/repos/decomplexity/SendOauth2/zipball/0ea873dc851f3f96058548cd37879653f2070a87",[m
[32m+[m[32m                "reference": "0ea873dc851f3f96058548cd37879653f2070a87",[m
                 "shasum": ""[m
             },[m
             "require": {[m
[31m-                "ext-ctype": "*",[m
[31m-                "ext-filter": "*",[m
[31m-                "ext-hash": "*",[m
[31m-                "php": ">=5.5.0"[m
[32m+[m[32m                "google/apiclient": "^2.15.0",[m
[32m+[m[32m                "league/oauth2-google": ">=4.0.1",[m
[32m+[m[32m                "php": ">=7.4.0",[m
[32m+[m[32m                "phpmailer/phpmailer": ">=6.6.0",[m
[32m+[m[32m                "thenetworg/oauth2-azure": ">=2.2.1"[m
[32m+[m[32m            },[m
[32m+[m[32m            "time": "2024-07-04T14:51:49+00:00",[m
[32m+[m[32m            "type": "library",[m
[32m+[m[32m            "installation-source": "source",[m
[32m+[m[32m            "autoload": {[m
[32m+[m[32m                "psr-4": {[m
[32m+[m[32m                    "decomplexity\\SendOauth2\\": "src/"[m
[32m+[m[32m                }[m
[32m+[m[32m            },[m
[32m+[m[32m            "notification-url": "https://packagist.org/downloads/",[m
[32m+[m[32m            "license": [[m
[32m+[m[32m                "MIT"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "authors": [[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Max Stewart",[m
[32m+[m[32m                    "email": "SendOauth2@decomplexity.com",[m
[32m+[m[32m                    "homepage": "https://www.decomplexity.com"[m
[32m+[m[32m                }[m
[32m+[m[32m            ],[m
[32m+[m[32m            "description": "Wrapper for PHPMailer SMTP",[m
[32m+[m[32m            "homepage": "https://github.com/decomplexity/SendOauth2",[m
[32m+[m[32m            "keywords": [[m
[32m+[m[32m                "oauth2",[m
[32m+[m[32m                "phpmailer"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "support": {[m
[32m+[m[32m                "email": "SendOauth2@decomplexity.com",[m
[32m+[m[32m                "issues": "https://github.com/decomplexity/SendOauth2/issues",[m
[32m+[m[32m                "source": "https://github.com/decomplexity/SendOauth2/tree/v4.1.0"[m
[32m+[m[32m            },[m
[32m+[m[32m            "install-path": "../decomplexity/sendoauth2"[m
[32m+[m[32m        },[m
[32m+[m[32m        {[m
[32m+[m[32m            "name": "firebase/php-jwt",[m
[32m+[m[32m            "version": "v6.11.1",[m
[32m+[m[32m            "version_normalized": "6.11.1.0",[m
[32m+[m[32m            "source": {[m
[32m+[m[32m                "type": "git",[m
[32m+[m[32m                "url": "https://github.com/firebase/php-jwt.git",[m
[32m+[m[32m                "reference": "d1e91ecf8c598d073d0995afa8cd5c75c6e19e66"[m
[32m+[m[32m            },[m
[32m+[m[32m            "dist": {[m
[32m+[m[32m                "type": "zip",[m
[32m+[m[32m                "url": "https://api.github.com/repos/firebase/php-jwt/zipball/d1e91ecf8c598d073d0995afa8cd5c75c6e19e66",[m
[32m+[m[32m                "reference": "d1e91ecf8c598d073d0995afa8cd5c75c6e19e66",[m
[32m+[m[32m                "shasum": ""[m
[32m+[m[32m            },[m
[32m+[m[32m            "require": {[m
[32m+[m[32m                "php": "^8.0"[m
             },[m
             "require-dev": {[m
[31m-                "dealerdirect/phpcodesniffer-composer-installer": "^1.0",[m
[31m-                "doctrine/annotations": "^1.2.6 || ^1.13.3",[m
[31m-                "php-parallel-lint/php-console-highlighter": "^1.0.0",[m
[31m-                "php-parallel-lint/php-parallel-lint": "^1.3.2",[m
[31m-                "phpcompatibility/php-compatibility": "^9.3.5",[m
[31m-                "roave/security-advisories": "dev-latest",[m
[31m-                "squizlabs/php_codesniffer": "^3.7.2",[m
[31m-                "yoast/phpunit-polyfills": "^1.0.4"[m
[32m+[m[32m                "guzzlehttp/guzzle": "^7.4",[m
[32m+[m[32m                "phpspec/prophecy-phpunit": "^2.0",[m
[32m+[m[32m                "phpunit/phpunit": "^9.5",[m
[32m+[m[32m                "psr/cache": "^2.0||^3.0",[m
[32m+[m[32m                "psr/http-client": "^1.0",[m
[32m+[m[32m                "psr/http-factory": "^1.0"[m
             },[m
             "suggest": {[m
[31m-                "decomplexity/SendOauth2": "Adapter for using XOAUTH2 authentication",[m
[31m-                "ext-mbstring": "Needed to send email in multibyte encoding charset or decode encoded addresses",[m
[31m-                "ext-openssl": "Needed for secure SMTP sending and DKIM signing",[m
[31m-                "greew/oauth2-azure-provider": "Needed for Microsoft Azure XOAUTH2 authentication",[m
[31m-                "hayageek/oauth2-yahoo": "Needed for Yahoo XOAUTH2 authentication",[m
[31m-                "league/oauth2-google": "Needed for Google XOAUTH2 authentication",[m
[31m-                "psr/log": "For optional PSR-3 debug logging",[m
[31m-                "symfony/polyfill-mbstring": "To support UTF-8 if the Mbstring PHP extension is not enabled (^1.2)",[m
[31m-                "thenetworg/oauth2-azure": "Needed for Microsoft XOAUTH2 authentication"[m
[32m+[m[32m                "ext-sodium": "Support EdDSA (Ed25519) signatures",[m
[32m+[m[32m                "paragonie/sodium_compat": "Support EdDSA (Ed25519) signatures when libsodium is not present"[m
             },[m
[31m-            "time": "2024-11-24T18:04:13+00:00",[m
[32m+[m[32m            "time": "2025-04-09T20:32:01+00:00",[m
             "type": "library",[m
[31m-            "installation-source": "dist",[m
[32m+[m[32m            "installation-source": "source",[m
             "autoload": {[m
                 "psr-4": {[m
[31m-                    "PHPMailer\\PHPMailer\\": "src/"[m
[32m+[m[32m                    "Firebase\\JWT\\": "src"[m
                 }[m
             },[m
             "notification-url": "https://packagist.org/downloads/",[m
             "license": [[m
[31m-                "LGPL-2.1-only"[m
[32m+[m[32m                "BSD-3-Clause"[m
             ],[m
             "authors": [[m
                 {[m
[31m-                    "name": "Marcus Bointon",[m
[31m-                    "email": "phpmailer@synchromedia.co.uk"[m
[32m+[m[32m                    "name": "Neuman Vong",[m
[32m+[m[32m                    "email": "neuman+pear@twilio.com",[m
[32m+[m[32m                    "role": "Developer"[m
                 },[m
                 {[m
[31m-                    "name": "Jim Jagielski",[m
[31m-                    "email": "jimjag@gmail.com"[m
[32m+[m[32m                    "name": "Anant Narayanan",[m
[32m+[m[32m                    "email": "anant@php.net",[m
[32m+[m[32m                    "role": "Developer"[m
[32m+[m[32m                }[m
[32m+[m[32m            ],[m
[32m+[m[32m            "description": "A simple library to encode and decode JSON Web Tokens (JWT) in PHP. Should conform to the current spec.",[m
[32m+[m[32m            "homepage": "https://github.com/firebase/php-jwt",[m
[32m+[m[32m            "keywords": [[m
[32m+[m[32m                "jwt",[m
[32m+[m[32m                "php"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "support": {[m
[32m+[m[32m                "issues": "https://github.com/firebase/php-jwt/issues",[m
[32m+[m[32m                "source": "https://github.com/firebase/php-jwt/tree/v6.11.1"[m
[32m+[m[32m            },[m
[32m+[m[32m            "install-path": "../firebase/php-jwt"[m
[32m+[m[32m        },[m
[32m+[m[32m        {[m
[32m+[m[32m            "name": "google/apiclient",[m
[32m+[m[32m            "version": "v2.18.3",[m
[32m+[m[32m            "version_normalized": "2.18.3.0",[m
[32m+[m[32m            "source": {[m
[32m+[m[32m                "type": "git",[m
[32m+[m[32m                "url": "https://github.com/googleapis/google-api-php-client.git",[m
[32m+[m[32m                "reference": "4eee42d201eff054428a4836ec132944d271f051"[m
[32m+[m[32m            },[m
[32m+[m[32m            "dist": {[m
[32m+[m[32m                "type": "zip",[m
[32m+[m[32m                "url": "https://api.github.com/repos/googleapis/google-api-php-client/zipball/4eee42d201eff054428a4836ec132944d271f051",[m
[32m+[m[32m                "reference": "4eee42d201eff054428a4836ec132944d271f051",[m
[32m+[m[32m                "shasum": ""[m
[32m+[m[32m            },[m
[32m+[m[32m            "require": {[m
[32m+[m[32m                "firebase/php-jwt": "^6.0",[m
[32m+[m[32m                "google/apiclient-services": "~0.350",[m
[32m+[m[32m                "google/auth": "^1.37",[m
[32m+[m[32m                "guzzlehttp/guzzle": "^7.4.5",[m
[32m+[m[32m                "guzzlehttp/psr7": "^2.6",[m
[32m+[m[32m                "monolog/monolog": "^2.9||^3.0",[m
[32m+[m[32m                "php": "^8.0",[m
[32m+[m[32m                "phpseclib/phpseclib": "^3.0.36"[m
[32m+[m[32m            },[m
[32m+[m[32m            "require-dev": {[m
[32m+[m[32m                "cache/filesystem-adapter": "^1.1",[m
[32m+[m[32m                "composer/composer": "^1.10.23",[m
[32m+[m[32m                "phpcompatibility/php-compatibility": "^9.2",[m
[32m+[m[32m                "phpspec/prophecy-phpunit": "^2.1",[m
[32m+[m[32m                "phpunit/phpunit": "^9.6",[m
[32m+[m[32m                "squizlabs/php_codesniffer": "^3.8",[m
[32m+[m[32m                "symfony/css-selector": "~2.1",[m
[32m+[m[32m                "symfony/dom-crawler": "~2.1"[m
[32m+[m[32m            },[m
[32m+[m[32m            "suggest": {[m
[32m+[m[32m                "cache/filesystem-adapter": "For caching certs and tokens (using Google\\Client::setCache)"[m
[32m+[m[32m            },[m
[32m+[m[32m            "time": "2025-04-08T21:59:36+00:00",[m
[32m+[m[32m            "type": "library",[m
[32m+[m[32m            "extra": {[m
[32m+[m[32m                "branch-alias": {[m
[32m+[m[32m                    "dev-main": "2.x-dev"[m
[32m+[m[32m                }[m
[32m+[m[32m            },[m
[32m+[m[32m            "installation-source": "source",[m
[32m+[m[32m            "autoload": {[m
[32m+[m[32m                "files": [[m
[32m+[m[32m                    "src/aliases.php"[m
[32m+[m[32m                ],[m
[32m+[m[32m                "psr-4": {[m
[32m+[m[32m                    "Google\\": "src/"[m
[32m+[m[32m                },[m
[32m+[m[32m                "classmap": [[m
[32m+[m[32m                    "src/aliases.php"[m
[32m+[m[32m                ][m
[32m+[m[32m            },[m
[32m+[m[32m            "notification-url": "https://packagist.org/downloads/",[m
[32m+[m[32m            "license": [[m
[32m+[m[32m                "Apache-2.0"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "description": "Client library for Google APIs",[m
[32m+[m[32m            "homepage": "http://developers.google.com/api-client-library/php",[m
[32m+[m[32m            "keywords": [[m
[32m+[m[32m                "google"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "support": {[m
[32m+[m[32m                "issues": "https://github.com/googleapis/google-api-php-client/issues",[m
[32m+[m[32m                "source": "https://github.com/googleapis/google-api-php-client/tree/v2.18.3"[m
[32m+[m[32m            },[m
[32m+[m[32m            "install-path": "../google/apiclient"[m
[32m+[m[32m        },[m
[32m+[m[32m        {[m
[32m+[m[32m            "name": "google/apiclient-services",[m
[32m+[m[32m            "version": "v0.400.0",[m
[32m+[m[32m            "version_normalized": "0.400.0.0",[m
[32m+[m[32m            "source": {[m
[32m+[m[32m                "type": "git",[m
[32m+[m[32m                "url": "https://github.com/googleapis/google-api-php-client-services.git",[m
[32m+[m[32m                "reference": "8366037e450b62ffc1c5489459f207640acca2b4"[m
[32m+[m[32m            },[m
[32m+[m[32m            "dist": {[m
[32m+[m[32m                "type": "zip",[m
[32m+[m[32m                "url": "https://api.github.com/repos/googleapis/google-api-php-client-services/zipball/8366037e450b62ffc1c5489459f207640acca2b4",[m
[32m+[m[32m                "reference": "8366037e450b62ffc1c5489459f207640acca2b4",[m
[32m+[m[32m                "shasum": ""[m
[32m+[m[32m            },[m
[32m+[m[32m            "require": {[m
[32m+[m[32m                "php": "^8.0"[m
[32m+[m[32m            },[m
[32m+[m[32m            "require-dev": {[m
[32m+[m[32m                "phpunit/phpunit": "^9.6"[m
[32m+[m[32m            },[m
[32m+[m[32m            "time": "2025-06-04T17:28:44+00:00",[m
[32m+[m[32m            "type": "library",[m
[32m+[m[32m            "installation-source": "source",[m
[32m+[m[32m            "autoload": {[m
[32m+[m[32m                "files": [[m
[32m+[m[32m                    "autoload.php"[m
[32m+[m[32m                ],[m
[32m+[m[32m                "psr-4": {[m
[32m+[m[32m                    "Google\\Service\\": "src"[m
[32m+[m[32m                }[m
[32m+[m[32m            },[m
[32m+[m[32m            "notification-url": "https://packagist.org/downloads/",[m
[32m+[m[32m            "license": [[m
[32m+[m[32m                "Apache-2.0"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "description": "Client library for Google APIs",[m
[32m+[m[32m            "homepage": "http://developers.google.com/api-client-library/php",[m
[32m+[m[32m            "keywords": [[m
[32m+[m[32m                "google"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "support": {[m
[32m+[m[32m                "issues": "https://github.com/googleapis/google-api-php-client-services/issues",[m
[32m+[m[32m                "source": "https://github.com/googleapis/google-api-php-client-services/tree/v0.400.0"[m
[32m+[m[32m            },[m
[32m+[m[32m            "install-path": "../google/apiclient-services"[m
[32m+[m[32m        },[m
[32m+[m[32m        {[m
[32m+[m[32m            "name": "google/auth",[m
[32m+[m[32m            "version": "v1.47.0",[m
[32m+[m[32m            "version_normalized": "1.47.0.0",[m
[32m+[m[32m            "source": {[m
[32m+[m[32m                "type": "git",[m
[32m+[m[32m                "url": "https://github.com/googleapis/google-auth-library-php.git",[m
[32m+[m[32m                "reference": "d6389aae7c009daceaa8da9b7942d8df6969f6d9"[m
[32m+[m[32m            },[m
[32m+[m[32m            "dist": {[m
[32m+[m[32m                "type": "zip",[m
[32m+[m[32m                "url": "https://api.github.com/repos/googleapis/google-auth-library-php/zipball/d6389aae7c009daceaa8da9b7942d8df6969f6d9",[m
[32m+[m[32m                "reference": "d6389aae7c009daceaa8da9b7942d8df6969f6d9",[m
[32m+[m[32m                "shasum": ""[m
[32m+[m[32m            },[m
[32m+[m[32m            "require": {[m
[32m+[m[32m                "firebase/php-jwt": "^6.0",[m
[32m+[m[32m                "guzzlehttp/guzzle": "^7.4.5",[m
[32m+[m[32m                "guzzlehttp/psr7": "^2.4.5",[m
[32m+[m[32m                "php": "^8.0",[m
[32m+[m[32m                "psr/cache": "^2.0||^3.0",[m
[32m+[m[32m                "psr/http-message": "^1.1||^2.0",[m
[32m+[m[32m                "psr/log": "^3.0"[m
[32m+[m[32m            },[m
[32m+[m[32m            "require-dev": {[m
[32m+[m[32m                "guzzlehttp/promises": "^2.0",[m
[32m+[m[32m                "kelvinmo/simplejwt": "0.7.1",[m
[32m+[m[32m                "phpseclib/phpseclib": "^3.0.35",[m
[32m+[m[32m                "phpspec/prophecy-phpunit": "^2.1",[m
[32m+[m[32m                "phpunit/phpunit": "^9.6",[m
[32m+[m[32m                "sebastian/comparator": ">=1.2.3",[m
[32m+[m[32m                "squizlabs/php_codesniffer": "^3.5",[m
[32m+[m[32m                "symfony/process": "^6.0||^7.0",[m
[32m+[m[32m                "webmozart/assert": "^1.11"[m
[32m+[m[32m            },[m
[32m+[m[32m            "suggest": {[m
[32m+[m[32m                "phpseclib/phpseclib": "May be used in place of OpenSSL for signing strings or for token management. Please require version ^2."[m
[32m+[m[32m            },[m
[32m+[m[32m            "time": "2025-04-15T21:47:20+00:00",[m
[32m+[m[32m            "type": "library",[m
[32m+[m[32m            "installation-source": "source",[m
[32m+[m[32m            "autoload": {[m
[32m+[m[32m                "psr-4": {[m
[32m+[m[32m                    "Google\\Auth\\": "src"[m
[32m+[m[32m                }[m
[32m+[m[32m            },[m
[32m+[m[32m            "notification-url": "https://packagist.org/downloads/",[m
[32m+[m[32m            "license": [[m
[32m+[m[32m                "Apache-2.0"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "description": "Google Auth Library for PHP",[m
[32m+[m[32m            "homepage": "https://github.com/google/google-auth-library-php",[m
[32m+[m[32m            "keywords": [[m
[32m+[m[32m                "Authentication",[m
[32m+[m[32m                "google",[m
[32m+[m[32m                "oauth2"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "support": {[m
[32m+[m[32m                "docs": "https://cloud.google.com/php/docs/reference/auth/latest",[m
[32m+[m[32m                "issues": "https://github.com/googleapis/google-auth-library-php/issues",[m
[32m+[m[32m                "source": "https://github.com/googleapis/google-auth-library-php/tree/v1.47.0"[m
[32m+[m[32m            },[m
[32m+[m[32m            "install-path": "../google/auth"[m
[32m+[m[32m        },[m
[32m+[m[32m        {[m
[32m+[m[32m            "name": "guzzlehttp/guzzle",[m
[32m+[m[32m            "version": "7.9.3",[m
[32m+[m[32m            "version_normalized": "7.9.3.0",[m
[32m+[m[32m            "source": {[m
[32m+[m[32m                "type": "git",[m
[32m+[m[32m                "url": "https://github.com/guzzle/guzzle.git",[m
[32m+[m[32m                "reference": "7b2f29fe81dc4da0ca0ea7d42107a0845946ea77"[m
[32m+[m[32m            },[m
[32m+[m[32m            "dist": {[m
[32m+[m[32m                "type": "zip",[m
[32m+[m[32m                "url": "https://api.github.com/repos/guzzle/guzzle/zipball/7b2f29fe81dc4da0ca0ea7d42107a0845946ea77",[m
[32m+[m[32m                "reference": "7b2f29fe81dc4da0ca0ea7d42107a0845946ea77",[m
[32m+[m[32m                "shasum": ""[m
[32m+[m[32m            },[m
[32m+[m[32m            "require": {[m
[32m+[m[32m                "ext-json": "*",[m
[32m+[m[32m                "guzzlehttp/promises": "^1.5.3 || ^2.0.3",[m
[32m+[m[32m                "guzzlehttp/psr7": "^2.7.0",[m
[32m+[m[32m                "php": "^7.2.5 || ^8.0",[m
[32m+[m[32m                "psr/http-client": "^1.0",[m
[32m+[m[32m                "symfony/deprecation-contracts": "^2.2 || ^3.0"[m
[32m+[m[32m            },[m
[32m+[m[32m            "provide": {[m
[32m+[m[32m                "psr/http-client-implementation": "1.0"[m
[32m+[m[32m            },[m
[32m+[m[32m            "require-dev": {[m
[32m+[m[32m                "bamarni/composer-bin-plugin": "^1.8.2",[m
[32m+[m[32m                "ext-curl": "*",[m
[32m+[m[32m                "guzzle/client-integration-tests": "3.0.2",[m
[32m+[m[32m                "php-http/message-factory": "^1.1",[m
[32m+[m[32m                "phpunit/phpunit": "^8.5.39 || ^9.6.20",[m
[32m+[m[32m                "psr/log": "^1.1 || ^2.0 || ^3.0"[m
[32m+[m[32m            },[m
[32m+[m[32m            "suggest": {[m
[32m+[m[32m                "ext-curl": "Required for CURL handler support",[m
[32m+[m[32m                "ext-intl": "Required for Internationalized Domain Name (IDN) support",[m
[32m+[m[32m                "psr/log": "Required for using the Log middleware"[m
[32m+[m[32m            },[m
[32m+[m[32m            "time": "2025-03-27T13:37:11+00:00",[m
[32m+[m[32m            "type": "library",[m
[32m+[m[32m            "extra": {[m
[32m+[m[32m                "bamarni-bin": {[m
[32m+[m[32m                    "bin-links": true,[m
[32m+[m[32m                    "forward-command": false[m
[32m+[m[32m                }[m
[32m+[m[32m            },[m
[32m+[m[32m            "installation-source": "source",[m
[32m+[m[32m            "autoload": {[m
[32m+[m[32m                "files": [[m
[32m+[m[32m                    "src/functions_include.php"[m
[32m+[m[32m                ],[m
[32m+[m[32m                "psr-4": {[m
[32m+[m[32m                    "GuzzleHttp\\": "src/"[m
[32m+[m[32m                }[m
[32m+[m[32m            },[m
[32m+[m[32m            "notification-url": "https://packagist.org/downloads/",[m
[32m+[m[32m            "license": [[m
[32m+[m[32m                "MIT"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "authors": [[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Graham Campbell",[m
[32m+[m[32m                    "email": "hello@gjcampbell.co.uk",[m
[32m+[m[32m                    "homepage": "https://github.com/GrahamCampbell"[m
                 },[m
                 {[m
[31m-                    "name": "Andy Prevost",[m
[31m-                    "email": "codeworxtech@users.sourceforge.net"[m
[32m+[m[32m                    "name": "Michael Dowling",[m
[32m+[m[32m                    "email": "mtdowling@gmail.com",[m
[32m+[m[32m                    "homepage": "https://github.com/mtdowling"[m
                 },[m
                 {[m
[31m-                    "name": "Brent R. Matzelle"[m
[32m+[m[32m                    "name": "Jeremy Lindblom",[m
[32m+[m[32m                    "email": "jeremeamia@gmail.com",[m
[32m+[m[32m                    "homepage": "https://github.com/jeremeamia"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "George Mponos",[m
[32m+[m[32m                    "email": "gmponos@gmail.com",[m
[32m+[m[32m                    "homepage": "https://github.com/gmponos"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Tobias Nyholm",[m
[32m+[m[32m                    "email": "tobias.nyholm@gmail.com",[m
[32m+[m[32m                    "homepage": "https://github.com/Nyholm"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Márk Sági-Kazár",[m
[32m+[m[32m                    "email": "mark.sagikazar@gmail.com",[m
[32m+[m[32m                    "homepage": "https://github.com/sagikazarmark"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Tobias Schultze",[m
[32m+[m[32m                    "email": "webmaster@tubo-world.de",[m
[32m+[m[32m                    "homepage": "https://github.com/Tobion"[m
                 }[m
             ],[m
[31m-            "description": "PHPMailer is a full-featured email creation and transfer class for PHP",[m
[32m+[m[32m            "description": "Guzzle is a PHP HTTP client library",[m
[32m+[m[32m            "keywords": [[m
[32m+[m[32m                "client",[m
[32m+[m[32m                "curl",[m
[32m+[m[32m                "framework",[m
[32m+[m[32m                "http",[m
[32m+[m[32m                "http client",[m
[32m+[m[32m                "psr-18",[m
[32m+[m[32m                "psr-7",[m
[32m+[m[32m                "rest",[m
[32m+[m[32m                "web service"[m
[32m+[m[32m            ],[m
             "support": {[m
[31m-                "issues": "https://github.com/PHPMailer/PHPMailer/issues",[m
[31m-                "source": "https://github.com/PHPMailer/PHPMailer/tree/v6.9.3"[m
[32m+[m[32m                "issues": "https://github.com/guzzle/guzzle/issues",[m
[32m+[m[32m                "source": "https://github.com/guzzle/guzzle/tree/7.9.3"[m
             },[m
             "funding": [[m
                 {[m
[31m-                    "url": "https://github.com/Synchro",[m
[32m+[m[32m                    "url": "https://github.com/GrahamCampbell",[m
                     "type": "github"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "url": "https://github.com/Nyholm",[m
[32m+[m[32m                    "type": "github"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "url": "https://tidelift.com/funding/github/packagist/guzzlehttp/guzzle",[m
[32m+[m[32m                    "type": "tidelift"[m
                 }[m
             ],[m
[31m-            "install-path": "../phpmailer/phpmailer"[m
[32m+[m[32m            "install-path": "../guzzlehttp/guzzle"[m
[32m+[m[32m        },[m
[32m+[m[32m        {[m
[32m+[m[32m            "name": "guzzlehttp/promises",[m
[32m+[m[32m            "version": "2.2.0",[m
[32m+[m[32m            "version_normalized": "2.2.0.0",[m
[32m+[m[32m            "source": {[m
[32m+[m[32m                "type": "git",[m
[32m+[m[32m                "url": "https://github.com/guzzle/promises.git",[m
[32m+[m[32m                "reference": "7c69f28996b0a6920945dd20b3857e499d9ca96c"[m
[32m+[m[32m            },[m
[32m+[m[32m            "dist": {[m
[32m+[m[32m                "type": "zip",[m
[32m+[m[32m                "url": "https://api.github.com/repos/guzzle/promises/zipball/7c69f28996b0a6920945dd20b3857e499d9ca96c",[m
[32m+[m[32m                "reference": "7c69f28996b0a6920945dd20b3857e499d9ca96c",[m
[32m+[m[32m                "shasum": ""[m
[32m+[m[32m            },[m
[32m+[m[32m            "require": {[m
[32m+[m[32m                "php": "^7.2.5 || ^8.0"[m
[32m+[m[32m            },[m
[32m+[m[32m            "require-dev": {[m
[32m+[m[32m                "bamarni/composer-bin-plugin": "^1.8.2",[m
[32m+[m[32m                "phpunit/phpunit": "^8.5.39 || ^9.6.20"[m
[32m+[m[32m            },[m
[32m+[m[32m            "time": "2025-03-27T13:27:01+00:00",[m
[32m+[m[32m            "type": "library",[m
[32m+[m[32m            "extra": {[m
[32m+[m[32m                "bamarni-bin": {[m
[32m+[m[32m                    "bin-links": true,[m
[32m+[m[32m                    "forward-command": false[m
[32m+[m[32m                }[m
[32m+[m[32m            },[m
[32m+[m[32m            "installation-source": "source",[m
[32m+[m[32m            "autoload": {[m
[32m+[m[32m                "psr-4": {[m
[32m+[m[32m                    "GuzzleHttp\\Promise\\": "src/"[m
[32m+[m[32m                }[m
[32m+[m[32m            },[m
[32m+[m[32m            "notification-url": "https://packagist.org/downloads/",[m
[32m+[m[32m            "license": [[m
[32m+[m[32m                "MIT"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "authors": [[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Graham Campbell",[m
[32m+[m[32m                    "email": "hello@gjcampbell.co.uk",[m
[32m+[m[32m                    "homepage": "https://github.com/GrahamCampbell"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Michael Dowling",[m
[32m+[m[32m                    "email": "mtdowling@gmail.com",[m
[32m+[m[32m                    "homepage": "https://github.com/mtdowling"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Tobias Nyholm",[m
[32m+[m[32m                    "email": "tobias.nyholm@gmail.com",[m
[32m+[m[32m                    "homepage": "https://github.com/Nyholm"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Tobias Schultze",[m
[32m+[m[32m                    "email": "webmaster@tubo-world.de",[m
[32m+[m[32m                    "homepage": "https://github.com/Tobion"[m
[32m+[m[32m                }[m
[32m+[m[32m            ],[m
[32m+[m[32m            "description": "Guzzle promises library",[m
[32m+[m[32m            "keywords": [[m
[32m+[m[32m                "promise"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "support": {[m
[32m+[m[32m                "issues": "https://github.com/guzzle/promises/issues",[m
[32m+[m[32m                "source": "https://github.com/guzzle/promises/tree/2.2.0"[m
[32m+[m[32m            },[m
[32m+[m[32m            "funding": [[m
[32m+[m[32m                {[m
[32m+[m[32m                    "url": "https://github.com/GrahamCampbell",[m
[32m+[m[32m                    "type": "github"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "url": "https://github.com/Nyholm",[m
[32m+[m[32m                    "type": "github"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "url": "https://tidelift.com/funding/github/packagist/guzzlehttp/promises",[m
[32m+[m[32m                    "type": "tidelift"[m
[32m+[m[32m                }[m
[32m+[m[32m            ],[m
[32m+[m[32m            "install-path": "../guzzlehttp/promises"[m
[32m+[m[32m        },[m
[32m+[m[32m        {[m
[32m+[m[32m            "name": "guzzlehttp/psr7",[m
[32m+[m[32m            "version": "2.7.1",[m
[32m+[m[32m            "version_normalized": "2.7.1.0",[m
[32m+[m[32m            "source": {[m
[32m+[m[32m                "type": "git",[m
[32m+[m[32m                "url": "https://github.com/guzzle/psr7.git",[m
[32m+[m[32m                "reference": "c2270caaabe631b3b44c85f99e5a04bbb8060d16"[m
[32m+[m[32m            },[m
[32m+[m[32m            "dist": {[m
[32m+[m[32m                "type": "zip",[m
[32m+[m[32m                "url": "https://api.github.com/repos/guzzle/psr7/zipball/c2270caaabe631b3b44c85f99e5a04bbb8060d16",[m
[32m+[m[32m                "reference": "c2270caaabe631b3b44c85f99e5a04bbb8060d16",[m
[32m+[m[32m                "shasum": ""[m
[32m+[m[32m            },[m
[32m+[m[32m            "require": {[m
[32m+[m[32m                "php": "^7.2.5 || ^8.0",[m
[32m+[m[32m                "psr/http-factory": "^1.0",[m
[32m+[m[32m                "psr/http-message": "^1.1 || ^2.0",[m
[32m+[m[32m                "ralouphie/getallheaders": "^3.0"[m
[32m+[m[32m            },[m
[32m+[m[32m            "provide": {[m
[32m+[m[32m                "psr/http-factory-implementation": "1.0",[m
[32m+[m[32m                "psr/http-message-implementation": "1.0"[m
[32m+[m[32m            },[m
[32m+[m[32m            "require-dev": {[m
[32m+[m[32m                "bamarni/composer-bin-plugin": "^1.8.2",[m
[32m+[m[32m                "http-interop/http-factory-tests": "0.9.0",[m
[32m+[m[32m                "phpunit/phpunit": "^8.5.39 || ^9.6.20"[m
[32m+[m[32m            },[m
[32m+[m[32m            "suggest": {[m
[32m+[m[32m                "laminas/laminas-httphandlerrunner": "Emit PSR-7 responses"[m
[32m+[m[32m            },[m
[32m+[m[32m            "time": "2025-03-27T12:30:47+00:00",[m
[32m+[m[32m            "type": "library",[m
[32m+[m[32m            "extra": {[m
[32m+[m[32m                "bamarni-bin": {[m
[32m+[m[32m                    "bin-links": true,[m
[32m+[m[32m                    "forward-command": false[m
[32m+[m[32m                }[m
[32m+[m[32m            },[m
[32m+[m[32m            "installation-source": "source",[m
[32m+[m[32m            "autoload": {[m
[32m+[m[32m                "psr-4": {[m
[32m+[m[32m                    "GuzzleHttp\\Psr7\\": "src/"[m
[32m+[m[32m                }[m
[32m+[m[32m            },[m
[32m+[m[32m            "notification-url": "https://packagist.org/downloads/",[m
[32m+[m[32m            "license": [[m
[32m+[m[32m                "MIT"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "authors": [[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Graham Campbell",[m
[32m+[m[32m                    "email": "hello@gjcampbell.co.uk",[m
[32m+[m[32m                    "homepage": "https://github.com/GrahamCampbell"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Michael Dowling",[m
[32m+[m[32m                    "email": "mtdowling@gmail.com",[m
[32m+[m[32m                    "homepage": "https://github.com/mtdowling"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "George Mponos",[m
[32m+[m[32m                    "email": "gmponos@gmail.com",[m
[32m+[m[32m                    "homepage": "https://github.com/gmponos"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Tobias Nyholm",[m
[32m+[m[32m                    "email": "tobias.nyholm@gmail.com",[m
[32m+[m[32m                    "homepage": "https://github.com/Nyholm"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Márk Sági-Kazár",[m
[32m+[m[32m                    "email": "mark.sagikazar@gmail.com",[m
[32m+[m[32m                    "homepage": "https://github.com/sagikazarmark"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Tobias Schultze",[m
[32m+[m[32m                    "email": "webmaster@tubo-world.de",[m
[32m+[m[32m                    "homepage": "https://github.com/Tobion"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Márk Sági-Kazár",[m
[32m+[m[32m                    "email": "mark.sagikazar@gmail.com",[m
[32m+[m[32m                    "homepage": "https://sagikazarmark.hu"[m
[32m+[m[32m                }[m
[32m+[m[32m            ],[m
[32m+[m[32m            "description": "PSR-7 message implementation that also provides common utility methods",[m
[32m+[m[32m            "keywords": [[m
[32m+[m[32m                "http",[m
[32m+[m[32m                "message",[m
[32m+[m[32m                "psr-7",[m
[32m+[m[32m                "request",[m
[32m+[m[32m                "response",[m
[32m+[m[32m                "stream",[m
[32m+[m[32m                "uri",[m
[32m+[m[32m                "url"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "support": {[m
[32m+[m[32m                "issues": "https://github.com/guzzle/psr7/issues",[m
[32m+[m[32m                "source": "https://github.com/guzzle/psr7/tree/2.7.1"[m
[32m+[m[32m            },[m
[32m+[m[32m            "funding": [[m
[32m+[m[32m                {[m
[32m+[m[32m                    "url": "https://github.com/GrahamCampbell",[m
[32m+[m[32m                    "type": "github"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "url": "https://github.com/Nyholm",[m
[32m+[m[32m                    "type": "github"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "url": "https://tidelift.com/funding/github/packagist/guzzlehttp/psr7",[m
[32m+[m[32m                    "type": "tidelift"[m
[32m+[m[32m                }[m
[32m+[m[32m            ],[m
[32m+[m[32m            "install-path": "../guzzlehttp/psr7"[m
[32m+[m[32m        },[m
[32m+[m[32m        {[m
[32m+[m[32m            "name": "league/oauth2-client",[m
[32m+[m[32m            "version": "2.8.1",[m
[32m+[m[32m            "version_normalized": "2.8.1.0",[m
[32m+[m[32m            "source": {[m
[32m+[m[32m                "type": "git",[m
[32m+[m[32m                "url": "https://github.com/thephpleague/oauth2-client.git",[m
[32m+[m[32m                "reference": "9df2924ca644736c835fc60466a3a60390d334f9"[m
[32m+[m[32m            },[m
[32m+[m[32m            "dist": {[m
[32m+[m[32m                "type": "zip",[m
[32m+[m[32m                "url": "https://api.github.com/repos/thephpleague/oauth2-client/zipball/9df2924ca644736c835fc60466a3a60390d334f9",[m
[32m+[m[32m                "reference": "9df2924ca644736c835fc60466a3a60390d334f9",[m
[32m+[m[32m                "shasum": ""[m
[32m+[m[32m            },[m
[32m+[m[32m            "require": {[m
[32m+[m[32m                "ext-json": "*",[m
[32m+[m[32m                "guzzlehttp/guzzle": "^6.5.8 || ^7.4.5",[m
[32m+[m[32m                "php": "^7.1 || >=8.0.0 <8.5.0"[m
[32m+[m[32m            },[m
[32m+[m[32m            "require-dev": {[m
[32m+[m[32m                "mockery/mockery": "^1.3.5",[m
[32m+[m[32m                "php-parallel-lint/php-parallel-lint": "^1.4",[m
[32m+[m[32m                "phpunit/phpunit": "^7 || ^8 || ^9 || ^10 || ^11",[m
[32m+[m[32m                "squizlabs/php_codesniffer": "^3.11"[m
[32m+[m[32m            },[m
[32m+[m[32m            "time": "2025-02-26T04:37:30+00:00",[m
[32m+[m[32m            "type": "library",[m
[32m+[m[32m            "installation-source": "source",[m
[32m+[m[32m            "autoload": {[m
[32m+[m[32m                "psr-4": {[m
[32m+[m[32m                    "League\\OAuth2\\Client\\": "src/"[m
[32m+[m[32m                }[m
[32m+[m[32m            },[m
[32m+[m[32m            "notification-url": "https://packagist.org/downloads/",[m
[32m+[m[32m            "license": [[m
[32m+[m[32m                "MIT"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "authors": [[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Alex Bilbie",[m
[32m+[m[32m                    "email": "hello@alexbilbie.com",[m
[32m+[m[32m                    "homepage": "http://www.alexbilbie.com",[m
[32m+[m[32m                    "role": "Developer"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Woody Gilk",[m
[32m+[m[32m                    "homepage": "https://github.com/shadowhand",[m
[32m+[m[32m                    "role": "Contributor"[m
[32m+[m[32m                }[m
[32m+[m[32m            ],[m
[32m+[m[32m            "description": "OAuth 2.0 Client Library",[m
[32m+[m[32m            "keywords": [[m
[32m+[m[32m                "Authentication",[m
[32m+[m[32m                "SSO",[m
[32m+[m[32m                "authorization",[m
[32m+[m[32m                "identity",[m
[32m+[m[32m                "idp",[m
[32m+[m[32m                "oauth",[m
[32m+[m[32m                "oauth2",[m
[32m+[m[32m                "single sign on"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "support": {[m
[32m+[m[32m                "issues": "https://github.com/thephpleague/oauth2-client/issues",[m
[32m+[m[32m                "source": "https://github.com/thephpleague/oauth2-client/tree/2.8.1"[m
[32m+[m[32m            },[m
[32m+[m[32m            "install-path": "../league/oauth2-client"[m
[32m+[m[32m        },[m
[32m+[m[32m        {[m
[32m+[m[32m            "name": "league/oauth2-google",[m
[32m+[m[32m            "version": "4.0.1",[m
[32m+[m[32m            "version_normalized": "4.0.1.0",[m
[32m+[m[32m            "source": {[m
[32m+[m[32m                "type": "git",[m
[32m+[m[32m                "url": "https://github.com/thephpleague/oauth2-google.git",[m
[32m+[m[32m                "reference": "1b01ba18ba31b29e88771e3e0979e5c91d4afe76"[m
[32m+[m[32m            },[m
[32m+[m[32m            "dist": {[m
[32m+[m[32m                "type": "zip",[m
[32m+[m[32m                "url": "https://api.github.com/repos/thephpleague/oauth2-google/zipball/1b01ba18ba31b29e88771e3e0979e5c91d4afe76",[m
[32m+[m[32m                "reference": "1b01ba18ba31b29e88771e3e0979e5c91d4afe76",[m
[32m+[m[32m                "shasum": ""[m
[32m+[m[32m            },[m
[32m+[m[32m            "require": {[m
[32m+[m[32m                "league/oauth2-client": "^2.0",[m
[32m+[m[32m                "php": "^7.3 || ^8.0"[m
[32m+[m[32m            },[m
[32m+[m[32m            "require-dev": {[m
[32m+[m[32m                "eloquent/phony-phpunit": "^6.0 || ^7.1",[m
[32m+[m[32m                "phpunit/phpunit": "^8.0 || ^9.0",[m
[32m+[m[32m                "squizlabs/php_codesniffer": "^3.0"[m
[32m+[m[32m            },[m
[32m+[m[32m            "time": "2023-03-17T15:20:52+00:00",[m
[32m+[m[32m            "type": "library",[m
[32m+[m[32m            "installation-source": "source",[m
[32m+[m[32m            "autoload": {[m
[32m+[m[32m                "psr-4": {[m
[32m+[m[32m                    "League\\OAuth2\\Client\\": "src/"[m
[32m+[m[32m                }[m
[32m+[m[32m            },[m
[32m+[m[32m            "notification-url": "https://packagist.org/downloads/",[m
[32m+[m[32m            "license": [[m
[32m+[m[32m                "MIT"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "authors": [[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Woody Gilk",[m
[32m+[m[32m                    "email": "hello@shadowhand.com",[m
[32m+[m[32m                    "homepage": "https://shadowhand.com"[m
[32m+[m[32m                }[m
[32m+[m[32m            ],[m
[32m+[m[32m            "description": "Google OAuth 2.0 Client Provider for The PHP League OAuth2-Client",[m
[32m+[m[32m            "keywords": [[m
[32m+[m[32m                "Authentication",[m
[32m+[m[32m                "authorization",[m
[32m+[m[32m                "client",[m
[32m+[m[32m                "google",[m
[32m+[m[32m                "oauth",[m
[32m+[m[32m                "oauth2"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "support": {[m
[32m+[m[32m                "issues": "https://github.com/thephpleague/oauth2-google/issues",[m
[32m+[m[32m                "source": "https://github.com/thephpleague/oauth2-google/tree/4.0.1"[m
[32m+[m[32m            },[m
[32m+[m[32m            "install-path": "../league/oauth2-google"[m
[32m+[m[32m        },[m
[32m+[m[32m        {[m
[32m+[m[32m            "name": "monolog/monolog",[m
[32m+[m[32m            "version": "3.9.0",[m
[32m+[m[32m            "version_normalized": "3.9.0.0",[m
[32m+[m[32m            "source": {[m
[32m+[m[32m                "type": "git",[m
[32m+[m[32m                "url": "https://github.com/Seldaek/monolog.git",[m
[32m+[m[32m                "reference": "10d85740180ecba7896c87e06a166e0c95a0e3b6"[m
[32m+[m[32m            },[m
[32m+[m[32m            "dist": {[m
[32m+[m[32m                "type": "zip",[m
[32m+[m[32m                "url": "https://api.github.com/repos/Seldaek/monolog/zipball/10d85740180ecba7896c87e06a166e0c95a0e3b6",[m
[32m+[m[32m                "reference": "10d85740180ecba7896c87e06a166e0c95a0e3b6",[m
[32m+[m[32m                "shasum": ""[m
[32m+[m[32m            },[m
[32m+[m[32m            "require": {[m
[32m+[m[32m                "php": ">=8.1",[m
[32m+[m[32m                "psr/log": "^2.0 || ^3.0"[m
[32m+[m[32m            },[m
[32m+[m[32m            "provide": {[m
[32m+[m[32m                "psr/log-implementation": "3.0.0"[m
[32m+[m[32m            },[m
[32m+[m[32m            "require-dev": {[m
[32m+[m[32m                "aws/aws-sdk-php": "^3.0",[m
[32m+[m[32m                "doctrine/couchdb": "~1.0@dev",[m
[32m+[m[32m                "elasticsearch/elasticsearch": "^7 || ^8",[m
[32m+[m[32m                "ext-json": "*",[m
[32m+[m[32m                "graylog2/gelf-php": "^1.4.2 || ^2.0",[m
[32m+[m[32m                "guzzlehttp/guzzle": "^7.4.5",[m
[32m+[m[32m                "guzzlehttp/psr7": "^2.2",[m
[32m+[m[32m                "mongodb/mongodb": "^1.8",[m
[32m+[m[32m                "php-amqplib/php-amqplib": "~2.4 || ^3",[m
[32m+[m[32m                "php-console/php-console": "^3.1.8",[m
[32m+[m[32m                "phpstan/phpstan": "^2",[m
[32m+[m[32m                "phpstan/phpstan-deprecation-rules": "^2",[m
[32m+[m[32m                "phpstan/phpstan-strict-rules": "^2",[m
[32m+[m[32m                "phpunit/phpunit": "^10.5.17 || ^11.0.7",[m
[32m+[m[32m                "predis/predis": "^1.1 || ^2",[m
[32m+[m[32m                "rollbar/rollbar": "^4.0",[m
[32m+[m[32m                "ruflin/elastica": "^7 || ^8",[m
[32m+[m[32m                "symfony/mailer": "^5.4 || ^6",[m
[32m+[m[32m                "symfony/mime": "^5.4 || ^6"[m
[32m+[m[32m            },[m
[32m+[m[32m            "suggest": {[m
[32m+[m[32m                "aws/aws-sdk-php": "Allow sending log messages to AWS services like DynamoDB",[m
[32m+[m[32m                "doctrine/couchdb": "Allow sending log messages to a CouchDB server",[m
[32m+[m[32m                "elasticsearch/elasticsearch": "Allow sending log messages to an Elasticsearch server via official client",[m
[32m+[m[32m                "ext-amqp": "Allow sending log messages to an AMQP server (1.0+ required)",[m
[32m+[m[32m                "ext-curl": "Required to send log messages using the IFTTTHandler, the LogglyHandler, the SendGridHandler, the SlackWebhookHandler or the TelegramBotHandler",[m
[32m+[m[32m                "ext-mbstring": "Allow to work properly with unicode symbols",[m
[32m+[m[32m                "ext-mongodb": "Allow sending log messages to a MongoDB server (via driver)",[m
[32m+[m[32m                "ext-openssl": "Required to send log messages using SSL",[m
[32m+[m[32m                "ext-sockets": "Allow sending log messages to a Syslog server (via UDP driver)",[m
[32m+[m[32m                "graylog2/gelf-php": "Allow sending log messages to a GrayLog2 server",[m
[32m+[m[32m                "mongodb/mongodb": "Allow sending log messages to a MongoDB server (via library)",[m
[32m+[m[32m                "php-amqplib/php-amqplib": "Allow sending log messages to an AMQP server using php-amqplib",[m
[32m+[m[32m                "rollbar/rollbar": "Allow sending log messages to Rollbar",[m
[32m+[m[32m                "ruflin/elastica": "Allow sending log messages to an Elastic Search server"[m
[32m+[m[32m            },[m
[32m+[m[32m            "time": "2025-03-24T10:02:05+00:00",[m
[32m+[m[32m            "type": "library",[m
[32m+[m[32m            "extra": {[m
[32m+[m[32m                "branch-alias": {[m
[32m+[m[32m                    "dev-main": "3.x-dev"[m
[32m+[m[32m                }[m
[32m+[m[32m            },[m
[32m+[m[32m            "installation-source": "source",[m
[32m+[m[32m            "autoload": {[m
[32m+[m[32m                "psr-4": {[m
[32m+[m[32m                    "Monolog\\": "src/Monolog"[m
[32m+[m[32m                }[m
[32m+[m[32m            },[m
[32m+[m[32m            "notification-url": "https://packagist.org/downloads/",[m
[32m+[m[32m            "license": [[m
[32m+[m[32m                "MIT"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "authors": [[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Jordi Boggiano",[m
[32m+[m[32m                    "email": "j.boggiano@seld.be",[m
[32m+[m[32m                    "homepage": "https://seld.be"[m
[32m+[m[32m                }[m
[32m+[m[32m            ],[m
[32m+[m[32m            "description": "Sends your logs to files, sockets, inboxes, databases and various web services",[m
[32m+[m[32m            "homepage": "https://github.com/Seldaek/monolog",[m
[32m+[m[32m            "keywords": [[m
[32m+[m[32m                "log",[m
[32m+[m[32m                "logging",[m
[32m+[m[32m                "psr-3"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "support": {[m
[32m+[m[32m                "issues": "https://github.com/Seldaek/monolog/issues",[m
[32m+[m[32m                "source": "https://github.com/Seldaek/monolog/tree/3.9.0"[m
[32m+[m[32m            },[m
[32m+[m[32m            "funding": [[m
[32m+[m[32m                {[m
[32m+[m[32m                    "url": "https://github.com/Seldaek",[m
[32m+[m[32m                    "type": "github"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "url": "https://tidelift.com/funding/github/packagist/monolog/monolog",[m
[32m+[m[32m                    "type": "tidelift"[m
[32m+[m[32m                }[m
[32m+[m[32m            ],[m
[32m+[m[32m            "install-path": "../monolog/monolog"[m
[32m+[m[32m        },[m
[32m+[m[32m        {[m
[32m+[m[32m            "name": "paragonie/constant_time_encoding",[m
[32m+[m[32m            "version": "v3.0.0",[m
[32m+[m[32m            "version_normalized": "3.0.0.0",[m
[32m+[m[32m            "source": {[m
[32m+[m[32m                "type": "git",[m
[32m+[m[32m                "url": "https://github.com/paragonie/constant_time_encoding.git",[m
[32m+[m[32m                "reference": "df1e7fde177501eee2037dd159cf04f5f301a512"[m
[32m+[m[32m            },[m
[32m+[m[32m            "dist": {[m
[32m+[m[32m                "type": "zip",[m
[32m+[m[32m                "url": "https://api.github.com/repos/paragonie/constant_time_encoding/zipball/df1e7fde177501eee2037dd159cf04f5f301a512",[m
[32m+[m[32m                "reference": "df1e7fde177501eee2037dd159cf04f5f301a512",[m
[32m+[m[32m                "shasum": ""[m
[32m+[m[32m            },[m
[32m+[m[32m            "require": {[m
[32m+[m[32m                "php": "^8"[m
[32m+[m[32m            },[m
[32m+[m[32m            "require-dev": {[m
[32m+[m[32m                "phpunit/phpunit": "^9",[m
[32m+[m[32m                "vimeo/psalm": "^4|^5"[m
[32m+[m[32m            },[m
[32m+[m[32m            "time": "2024-05-08T12:36:18+00:00",[m
[32m+[m[32m            "type": "library",[m
[32m+[m[32m            "installation-source": "source",[m
[32m+[m[32m            "autoload": {[m
[32m+[m[32m                "psr-4": {[m
[32m+[m[32m                    "ParagonIE\\ConstantTime\\": "src/"[m
[32m+[m[32m                }[m
[32m+[m[32m            },[m
[32m+[m[32m            "notification-url": "https://packagist.org/downloads/",[m
[32m+[m[32m            "license": [[m
[32m+[m[32m                "MIT"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "authors": [[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Paragon Initiative Enterprises",[m
[32m+[m[32m                    "email": "security@paragonie.com",[m
[32m+[m[32m                    "homepage": "https://paragonie.com",[m
[32m+[m[32m                    "role": "Maintainer"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Steve 'Sc00bz' Thomas",[m
[32m+[m[32m                    "email": "steve@tobtu.com",[m
[32m+[m[32m                    "homepage": "https://www.tobtu.com",[m
[32m+[m[32m                    "role": "Original Developer"[m
[32m+[m[32m                }[m
[32m+[m[32m            ],[m
[32m+[m[32m            "description": "Constant-time Implementations of RFC 4648 Encoding (Base-64, Base-32, Base-16)",[m
[32m+[m[32m            "keywords": [[m
[32m+[m[32m                "base16",[m
[32m+[m[32m                "base32",[m
[32m+[m[32m                "base32_decode",[m
[32m+[m[32m                "base32_encode",[m
[32m+[m[32m                "base64",[m
[32m+[m[32m                "base64_decode",[m
[32m+[m[32m                "base64_encode",[m
[32m+[m[32m                "bin2hex",[m
[32m+[m[32m                "encoding",[m
[32m+[m[32m                "hex",[m
[32m+[m[32m                "hex2bin",[m
[32m+[m[32m                "rfc4648"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "support": {[m
[32m+[m[32m                "email": "info@paragonie.com",[m
[32m+[m[32m                "issues": "https://github.com/paragonie/constant_time_encoding/issues",[m
[32m+[m[32m                "source": "https://github.com/paragonie/constant_time_encoding"[m
[32m+[m[32m            },[m
[32m+[m[32m            "install-path": "../paragonie/constant_time_encoding"[m
[32m+[m[32m        },[m
[32m+[m[32m        {[m
[32m+[m[32m            "name": "paragonie/random_compat",[m
[32m+[m[32m            "version": "v9.99.100",[m
[32m+[m[32m            "version_normalized": "9.99.100.0",[m
[32m+[m[32m            "source": {[m
[32m+[m[32m                "type": "git",[m
[32m+[m[32m                "url": "https://github.com/paragonie/random_compat.git",[m
[32m+[m[32m                "reference": "996434e5492cb4c3edcb9168db6fbb1359ef965a"[m
[32m+[m[32m            },[m
[32m+[m[32m            "dist": {[m
[32m+[m[32m                "type": "zip",[m
[32m+[m[32m                "url": "https://api.github.com/repos/paragonie/random_compat/zipball/996434e5492cb4c3edcb9168db6fbb1359ef965a",[m
[32m+[m[32m                "reference": "996434e5492cb4c3edcb9168db6fbb1359ef965a",[m
[32m+[m[32m                "shasum": ""[m
[32m+[m[32m            },[m
[32m+[m[32m            "require": {[m
[32m+[m[32m                "php": ">= 7"[m
[32m+[m[32m            },[m
[32m+[m[32m            "require-dev": {[m
[32m+[m[32m                "phpunit/phpunit": "4.*|5.*",[m
[32m+[m[32m                "vimeo/psalm": "^1"[m
[32m+[m[32m            },[m
[32m+[m[32m            "suggest": {[m
[32m+[m[32m                "ext-libsodium": "Provides a modern crypto API that can be used to generate random bytes."[m
[32m+[m[32m            },[m
[32m+[m[32m            "time": "2020-10-15T08:29:30+00:00",[m
[32m+[m[32m            "type": "library",[m
[32m+[m[32m            "installation-source": "source",[m
[32m+[m[32m            "notification-url": "https://packagist.org/downloads/",[m
[32m+[m[32m            "license": [[m
[32m+[m[32m                "MIT"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "authors": [[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Paragon Initiative Enterprises",[m
[32m+[m[32m                    "email": "security@paragonie.com",[m
[32m+[m[32m                    "homepage": "https://paragonie.com"[m
[32m+[m[32m                }[m
[32m+[m[32m            ],[m
[32m+[m[32m            "description": "PHP 5.x polyfill for random_bytes() and random_int() from PHP 7",[m
[32m+[m[32m            "keywords": [[m
[32m+[m[32m                "csprng",[m
[32m+[m[32m                "polyfill",[m
[32m+[m[32m                "pseudorandom",[m
[32m+[m[32m                "random"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "support": {[m
[32m+[m[32m                "email": "info@paragonie.com",[m
[32m+[m[32m                "issues": "https://github.com/paragonie/random_compat/issues",[m
[32m+[m[32m                "source": "https://github.com/paragonie/random_compat"[m
[32m+[m[32m            },[m
[32m+[m[32m            "install-path": "../paragonie/random_compat"[m
[32m+[m[32m        },[m
[32m+[m[32m        {[m
[32m+[m[32m            "name": "phpmailer/phpmailer",[m
[32m+[m[32m            "version": "v6.10.0",[m
[32m+[m[32m            "version_normalized": "6.10.0.0",[m
[32m+[m[32m            "source": {[m
[32m+[m[32m                "type": "git",[m
[32m+[m[32m                "url": "https://github.com/PHPMailer/PHPMailer.git",[m
[32m+[m[32m                "reference": "bf74d75a1fde6beaa34a0ddae2ec5fce0f72a144"[m
[32m+[m[32m            },[m
[32m+[m[32m            "dist": {[m
[32m+[m[32m                "type": "zip",[m
[32m+[m[32m                "url": "https://api.github.com/repos/PHPMailer/PHPMailer/zipball/bf74d75a1fde6beaa34a0ddae2ec5fce0f72a144",[m
[32m+[m[32m                "reference": "bf74d75a1fde6beaa34a0ddae2ec5fce0f72a144",[m
[32m+[m[32m                "shasum": ""[m
[32m+[m[32m            },[m
[32m+[m[32m            "require": {[m
[32m+[m[32m                "ext-ctype": "*",[m
[32m+[m[32m                "ext-filter": "*",[m
[32m+[m[32m                "ext-hash": "*",[m
[32m+[m[32m                "php": ">=5.5.0"[m
[32m+[m[32m            },[m
[32m+[m[32m            "require-dev": {[m
[32m+[m[32m                "dealerdirect/phpcodesniffer-composer-installer": "^1.0",[m
[32m+[m[32m                "doctrine/annotations": "^1.2.6 || ^1.13.3",[m
[32m+[m[32m                "php-parallel-lint/php-console-highlighter": "^1.0.0",[m
[32m+[m[32m                "php-parallel-lint/php-parallel-lint": "^1.3.2",[m
[32m+[m[32m                "phpcompatibility/php-compatibility": "^9.3.5",[m
[32m+[m[32m                "roave/security-advisories": "dev-latest",[m
[32m+[m[32m                "squizlabs/php_codesniffer": "^3.7.2",[m
[32m+[m[32m                "yoast/phpunit-polyfills": "^1.0.4"[m
[32m+[m[32m            },[m
[32m+[m[32m            "suggest": {[m
[32m+[m[32m                "decomplexity/SendOauth2": "Adapter for using XOAUTH2 authentication",[m
[32m+[m[32m                "ext-mbstring": "Needed to send email in multibyte encoding charset or decode encoded addresses",[m
[32m+[m[32m                "ext-openssl": "Needed for secure SMTP sending and DKIM signing",[m
[32m+[m[32m                "greew/oauth2-azure-provider": "Needed for Microsoft Azure XOAUTH2 authentication",[m
[32m+[m[32m                "hayageek/oauth2-yahoo": "Needed for Yahoo XOAUTH2 authentication",[m
[32m+[m[32m                "league/oauth2-google": "Needed for Google XOAUTH2 authentication",[m
[32m+[m[32m                "psr/log": "For optional PSR-3 debug logging",[m
[32m+[m[32m                "symfony/polyfill-mbstring": "To support UTF-8 if the Mbstring PHP extension is not enabled (^1.2)",[m
[32m+[m[32m                "thenetworg/oauth2-azure": "Needed for Microsoft XOAUTH2 authentication"[m
[32m+[m[32m            },[m
[32m+[m[32m            "time": "2025-04-24T15:19:31+00:00",[m
[32m+[m[32m            "type": "library",[m
[32m+[m[32m            "installation-source": "source",[m
[32m+[m[32m            "autoload": {[m
[32m+[m[32m                "psr-4": {[m
[32m+[m[32m                    "PHPMailer\\PHPMailer\\": "src/"[m
[32m+[m[32m                }[m
[32m+[m[32m            },[m
[32m+[m[32m            "notification-url": "https://packagist.org/downloads/",[m
[32m+[m[32m            "license": [[m
[32m+[m[32m                "LGPL-2.1-only"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "authors": [[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Marcus Bointon",[m
[32m+[m[32m                    "email": "phpmailer@synchromedia.co.uk"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Jim Jagielski",[m
[32m+[m[32m                    "email": "jimjag@gmail.com"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Andy Prevost",[m
[32m+[m[32m                    "email": "codeworxtech@users.sourceforge.net"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Brent R. Matzelle"[m
[32m+[m[32m                }[m
[32m+[m[32m            ],[m
[32m+[m[32m            "description": "PHPMailer is a full-featured email creation and transfer class for PHP",[m
[32m+[m[32m            "support": {[m
[32m+[m[32m                "issues": "https://github.com/PHPMailer/PHPMailer/issues",[m
[32m+[m[32m                "source": "https://github.com/PHPMailer/PHPMailer/tree/v6.10.0"[m
[32m+[m[32m            },[m
[32m+[m[32m            "funding": [[m
[32m+[m[32m                {[m
[32m+[m[32m                    "url": "https://github.com/Synchro",[m
[32m+[m[32m                    "type": "github"[m
[32m+[m[32m                }[m
[32m+[m[32m            ],[m
[32m+[m[32m            "install-path": "../phpmailer/phpmailer"[m
[32m+[m[32m        },[m
[32m+[m[32m        {[m
[32m+[m[32m            "name": "phpseclib/phpseclib",[m
[32m+[m[32m            "version": "3.0.45",[m
[32m+[m[32m            "version_normalized": "3.0.45.0",[m
[32m+[m[32m            "source": {[m
[32m+[m[32m                "type": "git",[m
[32m+[m[32m                "url": "https://github.com/phpseclib/phpseclib.git",[m
[32m+[m[32m                "reference": "bd81b90d5963c6b9d87de50357585375223f4dd8"[m
[32m+[m[32m            },[m
[32m+[m[32m            "dist": {[m
[32m+[m[32m                "type": "zip",[m
[32m+[m[32m                "url": "https://api.github.com/repos/phpseclib/phpseclib/zipball/bd81b90d5963c6b9d87de50357585375223f4dd8",[m
[32m+[m[32m                "reference": "bd81b90d5963c6b9d87de50357585375223f4dd8",[m
[32m+[m[32m                "shasum": ""[m
[32m+[m[32m            },[m
[32m+[m[32m            "require": {[m
[32m+[m[32m                "paragonie/constant_time_encoding": "^1|^2|^3",[m
[32m+[m[32m                "paragonie/random_compat": "^1.4|^2.0|^9.99.99",[m
[32m+[m[32m                "php": ">=5.6.1"[m
[32m+[m[32m            },[m
[32m+[m[32m            "require-dev": {[m
[32m+[m[32m                "phpunit/phpunit": "*"[m
[32m+[m[32m            },[m
[32m+[m[32m            "suggest": {[m
[32m+[m[32m                "ext-dom": "Install the DOM extension to load XML formatted public keys.",[m
[32m+[m[32m                "ext-gmp": "Install the GMP (GNU Multiple Precision) extension in order to speed up arbitrary precision integer arithmetic operations.",[m
[32m+[m[32m                "ext-libsodium": "SSH2/SFTP can make use of some algorithms provided by the libsodium-php extension.",[m
[32m+[m[32m                "ext-mcrypt": "Install the Mcrypt extension in order to speed up a few other cryptographic operations.",[m
[32m+[m[32m                "ext-openssl": "Install the OpenSSL extension in order to speed up a wide variety of cryptographic operations."[m
[32m+[m[32m            },[m
[32m+[m[32m            "time": "2025-06-22T22:54:43+00:00",[m
[32m+[m[32m            "type": "library",[m
[32m+[m[32m            "installation-source": "source",[m
[32m+[m[32m            "autoload": {[m
[32m+[m[32m                "files": [[m
[32m+[m[32m                    "phpseclib/bootstrap.php"[m
[32m+[m[32m                ],[m
[32m+[m[32m                "psr-4": {[m
[32m+[m[32m                    "phpseclib3\\": "phpseclib/"[m
[32m+[m[32m                }[m
[32m+[m[32m            },[m
[32m+[m[32m            "notification-url": "https://packagist.org/downloads/",[m
[32m+[m[32m            "license": [[m
[32m+[m[32m                "MIT"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "authors": [[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Jim Wigginton",[m
[32m+[m[32m                    "email": "terrafrost@php.net",[m
[32m+[m[32m                    "role": "Lead Developer"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Patrick Monnerat",[m
[32m+[m[32m                    "email": "pm@datasphere.ch",[m
[32m+[m[32m                    "role": "Developer"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Andreas Fischer",[m
[32m+[m[32m                    "email": "bantu@phpbb.com",[m
[32m+[m[32m                    "role": "Developer"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Hans-Jürgen Petrich",[m
[32m+[m[32m                    "email": "petrich@tronic-media.com",[m
[32m+[m[32m                    "role": "Developer"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Graham Campbell",[m
[32m+[m[32m                    "email": "graham@alt-three.com",[m
[32m+[m[32m                    "role": "Developer"[m
[32m+[m[32m                }[m
[32m+[m[32m            ],[m
[32m+[m[32m            "description": "PHP Secure Communications Library - Pure-PHP implementations of RSA, AES, SSH2, SFTP, X.509 etc.",[m
[32m+[m[32m            "homepage": "http://phpseclib.sourceforge.net",[m
[32m+[m[32m            "keywords": [[m
[32m+[m[32m                "BigInteger",[m
[32m+[m[32m                "aes",[m
[32m+[m[32m                "asn.1",[m
[32m+[m[32m                "asn1",[m
[32m+[m[32m                "blowfish",[m
[32m+[m[32m                "crypto",[m
[32m+[m[32m                "cryptography",[m
[32m+[m[32m                "encryption",[m
[32m+[m[32m                "rsa",[m
[32m+[m[32m                "security",[m
[32m+[m[32m                "sftp",[m
[32m+[m[32m                "signature",[m
[32m+[m[32m                "signing",[m
[32m+[m[32m                "ssh",[m
[32m+[m[32m                "twofish",[m
[32m+[m[32m                "x.509",[m
[32m+[m[32m                "x509"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "support": {[m
[32m+[m[32m                "issues": "https://github.com/phpseclib/phpseclib/issues",[m
[32m+[m[32m                "source": "https://github.com/phpseclib/phpseclib/tree/3.0.45"[m
[32m+[m[32m            },[m
[32m+[m[32m            "funding": [[m
[32m+[m[32m                {[m
[32m+[m[32m                    "url": "https://github.com/terrafrost",[m
[32m+[m[32m                    "type": "github"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "url": "https://www.patreon.com/phpseclib",[m
[32m+[m[32m                    "type": "patreon"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "url": "https://tidelift.com/funding/github/packagist/phpseclib/phpseclib",[m
[32m+[m[32m                    "type": "tidelift"[m
[32m+[m[32m                }[m
[32m+[m[32m            ],[m
[32m+[m[32m            "install-path": "../phpseclib/phpseclib"[m
[32m+[m[32m        },[m
[32m+[m[32m        {[m
[32m+[m[32m            "name": "psr/cache",[m
[32m+[m[32m            "version": "3.0.0",[m
[32m+[m[32m            "version_normalized": "3.0.0.0",[m
[32m+[m[32m            "source": {[m
[32m+[m[32m                "type": "git",[m
[32m+[m[32m                "url": "https://github.com/php-fig/cache.git",[m
[32m+[m[32m                "reference": "aa5030cfa5405eccfdcb1083ce040c2cb8d253bf"[m
[32m+[m[32m            },[m
[32m+[m[32m            "dist": {[m
[32m+[m[32m                "type": "zip",[m
[32m+[m[32m                "url": "https://api.github.com/repos/php-fig/cache/zipball/aa5030cfa5405eccfdcb1083ce040c2cb8d253bf",[m
[32m+[m[32m                "reference": "aa5030cfa5405eccfdcb1083ce040c2cb8d253bf",[m
[32m+[m[32m                "shasum": ""[m
[32m+[m[32m            },[m
[32m+[m[32m            "require": {[m
[32m+[m[32m                "php": ">=8.0.0"[m
[32m+[m[32m            },[m
[32m+[m[32m            "time": "2021-02-03T23:26:27+00:00",[m
[32m+[m[32m            "type": "library",[m
[32m+[m[32m            "extra": {[m
[32m+[m[32m                "branch-alias": {[m
[32m+[m[32m                    "dev-master": "1.0.x-dev"[m
[32m+[m[32m                }[m
[32m+[m[32m            },[m
[32m+[m[32m            "installation-source": "source",[m
[32m+[m[32m            "autoload": {[m
[32m+[m[32m                "psr-4": {[m
[32m+[m[32m                    "Psr\\Cache\\": "src/"[m
[32m+[m[32m                }[m
[32m+[m[32m            },[m
[32m+[m[32m            "notification-url": "https://packagist.org/downloads/",[m
[32m+[m[32m            "license": [[m
[32m+[m[32m                "MIT"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "authors": [[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "PHP-FIG",[m
[32m+[m[32m                    "homepage": "https://www.php-fig.org/"[m
[32m+[m[32m                }[m
[32m+[m[32m            ],[m
[32m+[m[32m            "description": "Common interface for caching libraries",[m
[32m+[m[32m            "keywords": [[m
[32m+[m[32m                "cache",[m
[32m+[m[32m                "psr",[m
[32m+[m[32m                "psr-6"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "support": {[m
[32m+[m[32m                "source": "https://github.com/php-fig/cache/tree/3.0.0"[m
[32m+[m[32m            },[m
[32m+[m[32m            "install-path": "../psr/cache"[m
[32m+[m[32m        },[m
[32m+[m[32m        {[m
[32m+[m[32m            "name": "psr/container",[m
[32m+[m[32m            "version": "2.0.2",[m
[32m+[m[32m            "version_normalized": "2.0.2.0",[m
[32m+[m[32m            "source": {[m
[32m+[m[32m                "type": "git",[m
[32m+[m[32m                "url": "https://github.com/php-fig/container.git",[m
[32m+[m[32m                "reference": "c71ecc56dfe541dbd90c5360474fbc405f8d5963"[m
[32m+[m[32m            },[m
[32m+[m[32m            "dist": {[m
[32m+[m[32m                "type": "zip",[m
[32m+[m[32m                "url": "https://api.github.com/repos/php-fig/container/zipball/c71ecc56dfe541dbd90c5360474fbc405f8d5963",[m
[32m+[m[32m                "reference": "c71ecc56dfe541dbd90c5360474fbc405f8d5963",[m
[32m+[m[32m                "shasum": ""[m
[32m+[m[32m            },[m
[32m+[m[32m            "require": {[m
[32m+[m[32m                "php": ">=7.4.0"[m
[32m+[m[32m            },[m
[32m+[m[32m            "time": "2021-11-05T16:47:00+00:00",[m
[32m+[m[32m            "type": "library",[m
[32m+[m[32m            "extra": {[m
[32m+[m[32m                "branch-alias": {[m
[32m+[m[32m                    "dev-master": "2.0.x-dev"[m
[32m+[m[32m                }[m
[32m+[m[32m            },[m
[32m+[m[32m            "installation-source": "source",[m
[32m+[m[32m            "autoload": {[m
[32m+[m[32m                "psr-4": {[m
[32m+[m[32m                    "Psr\\Container\\": "src/"[m
[32m+[m[32m                }[m
[32m+[m[32m            },[m
[32m+[m[32m            "notification-url": "https://packagist.org/downloads/",[m
[32m+[m[32m            "license": [[m
[32m+[m[32m                "MIT"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "authors": [[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "PHP-FIG",[m
[32m+[m[32m                    "homepage": "https://www.php-fig.org/"[m
[32m+[m[32m                }[m
[32m+[m[32m            ],[m
[32m+[m[32m            "description": "Common Container Interface (PHP FIG PSR-11)",[m
[32m+[m[32m            "homepage": "https://github.com/php-fig/container",[m
[32m+[m[32m            "keywords": [[m
[32m+[m[32m                "PSR-11",[m
[32m+[m[32m                "container",[m
[32m+[m[32m                "container-interface",[m
[32m+[m[32m                "container-interop",[m
[32m+[m[32m                "psr"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "support": {[m
[32m+[m[32m                "issues": "https://github.com/php-fig/container/issues",[m
[32m+[m[32m                "source": "https://github.com/php-fig/container/tree/2.0.2"[m
[32m+[m[32m            },[m
[32m+[m[32m            "install-path": "../psr/container"[m
[32m+[m[32m        },[m
[32m+[m[32m        {[m
[32m+[m[32m            "name": "psr/http-client",[m
[32m+[m[32m            "version": "1.0.3",[m
[32m+[m[32m            "version_normalized": "1.0.3.0",[m
[32m+[m[32m            "source": {[m
[32m+[m[32m                "type": "git",[m
[32m+[m[32m                "url": "https://github.com/php-fig/http-client.git",[m
[32m+[m[32m                "reference": "bb5906edc1c324c9a05aa0873d40117941e5fa90"[m
[32m+[m[32m            },[m
[32m+[m[32m            "dist": {[m
[32m+[m[32m                "type": "zip",[m
[32m+[m[32m                "url": "https://api.github.com/repos/php-fig/http-client/zipball/bb5906edc1c324c9a05aa0873d40117941e5fa90",[m
[32m+[m[32m                "reference": "bb5906edc1c324c9a05aa0873d40117941e5fa90",[m
[32m+[m[32m                "shasum": ""[m
[32m+[m[32m            },[m
[32m+[m[32m            "require": {[m
[32m+[m[32m                "php": "^7.0 || ^8.0",[m
[32m+[m[32m                "psr/http-message": "^1.0 || ^2.0"[m
[32m+[m[32m            },[m
[32m+[m[32m            "time": "2023-09-23T14:17:50+00:00",[m
[32m+[m[32m            "type": "library",[m
[32m+[m[32m            "extra": {[m
[32m+[m[32m                "branch-alias": {[m
[32m+[m[32m                    "dev-master": "1.0.x-dev"[m
[32m+[m[32m                }[m
[32m+[m[32m            },[m
[32m+[m[32m            "installation-source": "source",[m
[32m+[m[32m            "autoload": {[m
[32m+[m[32m                "psr-4": {[m
[32m+[m[32m                    "Psr\\Http\\Client\\": "src/"[m
[32m+[m[32m                }[m
[32m+[m[32m            },[m
[32m+[m[32m            "notification-url": "https://packagist.org/downloads/",[m
[32m+[m[32m            "license": [[m
[32m+[m[32m                "MIT"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "authors": [[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "PHP-FIG",[m
[32m+[m[32m                    "homepage": "https://www.php-fig.org/"[m
[32m+[m[32m                }[m
[32m+[m[32m            ],[m
[32m+[m[32m            "description": "Common interface for HTTP clients",[m
[32m+[m[32m            "homepage": "https://github.com/php-fig/http-client",[m
[32m+[m[32m            "keywords": [[m
[32m+[m[32m                "http",[m
[32m+[m[32m                "http-client",[m
[32m+[m[32m                "psr",[m
[32m+[m[32m                "psr-18"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "support": {[m
[32m+[m[32m                "source": "https://github.com/php-fig/http-client"[m
[32m+[m[32m            },[m
[32m+[m[32m            "install-path": "../psr/http-client"[m
[32m+[m[32m        },[m
[32m+[m[32m        {[m
[32m+[m[32m            "name": "psr/http-factory",[m
[32m+[m[32m            "version": "1.1.0",[m
[32m+[m[32m            "version_normalized": "1.1.0.0",[m
[32m+[m[32m            "source": {[m
[32m+[m[32m                "type": "git",[m
[32m+[m[32m                "url": "https://github.com/php-fig/http-factory.git",[m
[32m+[m[32m                "reference": "2b4765fddfe3b508ac62f829e852b1501d3f6e8a"[m
[32m+[m[32m            },[m
[32m+[m[32m            "dist": {[m
[32m+[m[32m                "type": "zip",[m
[32m+[m[32m                "url": "https://api.github.com/repos/php-fig/http-factory/zipball/2b4765fddfe3b508ac62f829e852b1501d3f6e8a",[m
[32m+[m[32m                "reference": "2b4765fddfe3b508ac62f829e852b1501d3f6e8a",[m
[32m+[m[32m                "shasum": ""[m
[32m+[m[32m            },[m
[32m+[m[32m            "require": {[m
[32m+[m[32m                "php": ">=7.1",[m
[32m+[m[32m                "psr/http-message": "^1.0 || ^2.0"[m
[32m+[m[32m            },[m
[32m+[m[32m            "time": "2024-04-15T12:06:14+00:00",[m
[32m+[m[32m            "type": "library",[m
[32m+[m[32m            "extra": {[m
[32m+[m[32m                "branch-alias": {[m
[32m+[m[32m                    "dev-master": "1.0.x-dev"[m
[32m+[m[32m                }[m
[32m+[m[32m            },[m
[32m+[m[32m            "installation-source": "source",[m
[32m+[m[32m            "autoload": {[m
[32m+[m[32m                "psr-4": {[m
[32m+[m[32m                    "Psr\\Http\\Message\\": "src/"[m
[32m+[m[32m                }[m
[32m+[m[32m            },[m
[32m+[m[32m            "notification-url": "https://packagist.org/downloads/",[m
[32m+[m[32m            "license": [[m
[32m+[m[32m                "MIT"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "authors": [[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "PHP-FIG",[m
[32m+[m[32m                    "homepage": "https://www.php-fig.org/"[m
[32m+[m[32m                }[m
[32m+[m[32m            ],[m
[32m+[m[32m            "description": "PSR-17: Common interfaces for PSR-7 HTTP message factories",[m
[32m+[m[32m            "keywords": [[m
[32m+[m[32m                "factory",[m
[32m+[m[32m                "http",[m
[32m+[m[32m                "message",[m
[32m+[m[32m                "psr",[m
[32m+[m[32m                "psr-17",[m
[32m+[m[32m                "psr-7",[m
[32m+[m[32m                "request",[m
[32m+[m[32m                "response"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "support": {[m
[32m+[m[32m                "source": "https://github.com/php-fig/http-factory"[m
[32m+[m[32m            },[m
[32m+[m[32m            "install-path": "../psr/http-factory"[m
[32m+[m[32m        },[m
[32m+[m[32m        {[m
[32m+[m[32m            "name": "psr/http-message",[m
[32m+[m[32m            "version": "2.0",[m
[32m+[m[32m            "version_normalized": "2.0.0.0",[m
[32m+[m[32m            "source": {[m
[32m+[m[32m                "type": "git",[m
[32m+[m[32m                "url": "https://github.com/php-fig/http-message.git",[m
[32m+[m[32m                "reference": "402d35bcb92c70c026d1a6a9883f06b2ead23d71"[m
[32m+[m[32m            },[m
[32m+[m[32m            "dist": {[m
[32m+[m[32m                "type": "zip",[m
[32m+[m[32m                "url": "https://api.github.com/repos/php-fig/http-message/zipball/402d35bcb92c70c026d1a6a9883f06b2ead23d71",[m
[32m+[m[32m                "reference": "402d35bcb92c70c026d1a6a9883f06b2ead23d71",[m
[32m+[m[32m                "shasum": ""[m
[32m+[m[32m            },[m
[32m+[m[32m            "require": {[m
[32m+[m[32m                "php": "^7.2 || ^8.0"[m
[32m+[m[32m            },[m
[32m+[m[32m            "time": "2023-04-04T09:54:51+00:00",[m
[32m+[m[32m            "type": "library",[m
[32m+[m[32m            "extra": {[m
[32m+[m[32m                "branch-alias": {[m
[32m+[m[32m                    "dev-master": "2.0.x-dev"[m
[32m+[m[32m                }[m
[32m+[m[32m            },[m
[32m+[m[32m            "installation-source": "source",[m
[32m+[m[32m            "autoload": {[m
[32m+[m[32m                "psr-4": {[m
[32m+[m[32m                    "Psr\\Http\\Message\\": "src/"[m
[32m+[m[32m                }[m
[32m+[m[32m            },[m
[32m+[m[32m            "notification-url": "https://packagist.org/downloads/",[m
[32m+[m[32m            "license": [[m
[32m+[m[32m                "MIT"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "authors": [[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "PHP-FIG",[m
[32m+[m[32m                    "homepage": "https://www.php-fig.org/"[m
[32m+[m[32m                }[m
[32m+[m[32m            ],[m
[32m+[m[32m            "description": "Common interface for HTTP messages",[m
[32m+[m[32m            "homepage": "https://github.com/php-fig/http-message",[m
[32m+[m[32m            "keywords": [[m
[32m+[m[32m                "http",[m
[32m+[m[32m                "http-message",[m
[32m+[m[32m                "psr",[m
[32m+[m[32m                "psr-7",[m
[32m+[m[32m                "request",[m
[32m+[m[32m                "response"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "support": {[m
[32m+[m[32m                "source": "https://github.com/php-fig/http-message/tree/2.0"[m
[32m+[m[32m            },[m
[32m+[m[32m            "install-path": "../psr/http-message"[m
[32m+[m[32m        },[m
[32m+[m[32m        {[m
[32m+[m[32m            "name": "psr/log",[m
[32m+[m[32m            "version": "3.0.2",[m
[32m+[m[32m            "version_normalized": "3.0.2.0",[m
[32m+[m[32m            "source": {[m
[32m+[m[32m                "type": "git",[m
[32m+[m[32m                "url": "https://github.com/php-fig/log.git",[m
[32m+[m[32m                "reference": "f16e1d5863e37f8d8c2a01719f5b34baa2b714d3"[m
[32m+[m[32m            },[m
[32m+[m[32m            "dist": {[m
[32m+[m[32m                "type": "zip",[m
[32m+[m[32m                "url": "https://api.github.com/repos/php-fig/log/zipball/f16e1d5863e37f8d8c2a01719f5b34baa2b714d3",[m
[32m+[m[32m                "reference": "f16e1d5863e37f8d8c2a01719f5b34baa2b714d3",[m
[32m+[m[32m                "shasum": ""[m
[32m+[m[32m            },[m
[32m+[m[32m            "require": {[m
[32m+[m[32m                "php": ">=8.0.0"[m
[32m+[m[32m            },[m
[32m+[m[32m            "time": "2024-09-11T13:17:53+00:00",[m
[32m+[m[32m            "type": "library",[m
[32m+[m[32m            "extra": {[m
[32m+[m[32m                "branch-alias": {[m
[32m+[m[32m                    "dev-master": "3.x-dev"[m
[32m+[m[32m                }[m
[32m+[m[32m            },[m
[32m+[m[32m            "installation-source": "source",[m
[32m+[m[32m            "autoload": {[m
[32m+[m[32m                "psr-4": {[m
[32m+[m[32m                    "Psr\\Log\\": "src"[m
[32m+[m[32m                }[m
[32m+[m[32m            },[m
[32m+[m[32m            "notification-url": "https://packagist.org/downloads/",[m
[32m+[m[32m            "license": [[m
[32m+[m[32m                "MIT"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "authors": [[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "PHP-FIG",[m
[32m+[m[32m                    "homepage": "https://www.php-fig.org/"[m
[32m+[m[32m                }[m
[32m+[m[32m            ],[m
[32m+[m[32m            "description": "Common interface for logging libraries",[m
[32m+[m[32m            "homepage": "https://github.com/php-fig/log",[m
[32m+[m[32m            "keywords": [[m
[32m+[m[32m                "log",[m
[32m+[m[32m                "psr",[m
[32m+[m[32m                "psr-3"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "support": {[m
[32m+[m[32m                "source": "https://github.com/php-fig/log/tree/3.0.2"[m
[32m+[m[32m            },[m
[32m+[m[32m            "install-path": "../psr/log"[m
[32m+[m[32m        },[m
[32m+[m[32m        {[m
[32m+[m[32m            "name": "ralouphie/getallheaders",[m
[32m+[m[32m            "version": "3.0.3",[m
[32m+[m[32m            "version_normalized": "3.0.3.0",[m
[32m+[m[32m            "source": {[m
[32m+[m[32m                "type": "git",[m
[32m+[m[32m                "url": "https://github.com/ralouphie/getallheaders.git",[m
[32m+[m[32m                "reference": "120b605dfeb996808c31b6477290a714d356e822"[m
[32m+[m[32m            },[m
[32m+[m[32m            "dist": {[m
[32m+[m[32m                "type": "zip",[m
[32m+[m[32m                "url": "https://api.github.com/repos/ralouphie/getallheaders/zipball/120b605dfeb996808c31b6477290a714d356e822",[m
[32m+[m[32m                "reference": "120b605dfeb996808c31b6477290a714d356e822",[m
[32m+[m[32m                "shasum": ""[m
[32m+[m[32m            },[m
[32m+[m[32m            "require": {[m
[32m+[m[32m                "php": ">=5.6"[m
[32m+[m[32m            },[m
[32m+[m[32m            "require-dev": {[m
[32m+[m[32m                "php-coveralls/php-coveralls": "^2.1",[m
[32m+[m[32m                "phpunit/phpunit": "^5 || ^6.5"[m
[32m+[m[32m            },[m
[32m+[m[32m            "time": "2019-03-08T08:55:37+00:00",[m
[32m+[m[32m            "type": "library",[m
[32m+[m[32m            "installation-source": "source",[m
[32m+[m[32m            "autoload": {[m
[32m+[m[32m                "files": [[m
[32m+[m[32m                    "src/getallheaders.php"[m
[32m+[m[32m                ][m
[32m+[m[32m            },[m
[32m+[m[32m            "notification-url": "https://packagist.org/downloads/",[m
[32m+[m[32m            "license": [[m
[32m+[m[32m                "MIT"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "authors": [[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Ralph Khattar",[m
[32m+[m[32m                    "email": "ralph.khattar@gmail.com"[m
[32m+[m[32m                }[m
[32m+[m[32m            ],[m
[32m+[m[32m            "description": "A polyfill for getallheaders.",[m
[32m+[m[32m            "support": {[m
[32m+[m[32m                "issues": "https://github.com/ralouphie/getallheaders/issues",[m
[32m+[m[32m                "source": "https://github.com/ralouphie/getallheaders/tree/develop"[m
[32m+[m[32m            },[m
[32m+[m[32m            "install-path": "../ralouphie/getallheaders"[m
[32m+[m[32m        },[m
[32m+[m[32m        {[m
[32m+[m[32m            "name": "symfony/console",[m
[32m+[m[32m            "version": "v7.3.0",[m
[32m+[m[32m            "version_normalized": "7.3.0.0",[m
[32m+[m[32m            "source": {[m
[32m+[m[32m                "type": "git",[m
[32m+[m[32m                "url": "https://github.com/symfony/console.git",[m
[32m+[m[32m                "reference": "66c1440edf6f339fd82ed6c7caa76cb006211b44"[m
[32m+[m[32m            },[m
[32m+[m[32m            "dist": {[m
[32m+[m[32m                "type": "zip",[m
[32m+[m[32m                "url": "https://api.github.com/repos/symfony/console/zipball/66c1440edf6f339fd82ed6c7caa76cb006211b44",[m
[32m+[m[32m                "reference": "66c1440edf6f339fd82ed6c7caa76cb006211b44",[m
[32m+[m[32m                "shasum": ""[m
[32m+[m[32m            },[m
[32m+[m[32m            "require": {[m
[32m+[m[32m                "php": ">=8.2",[m
[32m+[m[32m                "symfony/deprecation-contracts": "^2.5|^3",[m
[32m+[m[32m                "symfony/polyfill-mbstring": "~1.0",[m
[32m+[m[32m                "symfony/service-contracts": "^2.5|^3",[m
[32m+[m[32m                "symfony/string": "^7.2"[m
[32m+[m[32m            },[m
[32m+[m[32m            "conflict": {[m
[32m+[m[32m                "symfony/dependency-injection": "<6.4",[m
[32m+[m[32m                "symfony/dotenv": "<6.4",[m
[32m+[m[32m                "symfony/event-dispatcher": "<6.4",[m
[32m+[m[32m                "symfony/lock": "<6.4",[m
[32m+[m[32m                "symfony/process": "<6.4"[m
[32m+[m[32m            },[m
[32m+[m[32m            "provide": {[m
[32m+[m[32m                "psr/log-implementation": "1.0|2.0|3.0"[m
[32m+[m[32m            },[m
[32m+[m[32m            "require-dev": {[m
[32m+[m[32m                "psr/log": "^1|^2|^3",[m
[32m+[m[32m                "symfony/config": "^6.4|^7.0",[m
[32m+[m[32m                "symfony/dependency-injection": "^6.4|^7.0",[m
[32m+[m[32m                "symfony/event-dispatcher": "^6.4|^7.0",[m
[32m+[m[32m                "symfony/http-foundation": "^6.4|^7.0",[m
[32m+[m[32m                "symfony/http-kernel": "^6.4|^7.0",[m
[32m+[m[32m                "symfony/lock": "^6.4|^7.0",[m
[32m+[m[32m                "symfony/messenger": "^6.4|^7.0",[m
[32m+[m[32m                "symfony/process": "^6.4|^7.0",[m
[32m+[m[32m                "symfony/stopwatch": "^6.4|^7.0",[m
[32m+[m[32m                "symfony/var-dumper": "^6.4|^7.0"[m
[32m+[m[32m            },[m
[32m+[m[32m            "time": "2025-05-24T10:34:04+00:00",[m
[32m+[m[32m            "type": "library",[m
[32m+[m[32m            "installation-source": "source",[m
[32m+[m[32m            "autoload": {[m
[32m+[m[32m                "psr-4": {[m
[32m+[m[32m                    "Symfony\\Component\\Console\\": ""[m
[32m+[m[32m                },[m
[32m+[m[32m                "exclude-from-classmap": [[m
[32m+[m[32m                    "/Tests/"[m
[32m+[m[32m                ][m
[32m+[m[32m            },[m
[32m+[m[32m            "notification-url": "https://packagist.org/downloads/",[m
[32m+[m[32m            "license": [[m
[32m+[m[32m                "MIT"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "authors": [[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Fabien Potencier",[m
[32m+[m[32m                    "email": "fabien@symfony.com"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Symfony Community",[m
[32m+[m[32m                    "homepage": "https://symfony.com/contributors"[m
[32m+[m[32m                }[m
[32m+[m[32m            ],[m
[32m+[m[32m            "description": "Eases the creation of beautiful and testable command line interfaces",[m
[32m+[m[32m            "homepage": "https://symfony.com",[m
[32m+[m[32m            "keywords": [[m
[32m+[m[32m                "cli",[m
[32m+[m[32m                "command-line",[m
[32m+[m[32m                "console",[m
[32m+[m[32m                "terminal"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "support": {[m
[32m+[m[32m                "source": "https://github.com/symfony/console/tree/v7.3.0"[m
[32m+[m[32m            },[m
[32m+[m[32m            "funding": [[m
[32m+[m[32m                {[m
[32m+[m[32m                    "url": "https://symfony.com/sponsor",[m
[32m+[m[32m                    "type": "custom"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "url": "https://github.com/fabpot",[m
[32m+[m[32m                    "type": "github"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "url": "https://tidelift.com/funding/github/packagist/symfony/symfony",[m
[32m+[m[32m                    "type": "tidelift"[m
[32m+[m[32m                }[m
[32m+[m[32m            ],[m
[32m+[m[32m            "install-path": "../symfony/console"[m
[32m+[m[32m        },[m
[32m+[m[32m        {[m
[32m+[m[32m            "name": "symfony/deprecation-contracts",[m
[32m+[m[32m            "version": "v3.6.0",[m
[32m+[m[32m            "version_normalized": "3.6.0.0",[m
[32m+[m[32m            "source": {[m
[32m+[m[32m                "type": "git",[m
[32m+[m[32m                "url": "https://github.com/symfony/deprecation-contracts.git",[m
[32m+[m[32m                "reference": "63afe740e99a13ba87ec199bb07bbdee937a5b62"[m
[32m+[m[32m            },[m
[32m+[m[32m            "dist": {[m
[32m+[m[32m                "type": "zip",[m
[32m+[m[32m                "url": "https://api.github.com/repos/symfony/deprecation-contracts/zipball/63afe740e99a13ba87ec199bb07bbdee937a5b62",[m
[32m+[m[32m                "reference": "63afe740e99a13ba87ec199bb07bbdee937a5b62",[m
[32m+[m[32m                "shasum": ""[m
[32m+[m[32m            },[m
[32m+[m[32m            "require": {[m
[32m+[m[32m                "php": ">=8.1"[m
[32m+[m[32m            },[m
[32m+[m[32m            "time": "2024-09-25T14:21:43+00:00",[m
[32m+[m[32m            "type": "library",[m
[32m+[m[32m            "extra": {[m
[32m+[m[32m                "thanks": {[m
[32m+[m[32m                    "url": "https://github.com/symfony/contracts",[m
[32m+[m[32m                    "name": "symfony/contracts"[m
[32m+[m[32m                },[m
[32m+[m[32m                "branch-alias": {[m
[32m+[m[32m                    "dev-main": "3.6-dev"[m
[32m+[m[32m                }[m
[32m+[m[32m            },[m
[32m+[m[32m            "installation-source": "source",[m
[32m+[m[32m            "autoload": {[m
[32m+[m[32m                "files": [[m
[32m+[m[32m                    "function.php"[m
[32m+[m[32m                ][m
[32m+[m[32m            },[m
[32m+[m[32m            "notification-url": "https://packagist.org/downloads/",[m
[32m+[m[32m            "license": [[m
[32m+[m[32m                "MIT"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "authors": [[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Nicolas Grekas",[m
[32m+[m[32m                    "email": "p@tchwork.com"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Symfony Community",[m
[32m+[m[32m                    "homepage": "https://symfony.com/contributors"[m
[32m+[m[32m                }[m
[32m+[m[32m            ],[m
[32m+[m[32m            "description": "A generic function and convention to trigger deprecation notices",[m
[32m+[m[32m            "homepage": "https://symfony.com",[m
[32m+[m[32m            "support": {[m
[32m+[m[32m                "source": "https://github.com/symfony/deprecation-contracts/tree/v3.6.0"[m
[32m+[m[32m            },[m
[32m+[m[32m            "funding": [[m
[32m+[m[32m                {[m
[32m+[m[32m                    "url": "https://symfony.com/sponsor",[m
[32m+[m[32m                    "type": "custom"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "url": "https://github.com/fabpot",[m
[32m+[m[32m                    "type": "github"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "url": "https://tidelift.com/funding/github/packagist/symfony/symfony",[m
[32m+[m[32m                    "type": "tidelift"[m
[32m+[m[32m                }[m
[32m+[m[32m            ],[m
[32m+[m[32m            "install-path": "../symfony/deprecation-contracts"[m
[32m+[m[32m        },[m
[32m+[m[32m        {[m
[32m+[m[32m            "name": "symfony/polyfill-ctype",[m
[32m+[m[32m            "version": "v1.32.0",[m
[32m+[m[32m            "version_normalized": "1.32.0.0",[m
[32m+[m[32m            "source": {[m
[32m+[m[32m                "type": "git",[m
[32m+[m[32m                "url": "https://github.com/symfony/polyfill-ctype.git",[m
[32m+[m[32m                "reference": "a3cc8b044a6ea513310cbd48ef7333b384945638"[m
[32m+[m[32m            },[m
[32m+[m[32m            "dist": {[m
[32m+[m[32m                "type": "zip",[m
[32m+[m[32m                "url": "https://api.github.com/repos/symfony/polyfill-ctype/zipball/a3cc8b044a6ea513310cbd48ef7333b384945638",[m
[32m+[m[32m                "reference": "a3cc8b044a6ea513310cbd48ef7333b384945638",[m
[32m+[m[32m                "shasum": ""[m
[32m+[m[32m            },[m
[32m+[m[32m            "require": {[m
[32m+[m[32m                "php": ">=7.2"[m
[32m+[m[32m            },[m
[32m+[m[32m            "provide": {[m
[32m+[m[32m                "ext-ctype": "*"[m
[32m+[m[32m            },[m
[32m+[m[32m            "suggest": {[m
[32m+[m[32m                "ext-ctype": "For best performance"[m
[32m+[m[32m            },[m
[32m+[m[32m            "time": "2024-09-09T11:45:10+00:00",[m
[32m+[m[32m            "type": "library",[m
[32m+[m[32m            "extra": {[m
[32m+[m[32m                "thanks": {[m
[32m+[m[32m                    "url": "https://github.com/symfony/polyfill",[m
[32m+[m[32m                    "name": "symfony/polyfill"[m
[32m+[m[32m                }[m
[32m+[m[32m            },[m
[32m+[m[32m            "installation-source": "source",[m
[32m+[m[32m            "autoload": {[m
[32m+[m[32m                "files": [[m
[32m+[m[32m                    "bootstrap.php"[m
[32m+[m[32m                ],[m
[32m+[m[32m                "psr-4": {[m
[32m+[m[32m                    "Symfony\\Polyfill\\Ctype\\": ""[m
[32m+[m[32m                }[m
[32m+[m[32m            },[m
[32m+[m[32m            "notification-url": "https://packagist.org/downloads/",[m
[32m+[m[32m            "license": [[m
[32m+[m[32m                "MIT"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "authors": [[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Gert de Pagter",[m
[32m+[m[32m                    "email": "BackEndTea@gmail.com"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Symfony Community",[m
[32m+[m[32m                    "homepage": "https://symfony.com/contributors"[m
[32m+[m[32m                }[m
[32m+[m[32m            ],[m
[32m+[m[32m            "description": "Symfony polyfill for ctype functions",[m
[32m+[m[32m            "homepage": "https://symfony.com",[m
[32m+[m[32m            "keywords": [[m
[32m+[m[32m                "compatibility",[m
[32m+[m[32m                "ctype",[m
[32m+[m[32m                "polyfill",[m
[32m+[m[32m                "portable"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "support": {[m
[32m+[m[32m                "source": "https://github.com/symfony/polyfill-ctype/tree/v1.32.0"[m
[32m+[m[32m            },[m
[32m+[m[32m            "funding": [[m
[32m+[m[32m                {[m
[32m+[m[32m                    "url": "https://symfony.com/sponsor",[m
[32m+[m[32m                    "type": "custom"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "url": "https://github.com/fabpot",[m
[32m+[m[32m                    "type": "github"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "url": "https://tidelift.com/funding/github/packagist/symfony/symfony",[m
[32m+[m[32m                    "type": "tidelift"[m
[32m+[m[32m                }[m
[32m+[m[32m            ],[m
[32m+[m[32m            "install-path": "../symfony/polyfill-ctype"[m
[32m+[m[32m        },[m
[32m+[m[32m        {[m
[32m+[m[32m            "name": "symfony/polyfill-intl-grapheme",[m
[32m+[m[32m            "version": "v1.32.0",[m
[32m+[m[32m            "version_normalized": "1.32.0.0",[m
[32m+[m[32m            "source": {[m
[32m+[m[32m                "type": "git",[m
[32m+[m[32m                "url": "https://github.com/symfony/polyfill-intl-grapheme.git",[m
[32m+[m[32m                "reference": "b9123926e3b7bc2f98c02ad54f6a4b02b91a8abe"[m
[32m+[m[32m            },[m
[32m+[m[32m            "dist": {[m
[32m+[m[32m                "type": "zip",[m
[32m+[m[32m                "url": "https://api.github.com/repos/symfony/polyfill-intl-grapheme/zipball/b9123926e3b7bc2f98c02ad54f6a4b02b91a8abe",[m
[32m+[m[32m                "reference": "b9123926e3b7bc2f98c02ad54f6a4b02b91a8abe",[m
[32m+[m[32m                "shasum": ""[m
[32m+[m[32m            },[m
[32m+[m[32m            "require": {[m
[32m+[m[32m                "php": ">=7.2"[m
[32m+[m[32m            },[m
[32m+[m[32m            "suggest": {[m
[32m+[m[32m                "ext-intl": "For best performance"[m
[32m+[m[32m            },[m
[32m+[m[32m            "time": "2024-09-09T11:45:10+00:00",[m
[32m+[m[32m            "type": "library",[m
[32m+[m[32m            "extra": {[m
[32m+[m[32m                "thanks": {[m
[32m+[m[32m                    "url": "https://github.com/symfony/polyfill",[m
[32m+[m[32m                    "name": "symfony/polyfill"[m
[32m+[m[32m                }[m
[32m+[m[32m            },[m
[32m+[m[32m            "installation-source": "source",[m
[32m+[m[32m            "autoload": {[m
[32m+[m[32m                "files": [[m
[32m+[m[32m                    "bootstrap.php"[m
[32m+[m[32m                ],[m
[32m+[m[32m                "psr-4": {[m
[32m+[m[32m                    "Symfony\\Polyfill\\Intl\\Grapheme\\": ""[m
[32m+[m[32m                }[m
[32m+[m[32m            },[m
[32m+[m[32m            "notification-url": "https://packagist.org/downloads/",[m
[32m+[m[32m            "license": [[m
[32m+[m[32m                "MIT"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "authors": [[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Nicolas Grekas",[m
[32m+[m[32m                    "email": "p@tchwork.com"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Symfony Community",[m
[32m+[m[32m                    "homepage": "https://symfony.com/contributors"[m
[32m+[m[32m                }[m
[32m+[m[32m            ],[m
[32m+[m[32m            "description": "Symfony polyfill for intl's grapheme_* functions",[m
[32m+[m[32m            "homepage": "https://symfony.com",[m
[32m+[m[32m            "keywords": [[m
[32m+[m[32m                "compatibility",[m
[32m+[m[32m                "grapheme",[m
[32m+[m[32m                "intl",[m
[32m+[m[32m                "polyfill",[m
[32m+[m[32m                "portable",[m
[32m+[m[32m                "shim"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "support": {[m
[32m+[m[32m                "source": "https://github.com/symfony/polyfill-intl-grapheme/tree/v1.32.0"[m
[32m+[m[32m            },[m
[32m+[m[32m            "funding": [[m
[32m+[m[32m                {[m
[32m+[m[32m                    "url": "https://symfony.com/sponsor",[m
[32m+[m[32m                    "type": "custom"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "url": "https://github.com/fabpot",[m
[32m+[m[32m                    "type": "github"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "url": "https://tidelift.com/funding/github/packagist/symfony/symfony",[m
[32m+[m[32m                    "type": "tidelift"[m
[32m+[m[32m                }[m
[32m+[m[32m            ],[m
[32m+[m[32m            "install-path": "../symfony/polyfill-intl-grapheme"[m
[32m+[m[32m        },[m
[32m+[m[32m        {[m
[32m+[m[32m            "name": "symfony/polyfill-intl-normalizer",[m
[32m+[m[32m            "version": "v1.32.0",[m
[32m+[m[32m            "version_normalized": "1.32.0.0",[m
[32m+[m[32m            "source": {[m
[32m+[m[32m                "type": "git",[m
[32m+[m[32m                "url": "https://github.com/symfony/polyfill-intl-normalizer.git",[m
[32m+[m[32m                "reference": "3833d7255cc303546435cb650316bff708a1c75c"[m
[32m+[m[32m            },[m
[32m+[m[32m            "dist": {[m
[32m+[m[32m                "type": "zip",[m
[32m+[m[32m                "url": "https://api.github.com/repos/symfony/polyfill-intl-normalizer/zipball/3833d7255cc303546435cb650316bff708a1c75c",[m
[32m+[m[32m                "reference": "3833d7255cc303546435cb650316bff708a1c75c",[m
[32m+[m[32m                "shasum": ""[m
[32m+[m[32m            },[m
[32m+[m[32m            "require": {[m
[32m+[m[32m                "php": ">=7.2"[m
[32m+[m[32m            },[m
[32m+[m[32m            "suggest": {[m
[32m+[m[32m                "ext-intl": "For best performance"[m
[32m+[m[32m            },[m
[32m+[m[32m            "time": "2024-09-09T11:45:10+00:00",[m
[32m+[m[32m            "type": "library",[m
[32m+[m[32m            "extra": {[m
[32m+[m[32m                "thanks": {[m
[32m+[m[32m                    "url": "https://github.com/symfony/polyfill",[m
[32m+[m[32m                    "name": "symfony/polyfill"[m
[32m+[m[32m                }[m
[32m+[m[32m            },[m
[32m+[m[32m            "installation-source": "source",[m
[32m+[m[32m            "autoload": {[m
[32m+[m[32m                "files": [[m
[32m+[m[32m                    "bootstrap.php"[m
[32m+[m[32m                ],[m
[32m+[m[32m                "psr-4": {[m
[32m+[m[32m                    "Symfony\\Polyfill\\Intl\\Normalizer\\": ""[m
[32m+[m[32m                },[m
[32m+[m[32m                "classmap": [[m
[32m+[m[32m                    "Resources/stubs"[m
[32m+[m[32m                ][m
[32m+[m[32m            },[m
[32m+[m[32m            "notification-url": "https://packagist.org/downloads/",[m
[32m+[m[32m            "license": [[m
[32m+[m[32m                "MIT"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "authors": [[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Nicolas Grekas",[m
[32m+[m[32m                    "email": "p@tchwork.com"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Symfony Community",[m
[32m+[m[32m                    "homepage": "https://symfony.com/contributors"[m
[32m+[m[32m                }[m
[32m+[m[32m            ],[m
[32m+[m[32m            "description": "Symfony polyfill for intl's Normalizer class and related functions",[m
[32m+[m[32m            "homepage": "https://symfony.com",[m
[32m+[m[32m            "keywords": [[m
[32m+[m[32m                "compatibility",[m
[32m+[m[32m                "intl",[m
[32m+[m[32m                "normalizer",[m
[32m+[m[32m                "polyfill",[m
[32m+[m[32m                "portable",[m
[32m+[m[32m                "shim"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "support": {[m
[32m+[m[32m                "source": "https://github.com/symfony/polyfill-intl-normalizer/tree/v1.32.0"[m
[32m+[m[32m            },[m
[32m+[m[32m            "funding": [[m
[32m+[m[32m                {[m
[32m+[m[32m                    "url": "https://symfony.com/sponsor",[m
[32m+[m[32m                    "type": "custom"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "url": "https://github.com/fabpot",[m
[32m+[m[32m                    "type": "github"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "url": "https://tidelift.com/funding/github/packagist/symfony/symfony",[m
[32m+[m[32m                    "type": "tidelift"[m
[32m+[m[32m                }[m
[32m+[m[32m            ],[m
[32m+[m[32m            "install-path": "../symfony/polyfill-intl-normalizer"[m
[32m+[m[32m        },[m
[32m+[m[32m        {[m
[32m+[m[32m            "name": "symfony/polyfill-mbstring",[m
[32m+[m[32m            "version": "v1.32.0",[m
[32m+[m[32m            "version_normalized": "1.32.0.0",[m
[32m+[m[32m            "source": {[m
[32m+[m[32m                "type": "git",[m
[32m+[m[32m                "url": "https://github.com/symfony/polyfill-mbstring.git",[m
[32m+[m[32m                "reference": "6d857f4d76bd4b343eac26d6b539585d2bc56493"[m
[32m+[m[32m            },[m
[32m+[m[32m            "dist": {[m
[32m+[m[32m                "type": "zip",[m
[32m+[m[32m                "url": "https://api.github.com/repos/symfony/polyfill-mbstring/zipball/6d857f4d76bd4b343eac26d6b539585d2bc56493",[m
[32m+[m[32m                "reference": "6d857f4d76bd4b343eac26d6b539585d2bc56493",[m
[32m+[m[32m                "shasum": ""[m
[32m+[m[32m            },[m
[32m+[m[32m            "require": {[m
[32m+[m[32m                "ext-iconv": "*",[m
[32m+[m[32m                "php": ">=7.2"[m
[32m+[m[32m            },[m
[32m+[m[32m            "provide": {[m
[32m+[m[32m                "ext-mbstring": "*"[m
[32m+[m[32m            },[m
[32m+[m[32m            "suggest": {[m
[32m+[m[32m                "ext-mbstring": "For best performance"[m
[32m+[m[32m            },[m
[32m+[m[32m            "time": "2024-12-23T08:48:59+00:00",[m
[32m+[m[32m            "type": "library",[m
[32m+[m[32m            "extra": {[m
[32m+[m[32m                "thanks": {[m
[32m+[m[32m                    "url": "https://github.com/symfony/polyfill",[m
[32m+[m[32m                    "name": "symfony/polyfill"[m
[32m+[m[32m                }[m
[32m+[m[32m            },[m
[32m+[m[32m            "installation-source": "source",[m
[32m+[m[32m            "autoload": {[m
[32m+[m[32m                "files": [[m
[32m+[m[32m                    "bootstrap.php"[m
[32m+[m[32m                ],[m
[32m+[m[32m                "psr-4": {[m
[32m+[m[32m                    "Symfony\\Polyfill\\Mbstring\\": ""[m
[32m+[m[32m                }[m
[32m+[m[32m            },[m
[32m+[m[32m            "notification-url": "https://packagist.org/downloads/",[m
[32m+[m[32m            "license": [[m
[32m+[m[32m                "MIT"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "authors": [[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Nicolas Grekas",[m
[32m+[m[32m                    "email": "p@tchwork.com"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Symfony Community",[m
[32m+[m[32m                    "homepage": "https://symfony.com/contributors"[m
[32m+[m[32m                }[m
[32m+[m[32m            ],[m
[32m+[m[32m            "description": "Symfony polyfill for the Mbstring extension",[m
[32m+[m[32m            "homepage": "https://symfony.com",[m
[32m+[m[32m            "keywords": [[m
[32m+[m[32m                "compatibility",[m
[32m+[m[32m                "mbstring",[m
[32m+[m[32m                "polyfill",[m
[32m+[m[32m                "portable",[m
[32m+[m[32m                "shim"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "support": {[m
[32m+[m[32m                "source": "https://github.com/symfony/polyfill-mbstring/tree/v1.32.0"[m
[32m+[m[32m            },[m
[32m+[m[32m            "funding": [[m
[32m+[m[32m                {[m
[32m+[m[32m                    "url": "https://symfony.com/sponsor",[m
[32m+[m[32m                    "type": "custom"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "url": "https://github.com/fabpot",[m
[32m+[m[32m                    "type": "github"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "url": "https://tidelift.com/funding/github/packagist/symfony/symfony",[m
[32m+[m[32m                    "type": "tidelift"[m
[32m+[m[32m                }[m
[32m+[m[32m            ],[m
[32m+[m[32m            "install-path": "../symfony/polyfill-mbstring"[m
[32m+[m[32m        },[m
[32m+[m[32m        {[m
[32m+[m[32m            "name": "symfony/service-contracts",[m
[32m+[m[32m            "version": "v3.6.0",[m
[32m+[m[32m            "version_normalized": "3.6.0.0",[m
[32m+[m[32m            "source": {[m
[32m+[m[32m                "type": "git",[m
[32m+[m[32m                "url": "https://github.com/symfony/service-contracts.git",[m
[32m+[m[32m                "reference": "f021b05a130d35510bd6b25fe9053c2a8a15d5d4"[m
[32m+[m[32m            },[m
[32m+[m[32m            "dist": {[m
[32m+[m[32m                "type": "zip",[m
[32m+[m[32m                "url": "https://api.github.com/repos/symfony/service-contracts/zipball/f021b05a130d35510bd6b25fe9053c2a8a15d5d4",[m
[32m+[m[32m                "reference": "f021b05a130d35510bd6b25fe9053c2a8a15d5d4",[m
[32m+[m[32m                "shasum": ""[m
[32m+[m[32m            },[m
[32m+[m[32m            "require": {[m
[32m+[m[32m                "php": ">=8.1",[m
[32m+[m[32m                "psr/container": "^1.1|^2.0",[m
[32m+[m[32m                "symfony/deprecation-contracts": "^2.5|^3"[m
[32m+[m[32m            },[m
[32m+[m[32m            "conflict": {[m
[32m+[m[32m                "ext-psr": "<1.1|>=2"[m
[32m+[m[32m            },[m
[32m+[m[32m            "time": "2025-04-25T09:37:31+00:00",[m
[32m+[m[32m            "type": "library",[m
[32m+[m[32m            "extra": {[m
[32m+[m[32m                "thanks": {[m
[32m+[m[32m                    "url": "https://github.com/symfony/contracts",[m
[32m+[m[32m                    "name": "symfony/contracts"[m
[32m+[m[32m                },[m
[32m+[m[32m                "branch-alias": {[m
[32m+[m[32m                    "dev-main": "3.6-dev"[m
[32m+[m[32m                }[m
[32m+[m[32m            },[m
[32m+[m[32m            "installation-source": "source",[m
[32m+[m[32m            "autoload": {[m
[32m+[m[32m                "psr-4": {[m
[32m+[m[32m                    "Symfony\\Contracts\\Service\\": ""[m
[32m+[m[32m                },[m
[32m+[m[32m                "exclude-from-classmap": [[m
[32m+[m[32m                    "/Test/"[m
[32m+[m[32m                ][m
[32m+[m[32m            },[m
[32m+[m[32m            "notification-url": "https://packagist.org/downloads/",[m
[32m+[m[32m            "license": [[m
[32m+[m[32m                "MIT"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "authors": [[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Nicolas Grekas",[m
[32m+[m[32m                    "email": "p@tchwork.com"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Symfony Community",[m
[32m+[m[32m                    "homepage": "https://symfony.com/contributors"[m
[32m+[m[32m                }[m
[32m+[m[32m            ],[m
[32m+[m[32m            "description": "Generic abstractions related to writing services",[m
[32m+[m[32m            "homepage": "https://symfony.com",[m
[32m+[m[32m            "keywords": [[m
[32m+[m[32m                "abstractions",[m
[32m+[m[32m                "contracts",[m
[32m+[m[32m                "decoupling",[m
[32m+[m[32m                "interfaces",[m
[32m+[m[32m                "interoperability",[m
[32m+[m[32m                "standards"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "support": {[m
[32m+[m[32m                "source": "https://github.com/symfony/service-contracts/tree/v3.6.0"[m
[32m+[m[32m            },[m
[32m+[m[32m            "funding": [[m
[32m+[m[32m                {[m
[32m+[m[32m                    "url": "https://symfony.com/sponsor",[m
[32m+[m[32m                    "type": "custom"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "url": "https://github.com/fabpot",[m
[32m+[m[32m                    "type": "github"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "url": "https://tidelift.com/funding/github/packagist/symfony/symfony",[m
[32m+[m[32m                    "type": "tidelift"[m
[32m+[m[32m                }[m
[32m+[m[32m            ],[m
[32m+[m[32m            "install-path": "../symfony/service-contracts"[m
[32m+[m[32m        },[m
[32m+[m[32m        {[m
[32m+[m[32m            "name": "symfony/string",[m
[32m+[m[32m            "version": "v7.3.0",[m
[32m+[m[32m            "version_normalized": "7.3.0.0",[m
[32m+[m[32m            "source": {[m
[32m+[m[32m                "type": "git",[m
[32m+[m[32m                "url": "https://github.com/symfony/string.git",[m
[32m+[m[32m                "reference": "f3570b8c61ca887a9e2938e85cb6458515d2b125"[m
[32m+[m[32m            },[m
[32m+[m[32m            "dist": {[m
[32m+[m[32m                "type": "zip",[m
[32m+[m[32m                "url": "https://api.github.com/repos/symfony/string/zipball/f3570b8c61ca887a9e2938e85cb6458515d2b125",[m
[32m+[m[32m                "reference": "f3570b8c61ca887a9e2938e85cb6458515d2b125",[m
[32m+[m[32m                "shasum": ""[m
[32m+[m[32m            },[m
[32m+[m[32m            "require": {[m
[32m+[m[32m                "php": ">=8.2",[m
[32m+[m[32m                "symfony/polyfill-ctype": "~1.8",[m
[32m+[m[32m                "symfony/polyfill-intl-grapheme": "~1.0",[m
[32m+[m[32m                "symfony/polyfill-intl-normalizer": "~1.0",[m
[32m+[m[32m                "symfony/polyfill-mbstring": "~1.0"[m
[32m+[m[32m            },[m
[32m+[m[32m            "conflict": {[m
[32m+[m[32m                "symfony/translation-contracts": "<2.5"[m
[32m+[m[32m            },[m
[32m+[m[32m            "require-dev": {[m
[32m+[m[32m                "symfony/emoji": "^7.1",[m
[32m+[m[32m                "symfony/error-handler": "^6.4|^7.0",[m
[32m+[m[32m                "symfony/http-client": "^6.4|^7.0",[m
[32m+[m[32m                "symfony/intl": "^6.4|^7.0",[m
[32m+[m[32m                "symfony/translation-contracts": "^2.5|^3.0",[m
[32m+[m[32m                "symfony/var-exporter": "^6.4|^7.0"[m
[32m+[m[32m            },[m
[32m+[m[32m            "time": "2025-04-20T20:19:01+00:00",[m
[32m+[m[32m            "type": "library",[m
[32m+[m[32m            "installation-source": "source",[m
[32m+[m[32m            "autoload": {[m
[32m+[m[32m                "files": [[m
[32m+[m[32m                    "Resources/functions.php"[m
[32m+[m[32m                ],[m
[32m+[m[32m                "psr-4": {[m
[32m+[m[32m                    "Symfony\\Component\\String\\": ""[m
[32m+[m[32m                },[m
[32m+[m[32m                "exclude-from-classmap": [[m
[32m+[m[32m                    "/Tests/"[m
[32m+[m[32m                ][m
[32m+[m[32m            },[m
[32m+[m[32m            "notification-url": "https://packagist.org/downloads/",[m
[32m+[m[32m            "license": [[m
[32m+[m[32m                "MIT"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "authors": [[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Nicolas Grekas",[m
[32m+[m[32m                    "email": "p@tchwork.com"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Symfony Community",[m
[32m+[m[32m                    "homepage": "https://symfony.com/contributors"[m
[32m+[m[32m                }[m
[32m+[m[32m            ],[m
[32m+[m[32m            "description": "Provides an object-oriented API to strings and deals with bytes, UTF-8 code points and grapheme clusters in a unified way",[m
[32m+[m[32m            "homepage": "https://symfony.com",[m
[32m+[m[32m            "keywords": [[m
[32m+[m[32m                "grapheme",[m
[32m+[m[32m                "i18n",[m
[32m+[m[32m                "string",[m
[32m+[m[32m                "unicode",[m
[32m+[m[32m                "utf-8",[m
[32m+[m[32m                "utf8"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "support": {[m
[32m+[m[32m                "source": "https://github.com/symfony/string/tree/v7.3.0"[m
[32m+[m[32m            },[m
[32m+[m[32m            "funding": [[m
[32m+[m[32m                {[m
[32m+[m[32m                    "url": "https://symfony.com/sponsor",[m
[32m+[m[32m                    "type": "custom"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "url": "https://github.com/fabpot",[m
[32m+[m[32m                    "type": "github"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "url": "https://tidelift.com/funding/github/packagist/symfony/symfony",[m
[32m+[m[32m                    "type": "tidelift"[m
[32m+[m[32m                }[m
[32m+[m[32m            ],[m
[32m+[m[32m            "install-path": "../symfony/string"[m
[32m+[m[32m        },[m
[32m+[m[32m        {[m
[32m+[m[32m            "name": "symfony/var-dumper",[m
[32m+[m[32m            "version": "v7.3.0",[m
[32m+[m[32m            "version_normalized": "7.3.0.0",[m
[32m+[m[32m            "source": {[m
[32m+[m[32m                "type": "git",[m
[32m+[m[32m                "url": "https://github.com/symfony/var-dumper.git",[m
[32m+[m[32m                "reference": "548f6760c54197b1084e1e5c71f6d9d523f2f78e"[m
[32m+[m[32m            },[m
[32m+[m[32m            "dist": {[m
[32m+[m[32m                "type": "zip",[m
[32m+[m[32m                "url": "https://api.github.com/repos/symfony/var-dumper/zipball/548f6760c54197b1084e1e5c71f6d9d523f2f78e",[m
[32m+[m[32m                "reference": "548f6760c54197b1084e1e5c71f6d9d523f2f78e",[m
[32m+[m[32m                "shasum": ""[m
[32m+[m[32m            },[m
[32m+[m[32m            "require": {[m
[32m+[m[32m                "php": ">=8.2",[m
[32m+[m[32m                "symfony/deprecation-contracts": "^2.5|^3",[m
[32m+[m[32m                "symfony/polyfill-mbstring": "~1.0"[m
[32m+[m[32m            },[m
[32m+[m[32m            "conflict": {[m
[32m+[m[32m                "symfony/console": "<6.4"[m
[32m+[m[32m            },[m
[32m+[m[32m            "require-dev": {[m
[32m+[m[32m                "ext-iconv": "*",[m
[32m+[m[32m                "symfony/console": "^6.4|^7.0",[m
[32m+[m[32m                "symfony/http-kernel": "^6.4|^7.0",[m
[32m+[m[32m                "symfony/process": "^6.4|^7.0",[m
[32m+[m[32m                "symfony/uid": "^6.4|^7.0",[m
[32m+[m[32m                "twig/twig": "^3.12"[m
[32m+[m[32m            },[m
[32m+[m[32m            "time": "2025-04-27T18:39:23+00:00",[m
[32m+[m[32m            "bin": [[m
[32m+[m[32m                "Resources/bin/var-dump-server"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "type": "library",[m
[32m+[m[32m            "installation-source": "source",[m
[32m+[m[32m            "autoload": {[m
[32m+[m[32m                "files": [[m
[32m+[m[32m                    "Resources/functions/dump.php"[m
[32m+[m[32m                ],[m
[32m+[m[32m                "psr-4": {[m
[32m+[m[32m                    "Symfony\\Component\\VarDumper\\": ""[m
[32m+[m[32m                },[m
[32m+[m[32m                "exclude-from-classmap": [[m
[32m+[m[32m                    "/Tests/"[m
[32m+[m[32m                ][m
[32m+[m[32m            },[m
[32m+[m[32m            "notification-url": "https://packagist.org/downloads/",[m
[32m+[m[32m            "license": [[m
[32m+[m[32m                "MIT"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "authors": [[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Nicolas Grekas",[m
[32m+[m[32m                    "email": "p@tchwork.com"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Symfony Community",[m
[32m+[m[32m                    "homepage": "https://symfony.com/contributors"[m
[32m+[m[32m                }[m
[32m+[m[32m            ],[m
[32m+[m[32m            "description": "Provides mechanisms for walking through any arbitrary PHP variable",[m
[32m+[m[32m            "homepage": "https://symfony.com",[m
[32m+[m[32m            "keywords": [[m
[32m+[m[32m                "debug",[m
[32m+[m[32m                "dump"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "support": {[m
[32m+[m[32m                "source": "https://github.com/symfony/var-dumper/tree/v7.3.0"[m
[32m+[m[32m            },[m
[32m+[m[32m            "funding": [[m
[32m+[m[32m                {[m
[32m+[m[32m                    "url": "https://symfony.com/sponsor",[m
[32m+[m[32m                    "type": "custom"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "url": "https://github.com/fabpot",[m
[32m+[m[32m                    "type": "github"[m
[32m+[m[32m                },[m
[32m+[m[32m                {[m
[32m+[m[32m                    "url": "https://tidelift.com/funding/github/packagist/symfony/symfony",[m
[32m+[m[32m                    "type": "tidelift"[m
[32m+[m[32m                }[m
[32m+[m[32m            ],[m
[32m+[m[32m            "install-path": "../symfony/var-dumper"[m
[32m+[m[32m        },[m
[32m+[m[32m        {[m
[32m+[m[32m            "name": "tecnickcom/tcpdf",[m
[32m+[m[32m            "version": "6.10.0",[m
[32m+[m[32m            "version_normalized": "6.10.0.0",[m
[32m+[m[32m            "source": {[m
[32m+[m[32m                "type": "git",[m
[32m+[m[32m                "url": "https://github.com/tecnickcom/TCPDF.git",[m
[32m+[m[32m                "reference": "ca5b6de294512145db96bcbc94e61696599c391d"[m
[32m+[m[32m            },[m
[32m+[m[32m            "dist": {[m
[32m+[m[32m                "type": "zip",[m
[32m+[m[32m                "url": "https://api.github.com/repos/tecnickcom/TCPDF/zipball/ca5b6de294512145db96bcbc94e61696599c391d",[m
[32m+[m[32m                "reference": "ca5b6de294512145db96bcbc94e61696599c391d",[m
[32m+[m[32m                "shasum": ""[m
[32m+[m[32m            },[m
[32m+[m[32m            "require": {[m
[32m+[m[32m                "ext-curl": "*",[m
[32m+[m[32m                "php": ">=7.1.0"[m
[32m+[m[32m            },[m
[32m+[m[32m            "time": "2025-05-27T18:02:28+00:00",[m
[32m+[m[32m            "type": "library",[m
[32m+[m[32m            "installation-source": "source",[m
[32m+[m[32m            "autoload": {[m
[32m+[m[32m                "classmap": [[m
[32m+[m[32m                    "config",[m
[32m+[m[32m                    "include",[m
[32m+[m[32m                    "tcpdf.php",[m
[32m+[m[32m                    "tcpdf_barcodes_1d.php",[m
[32m+[m[32m                    "tcpdf_barcodes_2d.php",[m
[32m+[m[32m                    "include/tcpdf_colors.php",[m
[32m+[m[32m                    "include/tcpdf_filters.php",[m
[32m+[m[32m                    "include/tcpdf_font_data.php",[m
[32m+[m[32m                    "include/tcpdf_fonts.php",[m
[32m+[m[32m                    "include/tcpdf_images.php",[m
[32m+[m[32m                    "include/tcpdf_static.php",[m
[32m+[m[32m                    "include/barcodes/datamatrix.php",[m
[32m+[m[32m                    "include/barcodes/pdf417.php",[m
[32m+[m[32m                    "include/barcodes/qrcode.php"[m
[32m+[m[32m                ][m
[32m+[m[32m            },[m
[32m+[m[32m            "notification-url": "https://packagist.org/downloads/",[m
[32m+[m[32m            "license": [[m
[32m+[m[32m                "LGPL-3.0-or-later"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "authors": [[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Nicola Asuni",[m
[32m+[m[32m                    "email": "info@tecnick.com",[m
[32m+[m[32m                    "role": "lead"[m
[32m+[m[32m                }[m
[32m+[m[32m            ],[m
[32m+[m[32m            "description": "TCPDF is a PHP class for generating PDF documents and barcodes.",[m
[32m+[m[32m            "homepage": "http://www.tcpdf.org/",[m
[32m+[m[32m            "keywords": [[m
[32m+[m[32m                "PDFD32000-2008",[m
[32m+[m[32m                "TCPDF",[m
[32m+[m[32m                "barcodes",[m
[32m+[m[32m                "datamatrix",[m
[32m+[m[32m                "pdf",[m
[32m+[m[32m                "pdf417",[m
[32m+[m[32m                "qrcode"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "support": {[m
[32m+[m[32m                "issues": "https://github.com/tecnickcom/TCPDF/issues",[m
[32m+[m[32m                "source": "https://github.com/tecnickcom/TCPDF/tree/6.10.0"[m
[32m+[m[32m            },[m
[32m+[m[32m            "funding": [[m
[32m+[m[32m                {[m
[32m+[m[32m                    "url": "https://www.paypal.com/donate/?hosted_button_id=NZUEC5XS8MFBJ",[m
[32m+[m[32m                    "type": "custom"[m
[32m+[m[32m                }[m
[32m+[m[32m            ],[m
[32m+[m[32m            "install-path": "../tecnickcom/tcpdf"[m
[32m+[m[32m        },[m
[32m+[m[32m        {[m
[32m+[m[32m            "name": "thenetworg/oauth2-azure",[m
[32m+[m[32m            "version": "v2.2.2",[m
[32m+[m[32m            "version_normalized": "2.2.2.0",[m
[32m+[m[32m            "source": {[m
[32m+[m[32m                "type": "git",[m
[32m+[m[32m                "url": "https://github.com/TheNetworg/oauth2-azure.git",[m
[32m+[m[32m                "reference": "be204a5135f016470a9c33e82ab48785bbc11af2"[m
[32m+[m[32m            },[m
[32m+[m[32m            "dist": {[m
[32m+[m[32m                "type": "zip",[m
[32m+[m[32m                "url": "https://api.github.com/repos/TheNetworg/oauth2-azure/zipball/be204a5135f016470a9c33e82ab48785bbc11af2",[m
[32m+[m[32m                "reference": "be204a5135f016470a9c33e82ab48785bbc11af2",[m
[32m+[m[32m                "shasum": ""[m
[32m+[m[32m            },[m
[32m+[m[32m            "require": {[m
[32m+[m[32m                "ext-json": "*",[m
[32m+[m[32m                "ext-openssl": "*",[m
[32m+[m[32m                "firebase/php-jwt": "~3.0||~4.0||~5.0||~6.0",[m
[32m+[m[32m                "league/oauth2-client": "~2.0",[m
[32m+[m[32m                "php": "^7.1|^8.0"[m
[32m+[m[32m            },[m
[32m+[m[32m            "require-dev": {[m
[32m+[m[32m                "phpunit/phpunit": "^9.6"[m
[32m+[m[32m            },[m
[32m+[m[32m            "time": "2023-12-19T12:10:48+00:00",[m
[32m+[m[32m            "type": "library",[m
[32m+[m[32m            "installation-source": "source",[m
[32m+[m[32m            "autoload": {[m
[32m+[m[32m                "psr-4": {[m
[32m+[m[32m                    "TheNetworg\\OAuth2\\Client\\": "src/"[m
[32m+[m[32m                }[m
[32m+[m[32m            },[m
[32m+[m[32m            "notification-url": "https://packagist.org/downloads/",[m
[32m+[m[32m            "license": [[m
[32m+[m[32m                "MIT"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "authors": [[m
[32m+[m[32m                {[m
[32m+[m[32m                    "name": "Jan Hajek",[m
[32m+[m[32m                    "email": "jan.hajek@thenetw.org",[m
[32m+[m[32m                    "homepage": "https://thenetw.org"[m
[32m+[m[32m                }[m
[32m+[m[32m            ],[m
[32m+[m[32m            "description": "Azure Active Directory OAuth 2.0 Client Provider for The PHP League OAuth2-Client",[m
[32m+[m[32m            "keywords": [[m
[32m+[m[32m                "SSO",[m
[32m+[m[32m                "aad",[m
[32m+[m[32m                "authorization",[m
[32m+[m[32m                "azure",[m
[32m+[m[32m                "azure active directory",[m
[32m+[m[32m                "client",[m
[32m+[m[32m                "microsoft",[m
[32m+[m[32m                "oauth",[m
[32m+[m[32m                "oauth2",[m
[32m+[m[32m                "windows azure"[m
[32m+[m[32m            ],[m
[32m+[m[32m            "support": {[m
[32m+[m[32m                "issues": "https://github.com/TheNetworg/oauth2-azure/issues",[m
[32m+[m[32m                "source": "https://github.com/TheNetworg/oauth2-azure/tree/v2.2.2"[m
[32m+[m[32m            },[m
[32m+[m[32m            "install-path": "../thenetworg/oauth2-azure"[m
         }[m
     ],[m
     "dev": true,[m
[1mdiff --git a/vendor/composer/installed.php b/vendor/composer/installed.php[m
[1mindex ae6fe64..93e60f1 100644[m
[1m--- a/vendor/composer/installed.php[m
[1m+++ b/vendor/composer/installed.php[m
[36m@@ -1,9 +1,9 @@[m
 <?php return array([m
     'root' => array([m
         'name' => '__root__',[m
[31m-        'pretty_version' => '1.0.0+no-version-set',[m
[31m-        'version' => '1.0.0.0',[m
[31m-        'reference' => null,[m
[32m+[m[32m        'pretty_version' => 'dev-main',[m
[32m+[m[32m        'version' => 'dev-main',[m
[32m+[m[32m        'reference' => '00c477b60e9acf06ec5d7e2032972ba11d035a85',[m
         'type' => 'library',[m
         'install_path' => __DIR__ . '/../../',[m
         'aliases' => array(),[m
[36m@@ -11,22 +11,335 @@[m
     ),[m
     'versions' => array([m
         '__root__' => array([m
[31m-            'pretty_version' => '1.0.0+no-version-set',[m
[31m-            'version' => '1.0.0.0',[m
[31m-            'reference' => null,[m
[32m+[m[32m            'pretty_version' => 'dev-main',[m
[32m+[m[32m            'version' => 'dev-main',[m
[32m+[m[32m            'reference' => '00c477b60e9acf06ec5d7e2032972ba11d035a85',[m
             'type' => 'library',[m
             'install_path' => __DIR__ . '/../../',[m
             'aliases' => array(),[m
             'dev_requirement' => false,[m
         ),[m
[32m+[m[32m        'decomplexity/sendoauth2' => array([m
[32m+[m[32m            'pretty_version' => 'v4.1.0',[m
[32m+[m[32m            'version' => '4.1.0.0',[m
[32m+[m[32m            'reference' => '0ea873dc851f3f96058548cd37879653f2070a87',[m
[32m+[m[32m            'type' => 'library',[m
[32m+[m[32m            'install_path' => __DIR__ . '/../decomplexity/sendoauth2',[m
[32m+[m[32m            'aliases' => array(),[m
[32m+[m[32m            'dev_requirement' => false,[m
[32m+[m[32m        ),[m
[32m+[m[32m        'firebase/php-jwt' => array([m
[32m+[m[32m            'pretty_version' => 'v6.11.1',[m
[32m+[m[32m            'version' => '6.11.1.0',[m
[32m+[m[32m            'reference' => 'd1e91ecf8c598d073d0995afa8cd5c75c6e19e66',[m
[32m+[m[32m            'type' => 'library',[m
[32m+[m[32m            'install_path' => __DIR__ . '/../firebase/php-jwt',[m
[32m+[m[32m            'aliases' => array(),[m
[32m+[m[32m            'dev_requirement' => false,[m
[32m+[m[32m        ),[m
[32m+[m[32m        'google/apiclient' => array([m
[32m+[m[32m            'pretty_version' => 'v2.18.3',[m
[32m+[m[32m            'version' => '2.18.3.0',[m
[32m+[m[32m            'reference' => '4eee42d201eff054428a4836ec132944d271f051',[m
[32m+[m[32m            'type' => 'library',[m
[32m+[m[32m            'install_path' => __DIR__ . '/../google/apiclient',[m
[32m+[m[32m            'aliases' => array(),[m
[32m+[m[32m            'dev_requirement' => false,[m
[32m+[m[32m        ),[m
[32m+[m[32m        'google/apiclient-services' => array([m
[32m+[m[32m            'pretty_version' => 'v0.400.0',[m
[32m+[m[32m            'version' => '0.400.0.0',[m
[32m+[m[32m            'reference' => '8366037e450b62ffc1c5489459f207640acca2b4',[m
[32m+[m[32m            'type' => 'library',[m
[32m+[m[32m            'install_path' => __DIR__ . '/../google/apiclient-services',[m
[32m+[m[32m            'aliases' => array(),[m
[32m+[m[32m            'dev_requirement' => false,[m
[32m+[m[32m        ),[m
[32m+[m[32m        'google/auth' => array([m
[32m+[m[32m            'pretty_version' => 'v1.47.0',[m
[32m+[m[32m            'version' => '1.47.0.0',[m
[32m+[m[32m            'reference' => 'd6389aae7c009daceaa8da9b7942d8df6969f6d9',[m
[32m+[m[32m            'type' => 'library',[m
[32m+[m[32m            'install_path' => __DIR__ . '/../google/auth',[m
[32m+[m[32m            'aliases' => array(),[m
[32m+[m[32m            'dev_requirement' => false,[m
[32m+[m[32m        ),[m
[32m+[m[32m        'guzzlehttp/guzzle' => array([m
[32m+[m[32m            'pretty_version' => '7.9.3',[m
[32m+[m[32m            'version' => '7.9.3.0',[m
[32m+[m[32m            'reference' => '7b2f29fe81dc4da0ca0ea7d42107a0845946ea77',[m
[32m+[m[32m            'type' => 'library',[m
[32m+[m[32m            'install_path' => __DIR__ . '/../guzzlehttp/guzzle',[m
[32m+[m[32m            'aliases' => array(),[m
[32m+[m[32m            'dev_requirement' => false,[m
[32m+[m[32m        ),[m
[32m+[m[32m        'guzzlehttp/promises' => array([m
[32m+[m[32m            'pretty_version' => '2.2.0',[m
[32m+[m[32m            'version' => '2.2.0.0',[m
[32m+[m[32m            'reference' => '7c69f28996b0a6920945dd20b3857e499d9ca96c',[m
[32m+[m[32m            'type' => 'library',[m
[32m+[m[32m            'install_path' => __DIR__ . '/../guzzlehttp/promises',[m
[32m+[m[32m            'aliases' => array(),[m
[32m+[m[32m            'dev_requirement' => false,[m
[32m+[m[32m        ),[m
[32m+[m[32m        'guzzlehttp/psr7' => array([m
[32m+[m[32m            'pretty_version' => '2.7.1',[m
[32m+[m[32m            'version' => '2.7.1.0',[m
[32m+[m[32m            'reference' => 'c2270caaabe631b3b44c85f99e5a04bbb8060d16',[m
[32m+[m[32m            'type' => 'library',[m
[32m+[m[32m            'install_path' => __DIR__ . '/../guzzlehttp/psr7',[m
[32m+[m[32m            'aliases' => array(),[m
[32m+[m[32m            'dev_requirement' => false,[m
[32m+[m[32m        ),[m
[32m+[m[32m        'league/oauth2-client' => array([m
[32m+[m[32m            'pretty_version' => '2.8.1',[m
[32m+[m[32m            'version' => '2.8.1.0',[m
[32m+[m[32m            'reference' => '9df2924ca644736c835fc60466a3a60390d334f9',[m
[32m+[m[32m            'type' => 'library',[m
[32m+[m[32m            'install_path' => __DIR__ . '/../league/oauth2-client',[m
[32m+[m[32m            'aliases' => array(),[m
[32m+[m[32m            'dev_requirement' => false,[m
[32m+[m[32m        ),[m
[32m+[m[32m        'league/oauth2-google' => array([m
[32m+[m[32m            'pretty_version' => '4.0.1',[m
[32m+[m[32m            'version' => '4.0.1.0',[m
[32m+[m[32m            'reference' => '1b01ba18ba31b29e88771e3e0979e5c91d4afe76',[m
[32m+[m[32m            'type' => 'library',[m
[32m+[m[32m            'install_path' => __DIR__ . '/../league/oauth2-google',[m
[32m+[m[32m            'aliases' => array(),[m
[32m+[m[32m            'dev_requirement' => false,[m
[32m+[m[32m        ),[m
[32m+[m[32m        'monolog/monolog' => array([m
[32m+[m[32m            'pretty_version' => '3.9.0',[m
[32m+[m[32m            'version' => '3.9.0.0',[m
[32m+[m[32m            'reference' => '10d85740180ecba7896c87e06a166e0c95a0e3b6',[m
[32m+[m[32m            'type' => 'library',[m
[32m+[m[32m            'install_path' => __DIR__ . '/../monolog/monolog',[m
[32m+[m[32m            'aliases' => array(),[m
[32m+[m[32m            'dev_requirement' => false,[m
[32m+[m[32m        ),[m
[32m+[m[32m        'paragonie/constant_time_encoding' => array([m
[32m+[m[32m            'pretty_version' => 'v3.0.0',[m
[32m+[m[32m            'version' => '3.0.0.0',[m
[32m+[m[32m            'reference' => 'df1e7fde177501eee2037dd159cf04f5f301a512',[m
[32m+[m[32m            'type' => 'library',[m
[32m+[m[32m            'install_path' => __DIR__ . '/../paragonie/constant_time_encoding',[m
[32m+[m[32m            'aliases' => array(),[m
[32m+[m[32m            'dev_requirement' => false,[m
[32m+[m[32m        ),[m
[32m+[m[32m        'paragonie/random_compat' => array([m
[32m+[m[32m            'pretty_version' => 'v9.99.100',[m
[32m+[m[32m            'version' => '9.99.100.0',[m
[32m+[m[32m            'reference' => '996434e5492cb4c3edcb9168db6fbb1359ef965a',[m
[32m+[m[32m            'type' => 'library',[m
[32m+[m[32m            'install_path' => __DIR__ . '/../paragonie/random_compat',[m
[32m+[m[32m            'aliases' => array(),[m
[32m+[m[32m            'dev_requirement' => false,[m
[32m+[m[32m        ),[m
         'phpmailer/phpmailer' => array([m
[31m-            'pretty_version' => 'v6.9.3',[m
[31m-            'version' => '6.9.3.0',[m
[31m-            'reference' => '2f5c94fe7493efc213f643c23b1b1c249d40f47e',[m
[32m+[m[32m            'pretty_version' => 'v6.10.0',[m
[32m+[m[32m            'version' => '6.10.0.0',[m
[32m+[m[32m            'reference' => 'bf74d75a1fde6beaa34a0ddae2ec5fce0f72a144',[m
             'type' => 'library',[m
             'install_path' => __DIR__ . '/../phpmailer/phpmailer',[m
             'aliases' => array(),[m
             'dev_requirement' => false,[m
         ),[m
[32m+[m[32m        'phpseclib/phpseclib' => array([m
[32m+[m[32m            'pretty_version' => '3.0.45',[m
[32m+[m[32m            'version' => '3.0.45.0',[m
[32m+[m[32m            'reference' => 'bd81b90d5963c6b9d87de50357585375223f4dd8',[m
[32m+[m[32m            'type' => 'library',[m
[32m+[m[32m            'install_path' => __DIR__ . '/../phpseclib/phpseclib',[m
[32m+[m[32m            'aliases' => array(),[m
[32m+[m[32m            'dev_requirement' => false,[m
[32m+[m[32m        ),[m
[32m+[m[32m        'psr/cache' => array([m
[32m+[m[32m            'pretty_version' => '3.0.0',[m
[32m+[m[32m            'version' => '3.0.0.0',[m
[32m+[m[32m            'reference' => 'aa5030cfa5405eccfdcb1083ce040c2cb8d253bf',[m
[32m+[m[32m            'type' => 'library',[m
[32m+[m[32m            'install_path' => __DIR__ . '/../psr/cache',[m
[32m+[m[32m            'aliases' => array(),[m
[32m+[m[32m            'dev_requirement' => false,[m
[32m+[m[32m        ),[m
[32m+[m[32m        'psr/container' => array([m
[32m+[m[32m            'pretty_version' => '2.0.2',[m
[32m+[m[32m            'version' => '2.0.2.0',[m
[32m+[m[32m            'reference' => 'c71ecc56dfe541dbd90c5360474fbc405f8d5963',[m
[32m+[m[32m            'type' => 'library',[m
[32m+[m[32m            'install_path' => __DIR__ . '/../psr/container',[m
[32m+[m[32m            'aliases' => array(),[m
[32m+[m[32m            'dev_requirement' => false,[m
[32m+[m[32m        ),[m
[32m+[m[32m        'psr/http-client' => array([m
[32m+[m[32m            'pretty_version' => '1.0.3',[m
[32m+[m[32m            'version' => '1.0.3.0',[m
[32m+[m[32m            'reference' => 'bb5906edc1c324c9a05aa0873d40117941e5fa90',[m
[32m+[m[32m            'type' => 'library',[m
[32m+[m[32m            'install_path' => __DIR__ . '/../psr/http-client',[m
[32m+[m[32m            'aliases' => array(),[m
[32m+[m[32m            'dev_requirement' => false,[m
[32m+[m[32m        ),[m
[32m+[m[32m        'psr/http-client-implementation' => array([m
[32m+[m[32m            'dev_requirement' => false,[m
[32m+[m[32m            'provided' => array([m
[32m+[m[32m                0 => '1.0',[m
[32m+[m[32m            ),[m
[32m+[m[32m        ),[m
[32m+[m[32m        'psr/http-factory' => array([m
[32m+[m[32m            'pretty_version' => '1.1.0',[m
[32m+[m[32m            'version' => '1.1.0.0',[m
[32m+[m[32m            'reference' => '2b4765fddfe3b508ac62f829e852b1501d3f6e8a',[m
[32m+[m[32m            'type' => 'library',[m
[32m+[m[32m            'install_path' => __DIR__ . '/../psr/http-factory',[m
[32m+[m[32m            'aliases' => array(),[m
[32m+[m[32m            'dev_requirement' => false,[m
[32m+[m[32m        ),[m
[32m+[m[32m        'psr/http-factory-implementation' => array([m
[32m+[m[32m            'dev_requirement' => false,[m
[32m+[m[32m            'provided' => array([m
[32m+[m[32m                0 => '1.0',[m
[32m+[m[32m            ),[m
[32m+[m[32m        ),[m
[32m+[m[32m        'psr/http-message' => array([m
[32m+[m[32m            'pretty_version' => '2.0',[m
[32m+[m[32m            'version' => '2.0.0.0',[m
[32m+[m[32m            'reference' => '402d35bcb92c70c026d1a6a9883f06b2ead23d71',[m
[32m+[m[32m            'type' => 'library',[m
[32m+[m[32m            'install_path' => __DIR__ . '/../psr/http-message',[m
[32m+[m[32m            'aliases' => array(),[m
[32m+[m[32m            'dev_requirement' => false,[m
[32m+[m[32m        ),[m
[32m+[m[32m        'psr/http-message-implementation' => array([m
[32m+[m[32m            'dev_requirement' => false,[m
[32m+[m[32m            'provided' => array([m
[32m+[m[32m                0 => '1.0',[m
[32m+[m[32m            ),[m
[32m+[m[32m        ),[m
[32m+[m[32m        'psr/log' => array([m
[32m+[m[32m            'pretty_version' => '3.0.2',[m
[32m+[m[32m            'version' => '3.0.2.0',[m
[32m+[m[32m            'reference' => 'f16e1d5863e37f8d8c2a01719f5b34baa2b714d3',[m
[32m+[m[32m            'type' => 'library',[m
[32m+[m[32m            'install_path' => __DIR__ . '/../psr/log',[m
[32m+[m[32m            'aliases' => array(),[m
[32m+[m[32m            'dev_requirement' => false,[m
[32m+[m[32m        ),[m
[32m+[m[32m        'psr/log-implementation' => array([m
[32m+[m[32m            'dev_requirement' => false,[m
[32m+[m[32m            'provided' => array([m
[32m+[m[32m                0 => '1.0|2.0|3.0',[m
[32m+[m[32m                1 => '3.0.0',[m
[32m+[m[32m            ),[m
[32m+[m[32m        ),[m
[32m+[m[32m        'ralouphie/getallheaders' => array([m
[32m+[m[32m            'pretty_version' => '3.0.3',[m
[32m+[m[32m            'version' => '3.0.3.0',[m
[32m+[m[32m            'reference' => '120b605dfeb996808c31b6477290a714d356e822',[m
[32m+[m[32m            'type' => 'library',[m
[32m+[m[32m            'install_path' => __DIR__ . '/../ralouphie/getallheaders',[m
[32m+[m[32m            'aliases' => array(),[m
[32m+[m[32m            'dev_requirement' => false,[m
[32m+[m[32m        ),[m
[32m+[m[32m        'symfony/console' => array([m
[32m+[m[32m            'pretty_version' => 'v7.3.0',[m
[32m+[m[32m            'version' => '7.3.0.0',[m
[32m+[m[32m            'reference' => '66c1440edf6f339fd82ed6c7caa76cb006211b44',[m
[32m+[m[32m            'type' => 'library',[m
[32m+[m[32m            'install_path' => __DIR__ . '/../symfony/console',[m
[32m+[m[32m            'aliases' => array(),[m
[32m+[m[32m            'dev_requirement' => false,[m
[32m+[m[32m        ),[m
[32m+[m[32m        'symfony/deprecation-contracts' => array([m
[32m+[m[32m            'pretty_version' => 'v3.6.0',[m
[32m+[m[32m            'version' => '3.6.0.0',[m
[32m+[m[32m            'reference' => '63afe740e99a13ba87ec199bb07bbdee937a5b62',[m
[32m+[m[32m            'type' => 'library',[m
[32m+[m[32m            'install_path' => __DIR__ . '/../symfony/deprecation-contracts',[m
[32m+[m[32m            'aliases' => array(),[m
[32m+[m[32m            'dev_requirement' => false,[m
[32m+[m[32m        ),[m
[32m+[m[32m        'symfony/polyfill-ctype' => array([m
[32m+[m[32m            'pretty_version' => 'v1.32.0',[m
[32m+[m[32m            'version' => '1.32.0.0',[m
[32m+[m[32m            'reference' => 'a3cc8b044a6ea513310cbd48ef7333b384945638',[m
[32m+[m[32m            'type' => 'library',[m
[32m+[m[32m            'install_path' => __DIR__ . '/../symfony/polyfill-ctype',[m
[32m+[m[32m            'aliases' => array(),[m
[32m+[m[32m            'dev_requirement' => false,[m
[32m+[m[32m        ),[m
[32m+[m[32m        'symfony/polyfill-intl-grapheme' => array([m
[32m+[m[32m            'pretty_version' => 'v1.32.0',[m
[32m+[m[32m            'version' => '1.32.0.0',[m
[32m+[m[32m            'reference' => 'b9123926e3b7bc2f98c02ad54f6a4b02b91a8abe',[m
[32m+[m[32m            'type' => 'library',[m
[32m+[m[32m            'install_path' => __DIR__ . '/../symfony/polyfill-intl-grapheme',[m
[32m+[m[32m            'aliases' => array(),[m
[32m+[m[32m            'dev_requirement' => false,[m
[32m+[m[32m        ),[m
[32m+[m[32m        'symfony/polyfill-intl-normalizer' => array([m
[32m+[m[32m            'pretty_version' => 'v1.32.0',[m
[32m+[m[32m            'version' => '1.32.0.0',[m
[32m+[m[32m            'reference' => '3833d7255cc303546435cb650316bff708a1c75c',[m
[32m+[m[32m            'type' => 'library',[m
[32m+[m[32m            'install_path' => __DIR__ . '/../symfony/polyfill-intl-normalizer',[m
[32m+[m[32m            'aliases' => array(),[m
[32m+[m[32m            'dev_requirement' => false,[m
[32m+[m[32m        ),[m
[32m+[m[32m        'symfony/polyfill-mbstring' => array([m
[32m+[m[32m            'pretty_version' => 'v1.32.0',[m
[32m+[m[32m            'version' => '1.32.0.0',[m
[32m+[m[32m            'reference' => '6d857f4d76bd4b343eac26d6b539585d2bc56493',[m
[32m+[m[32m            'type' => 'library',[m
[32m+[m[32m            'install_path' => __DIR__ . '/../symfony/polyfill-mbstring',[m
[32m+[m[32m            'aliases' => array(),[m
[32m+[m[32m            'dev_requirement' => false,[m
[32m+[m[32m        ),[m
[32m+[m[32m        'symfony/service-contracts' => array([m
[32m+[m[32m            'pretty_version' => 'v3.6.0',[m
[32m+[m[32m            'version' => '3.6.0.0',[m
[32m+[m[32m            'reference' => 'f021b05a130d35510bd6b25fe9053c2a8a15d5d4',[m
[32m+[m[32m            'type' => 'library',[m
[32m+[m[32m            'install_path' => __DIR__ . '/../symfony/service-contracts',[m
[32m+[m[32m            'aliases' => array(),[m
[32m+[m[32m            'dev_requirement' => false,[m
[32m+[m[32m        ),[m
[32m+[m[32m        'symfony/string' => array([m
[32m+[m[32m            'pretty_version' => 'v7.3.0',[m
[32m+[m[32m            'version' => '7.3.0.0',[m
[32m+[m[32m            'reference' => 'f3570b8c61ca887a9e2938e85cb6458515d2b125',[m
[32m+[m[32m            'type' => 'library',[m
[32m+[m[32m            'install_path' => __DIR__ . '/../symfony/string',[m
[32m+[m[32m            'aliases' => array(),[m
[32m+[m[32m            'dev_requirement' => false,[m
[32m+[m[32m        ),[m
[32m+[m[32m        'symfony/var-dumper' => array([m
[32m+[m[32m            'pretty_version' => 'v7.3.0',[m
[32m+[m[32m            'version' => '7.3.0.0',[m
[32m+[m[32m            'reference' => '548f6760c54197b1084e1e5c71f6d9d523f2f78e',[m
[32m+[m[32m            'type' => 'library',[m
[32m+[m[32m            'install_path' => __DIR__ . '/../symfony/var-dumper',[m
[32m+[m[32m            'aliases' => array(),[m
[32m+[m[32m            'dev_requirement' => false,[m
[32m+[m[32m        ),[m
[32m+[m[32m        'tecnickcom/tcpdf' => array([m
[32m+[m[32m            'pretty_version' => '6.10.0',[m
[32m+[m[32m            'version' => '6.10.0.0',[m
[32m+[m[32m            'reference' => 'ca5b6de294512145db96bcbc94e61696599c391d',[m
[32m+[m[32m            'type' => 'library',[m
[32m+[m[32m            'install_path' => __DIR__ . '/../tecnickcom/tcpdf',[m
[32m+[m[32m            'aliases' => array(),[m
[32m+[m[32m            'dev_requirement' => false,[m
[32m+[m[32m        ),[m
[32m+[m[32m        'thenetworg/oauth2-azure' => array([m
[32m+[m[32m            'pretty_version' => 'v2.2.2',[m
[32m+[m[32m            'version' => '2.2.2.0',[m
[32m+[m[32m            'reference' => 'be204a5135f016470a9c33e82ab48785bbc11af2',[m
[32m+[m[32m            'type' => 'library',[m
[32m+[m[32m            'install_path' => __DIR__ . '/../thenetworg/oauth2-azure',[m
[32m+[m[32m            'aliases' => array(),[m
[32m+[m[32m            'dev_requirement' => false,[m
[32m+[m[32m        ),[m
     ),[m
 );[m
[1mdiff --git a/vendor/composer/platform_check.php b/vendor/composer/platform_check.php[m
[1mindex 454eefd..d32d90c 100644[m
[1m--- a/vendor/composer/platform_check.php[m
[1m+++ b/vendor/composer/platform_check.php[m
[36m@@ -4,8 +4,8 @@[m
 [m
 $issues = array();[m
 [m
[31m-if (!(PHP_VERSION_ID >= 50500)) {[m
[31m-    $issues[] = 'Your Composer dependencies require a PHP version ">= 5.5.0". You are running ' . PHP_VERSION . '.';[m
[32m+[m[32mif (!(PHP_VERSION_ID >= 80200)) {[m
[32m+[m[32m    $issues[] = 'Your Composer dependencies require a PHP version ">= 8.2.0". You are running ' . PHP_VERSION . '.';[m
 }[m
 [m
 if ($issues) {[m
[1mdiff --git a/vendor/phpmailer/phpmailer/README.md b/vendor/phpmailer/phpmailer/README.md[m
[1mindex 07fe8c8..862a4e1 100644[m
[1m--- a/vendor/phpmailer/phpmailer/README.md[m
[1m+++ b/vendor/phpmailer/phpmailer/README.md[m
[36m@@ -20,25 +20,26 @@[m
 - Multipart/alternative emails for mail clients that do not read HTML email[m
 - Add attachments, including inline[m
 - Support for UTF-8 content and 8bit, base64, binary, and quoted-printable encodings[m
[31m-- SMTP authentication with LOGIN, PLAIN, CRAM-MD5, and XOAUTH2 mechanisms over SMTPS and SMTP+STARTTLS transports[m
[32m+[m[32m- Full UTF-8 support when using servers that support `SMTPUTF8`.[m
[32m+[m[32m- Support for iCal events in multiparts and attachments[m
[32m+[m[32m- SMTP authentication with `LOGIN`, `PLAIN`, `CRAM-MD5`, and `XOAUTH2` mechanisms over SMTPS and SMTP+STARTTLS transports[m
 - Validates email addresses automatically[m
 - Protects against header injection attacks[m
 - Error messages in over 50 languages![m
 - DKIM and S/MIME signing support[m
[31m-- Compatible with PHP 5.5 and later, including PHP 8.2[m
[32m+[m[32m- Compatible with PHP 5.5 and later, including PHP 8.4[m
 - Namespaced to prevent name clashes[m
 - Much more![m
 [m
 ## Why you might need it[m
[31m-Many PHP developers need to send email from their code. The only PHP function that supports this directly is [`mail()`](https://www.php.net/manual/en/function.mail.php). However, it does not provide any assistance for making use of popular features such as encryption, authentication, HTML messages, and attachments.[m
[32m+[m[32mMany PHP developers need to send email from their code. The only PHP function that supports this directly is [`mail()`](https://www.php.net/manual/en/function.mail.php). However, it does not provide any assistance for making use of popular features such as authentication, HTML messages, and attachments.[m
 [m
 Formatting email correctly is surprisingly difficult. There are myriad overlapping (and conflicting) standards, requiring tight adherence to horribly complicated formatting and encoding rules – the vast majority of code that you'll find online that uses the `mail()` function directly is just plain wrong, if not unsafe![m
 [m
 The PHP `mail()` function usually sends via a local mail server, typically fronted by a `sendmail` binary on Linux, BSD, and macOS platforms, however, Windows usually doesn't include a local mail server; PHPMailer's integrated SMTP client allows email sending on all platforms without needing a local mail server. Be aware though, that the `mail()` function should be avoided when possible; it's both faster and [safer](https://exploitbox.io/paper/Pwning-PHP-Mail-Function-For-Fun-And-RCE.html) to use SMTP to localhost.[m
 [m
 *Please* don't be tempted to do it yourself – if you don't use PHPMailer, there are many other excellent libraries that[m
[31m-you should look at before rolling your own. Try [SwiftMailer](https://swiftmailer.symfony.com/)[m
[31m-, [Laminas/Mail](https://docs.laminas.dev/laminas-mail/), [ZetaComponents](https://github.com/zetacomponents/Mail), etc.[m
[32m+[m[32myou should look at before rolling your own. Try [Symfony Mailer](https://symfony.com/doc/current/mailer.html), [Laminas/Mail](https://docs.laminas.dev/laminas-mail/), [ZetaComponents](https://github.com/zetacomponents/Mail), etc.[m
 [m
 ## License[m
 This software is distributed under the [LGPL 2.1](https://www.gnu.org/licenses/old-licenses/lgpl-2.1.html) license, along with the [GPL Cooperation Commitment](https://gplcc.github.io/gplcc/). Please read [LICENSE](https://github.com/PHPMailer/PHPMailer/blob/master/LICENSE) for information on the software availability and distribution.[m
[36m@@ -47,7 +48,7 @@[m [mThis software is distributed under the [LGPL 2.1](https://www.gnu.org/licenses/o[m
 PHPMailer is available on [Packagist](https://packagist.org/packages/phpmailer/phpmailer) (using semantic versioning), and installation via [Composer](https://getcomposer.org) is the recommended way to install PHPMailer. Just add this line to your `composer.json` file:[m
 [m
 ```json[m
[31m-"phpmailer/phpmailer": "^6.9.2"[m
[32m+[m[32m"phpmailer/phpmailer": "^6.10.0"[m
 ```[m
 [m
 or run[m
[36m@@ -74,7 +75,7 @@[m [mrequire 'path/to/PHPMailer/src/PHPMailer.php';[m
 require 'path/to/PHPMailer/src/SMTP.php';[m
 ```[m
 [m
[31m-If you're not using the `SMTP` class explicitly (you're probably not), you don't need a `use` line for the SMTP class. Even if you're not using exceptions, you do still need to load the `Exception` class as it is used internally.[m
[32m+[m[32mIf you're not using the `SMTP` class explicitly (you're probably not), you don't need a `use` line for it. Even if you're not using exceptions, you do still need to load the `Exception` class as it is used internally.[m
 [m
 ## Legacy versions[m
 PHPMailer 5.2 (which is compatible with PHP 5.0 — 7.0) is no longer supported, even for security updates. You will find the latest version of 5.2 in the [5.2-stable branch](https://github.com/PHPMailer/PHPMailer/tree/5.2-stable). If you're using PHP 5.5 or later (which you should be), switch to the 6.x releases.[m
[36m@@ -95,7 +96,7 @@[m [muse PHPMailer\PHPMailer\PHPMailer;[m
 use PHPMailer\PHPMailer\SMTP;[m
 use PHPMailer\PHPMailer\Exception;[m
 [m
[31m-//Load Composer's autoloader[m
[32m+[m[32m//Load Composer's autoloader (created by composer, not included with PHPMailer)[m
 require 'vendor/autoload.php';[m
 [m
 //Create an instance; passing `true` enables exceptions[m
[1mdiff --git a/vendor/phpmailer/phpmailer/VERSION b/vendor/phpmailer/phpmailer/VERSION[m
[1mindex 5f54f91..cf79bf9 100644[m
[1m--- a/vendor/phpmailer/phpmailer/VERSION[m
[1m+++ b/vendor/phpmailer/phpmailer/VERSION[m
[36m@@ -1 +1 @@[m
[31m-6.9.3[m
[32m+[m[32m6.10.0[m
[1mdiff --git a/vendor/phpmailer/phpmailer/language/phpmailer.lang-pt.php b/vendor/phpmailer/phpmailer/language/phpmailer.lang-pt.php[m
[1mindex f1ce946..79a6802 100644[m
[1m--- a/vendor/phpmailer/phpmailer/language/phpmailer.lang-pt.php[m
[1m+++ b/vendor/phpmailer/phpmailer/language/phpmailer.lang-pt.php[m
[36m@@ -3,25 +3,32 @@[m
 /**[m
  * Portuguese (European) PHPMailer language file: refer to English translation for definitive list[m
  * @package PHPMailer[m
[31m- * @author Jonadabe <jonadabe@hotmail.com>[m
[32m+[m[32m * @author João Vieira <mail@joaovieira.eu>[m
  */[m
 [m
[31m-$PHPMAILER_LANG['authenticate']         = 'Erro do SMTP: Não foi possível realizar a autenticação.';[m
[31m-$PHPMAILER_LANG['connect_host']         = 'Erro do SMTP: Não foi possível realizar ligação com o servidor SMTP.';[m
[31m-$PHPMAILER_LANG['data_not_accepted']    = 'Erro do SMTP: Os dados foram rejeitados.';[m
[31m-$PHPMAILER_LANG['empty_message']        = 'A mensagem no e-mail está vazia.';[m
[32m+[m[32m$PHPMAILER_LANG['authenticate']         = 'Erro SMTP: Falha na autenticação.';[m
[32m+[m[32m$PHPMAILER_LANG['buggy_php']            = 'A sua versão do PHP tem um bug que pode causar mensagens corrompidas. Para resolver, utilize o envio por SMTP, desative a opção mail.add_x_header no ficheiro php.ini, mude para MacOS ou Linux, ou atualize o PHP para a versão 7.0.17+ ou 7.1.3+.';[m
[32m+[m[32m$PHPMAILER_LANG['connect_host']         = 'Erro SMTP: Não foi possível ligar ao servidor SMTP.';[m
[32m+[m[32m$PHPMAILER_LANG['data_not_accepted']    = 'Erro SMTP: Dados não aceites.';[m
[32m+[m[32m$PHPMAILER_LANG['empty_message']        = 'A mensagem de e-mail está vazia.';[m
 $PHPMAILER_LANG['encoding']             = 'Codificação desconhecida: ';[m
 $PHPMAILER_LANG['execute']              = 'Não foi possível executar: ';[m
[31m-$PHPMAILER_LANG['file_access']          = 'Não foi possível aceder o ficheiro: ';[m
[31m-$PHPMAILER_LANG['file_open']            = 'Abertura do ficheiro: Não foi possível abrir o ficheiro: ';[m
[31m-$PHPMAILER_LANG['from_failed']          = 'Ocorreram falhas nos endereços dos seguintes remententes: ';[m
[31m-$PHPMAILER_LANG['instantiate']          = 'Não foi possível iniciar uma instância da função mail.';[m
[31m-$PHPMAILER_LANG['invalid_address']      = 'Não foi enviado nenhum e-mail para o endereço de e-mail inválido: ';[m
[31m-$PHPMAILER_LANG['mailer_not_supported'] = ' mailer não é suportado.';[m
[31m-$PHPMAILER_LANG['provide_address']      = 'Tem de fornecer pelo menos um endereço como destinatário do e-mail.';[m
[31m-$PHPMAILER_LANG['recipients_failed']    = 'Erro do SMTP: O endereço do seguinte destinatário falhou: ';[m
[32m+[m[32m$PHPMAILER_LANG['extension_missing']    = 'Extensão em falta: ';[m
[32m+[m[32m$PHPMAILER_LANG['file_access']          = 'Não foi possível aceder ao ficheiro: ';[m
[32m+[m[32m$PHPMAILER_LANG['file_open']            = 'Erro ao abrir o ficheiro: ';[m
[32m+[m[32m$PHPMAILER_LANG['from_failed']          = 'O envio falhou para o seguinte endereço do remetente: ';[m
[32m+[m[32m$PHPMAILER_LANG['instantiate']          = 'Não foi possível instanciar a função mail.';[m
[32m+[m[32m$PHPMAILER_LANG['invalid_address']      = 'Endereço de e-mail inválido: ';[m
[32m+[m[32m$PHPMAILER_LANG['invalid_header']       = 'Nome ou valor do cabeçalho inválido.';[m
[32m+[m[32m$PHPMAILER_LANG['invalid_hostentry']    = 'Entrada de host inválida: ';[m
[32m+[m[32m$PHPMAILER_LANG['invalid_host']         = 'Host inválido: ';[m
[32m+[m[32m$PHPMAILER_LANG['mailer_not_supported'] = 'O cliente de e-mail não é suportado.';[m
[32m+[m[32m$PHPMAILER_LANG['provide_address']      = 'Deve fornecer pelo menos um endereço de destinatário.';[m
[32m+[m[32m$PHPMAILER_LANG['recipients_failed']    = 'Erro SMTP: Falha no envio para os seguintes destinatários: ';[m
 $PHPMAILER_LANG['signing']              = 'Erro ao assinar: ';[m
[31m-$PHPMAILER_LANG['smtp_connect_failed']  = 'SMTP Connect() falhou.';[m
[31m-$PHPMAILER_LANG['smtp_error']           = 'Erro de servidor SMTP: ';[m
[32m+[m[32m$PHPMAILER_LANG['smtp_code']            = 'Código SMTP: ';[m
[32m+[m[32m$PHPMAILER_LANG['smtp_code_ex']         = 'Informações adicionais SMTP: ';[m
[32m+[m[32m$PHPMAILER_LANG['smtp_connect_failed']  = 'Falha na função SMTP connect().';[m
[32m+[m[32m$PHPMAILER_LANG['smtp_detail']          = 'Detalhes: ';[m
[32m+[m[32m$PHPMAILER_LANG['smtp_error']           = 'Erro do servidor SMTP: ';[m
 $PHPMAILER_LANG['variable_set']         = 'Não foi possível definir ou redefinir a variável: ';[m
[31m-$PHPMAILER_LANG['extension_missing']    = 'Extensão em falta: ';[m
[1mdiff --git a/vendor/phpmailer/phpmailer/src/PHPMailer.php b/vendor/phpmailer/phpmailer/src/PHPMailer.php[m
[1mindex 4a6077c..2444bcf 100644[m
[1m--- a/vendor/phpmailer/phpmailer/src/PHPMailer.php[m
[1m+++ b/vendor/phpmailer/phpmailer/src/PHPMailer.php[m
[36m@@ -580,6 +580,10 @@[m [mclass PHPMailer[m
      * May be a callable to inject your own validator, but there are several built-in validators.[m
      * The default validator uses PHP's FILTER_VALIDATE_EMAIL filter_var option.[m
      *[m
[32m+[m[32m     * If CharSet is UTF8, the validator is left at the default value,[m
[32m+[m[32m     * and you send to addresses that use non-ASCII local parts, then[m
[32m+[m[32m     * PHPMailer automatically changes to the 'eai' validator.[m
[32m+[m[32m     *[m
      * @see PHPMailer::validateAddress()[m
      *[m
      * @var string|callable[m
[36m@@ -659,6 +663,14 @@[m [mclass PHPMailer[m
      */[m
     protected $ReplyToQueue = [];[m
 [m
[32m+[m[32m    /**[m
[32m+[m[32m     * Whether the need for SMTPUTF8 has been detected. Set by[m
[32m+[m[32m     * preSend() if necessary.[m
[32m+[m[32m     *[m
[32m+[m[32m     * @var bool[m
[32m+[m[32m     */[m
[32m+[m[32m    public $UseSMTPUTF8 = false;[m
[32m+[m
     /**[m
      * The array of attachments.[m
      *[m
[36m@@ -756,7 +768,7 @@[m [mclass PHPMailer[m
      *[m
      * @var string[m
      */[m
[31m-    const VERSION = '6.9.3';[m
[32m+[m[32m    const VERSION = '6.10.0';[m
 [m
     /**[m
      * Error severity: message only, continue processing.[m
[36m@@ -1110,19 +1122,22 @@[m [mclass PHPMailer[m
         $params = [$kind, $address, $name];[m
         //Enqueue addresses with IDN until we know the PHPMailer::$CharSet.[m
         //Domain is assumed to be whatever is after the last @ symbol in the address[m
[31m-        if (static::idnSupported() && $this->has8bitChars(substr($address, ++$pos))) {[m
[31m-            if ('Reply-To' !== $kind) {[m
[31m-                if (!array_key_exists($address, $this->RecipientsQueue)) {[m
[31m-                    $this->RecipientsQueue[$address] = $params;[m
[32m+[m[32m        if ($this->has8bitChars(substr($address, ++$pos))) {[m
[32m+[m[32m            if (static::idnSupported()) {[m
[32m+[m[32m                if ('Reply-To' !== $kind) {[m
[32m+[m[32m                    if (!array_key_exists($address, $this->RecipientsQueue)) {[m
[32m+[m[32m                        $this->RecipientsQueue[$address] = $params;[m
[32m+[m
[32m+[m[32m                        return true;[m
[32m+[m[32m                    }[m
[32m+[m[32m                } elseif (!array_key_exists($address, $this->ReplyToQueue)) {[m
[32m+[m[32m                    $this->ReplyToQueue[$address] = $params;[m
 [m
                     return true;[m
                 }[m
[31m-            } elseif (!array_key_exists($address, $this->ReplyToQueue)) {[m
[31m-                $this->ReplyToQueue[$address] = $params;[m
[31m-[m
[31m-                return true;[m
             }[m
[31m-[m
[32m+[m[32m            //We have an 8-bit domain, but we are missing the necessary extensions to support it[m
[32m+[m[32m            //Or we are already sending to this address[m
             return false;[m
         }[m
 [m
[36m@@ -1160,6 +1175,15 @@[m [mclass PHPMailer[m
      */[m
     protected function addAnAddress($kind, $address, $name = '')[m
     {[m
[32m+[m[32m        if ([m
[32m+[m[32m            self::$validator === 'php' &&[m
[32m+[m[32m            ((bool) preg_match('/[\x80-\xFF]/', $address))[m
[32m+[m[32m        ) {[m
[32m+[m[32m            //The caller has not altered the validator and is sending to an address[m
[32m+[m[32m            //with UTF-8, so assume that they want UTF-8 support instead of failing[m
[32m+[m[32m            $this->CharSet = self::CHARSET_UTF8;[m
[32m+[m[32m            self::$validator = 'eai';[m
[32m+[m[32m        }[m
         if (!in_array($kind, ['to', 'cc', 'bcc', 'Reply-To'])) {[m
             $error_message = sprintf([m
                 '%s: %s',[m
[36m@@ -1362,6 +1386,7 @@[m [mclass PHPMailer[m
      * * `pcre` Use old PCRE implementation;[m
      * * `php` Use PHP built-in FILTER_VALIDATE_EMAIL;[m
      * * `html5` Use the pattern given by the HTML5 spec for 'email' type form input elements.[m
[32m+[m[32m     * * `eai` Use a pattern similar to the HTML5 spec for 'email' and to firefox, extended to support EAI (RFC6530).[m
      * * `noregex` Don't use a regex: super fast, really dumb.[m
      * Alternatively you may pass in a callable to inject your own validator, for example:[m
      *[m
[36m@@ -1432,6 +1457,24 @@[m [mclass PHPMailer[m
                     '[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$/sD',[m
                     $address[m
                 );[m
[32m+[m[32m            case 'eai':[m
[32m+[m[32m                /*[m
[32m+[m[32m                 * This is the pattern used in the HTML5 spec for validation of 'email' type[m
[32m+[m[32m                 * form input elements (as above), modified to accept Unicode email addresses.[m
[32m+[m[32m                 * This is also more lenient than Firefox' html5 spec, in order to make the regex faster.[m
[32m+[m[32m                 * 'eai' is an acronym for Email Address Internationalization.[m
[32m+[m[32m                 * This validator is selected automatically if you attempt to use recipient addresses[m
[32m+[m[32m                 * that contain Unicode characters in the local part.[m
[32m+[m[32m                 *[m
[32m+[m[32m                 * @see https://html.spec.whatwg.org/#e-mail-state-(type=email)[m
[32m+[m[32m                 * @see https://en.wikipedia.org/wiki/International_email[m
[32m+[m[32m                 */[m
[32m+[m[32m                return (bool) preg_match([m
[32m+[m[32m                    '/^[-\p{L}\p{N}\p{M}.!#$%&\'*+\/=?^_`{|}~]+@[\p{L}\p{N}\p{M}](?:[\p{L}\p{N}\p{M}-]{0,61}' .[m
[32m+[m[32m                    '[\p{L}\p{N}\p{M}])?(?:\.[\p{L}\p{N}\p{M}]' .[m
[32m+[m[32m                    '(?:[-\p{L}\p{N}\p{M}]{0,61}[\p{L}\p{N}\p{M}])?)*$/usD',[m
[32m+[m[32m                    $address[m
[32m+[m[32m                );[m
             case 'php':[m
             default:[m
                 return filter_var($address, FILTER_VALIDATE_EMAIL) !== false;[m
[36m@@ -1565,9 +1608,26 @@[m [mclass PHPMailer[m
             $this->error_count = 0; //Reset errors[m
             $this->mailHeader = '';[m
 [m
[32m+[m[32m            //The code below tries to support full use of Unicode,[m
[32m+[m[32m            //while remaining compatible with legacy SMTP servers to[m
[32m+[m[32m            //the greatest degree possible: If the message uses[m
[32m+[m[32m            //Unicode in the local parts of any addresses, it is sent[m
[32m+[m[32m            //using SMTPUTF8. If not, it it sent using[m
[32m+[m[32m            //punycode-encoded domains and plain SMTP.[m
[32m+[m[32m            if ([m
[32m+[m[32m                static::CHARSET_UTF8 === strtolower($this->CharSet) &&[m
[32m+[m[32m                ($this->anyAddressHasUnicodeLocalPart($this->RecipientsQueue) ||[m
[32m+[m[32m                 $this->anyAddressHasUnicodeLocalPart(array_keys($this->all_recipients)) ||[m
[32m+[m[32m                 $this->anyAddressHasUnicodeLocalPart($this->ReplyToQueue) ||[m
[32m+[m[32m                 $this->addressHasUnicodeLocalPart($this->From))[m
[32m+[m[32m            ) {[m
[32m+[m[32m                $this->UseSMTPUTF8 = true;[m
[32m+[m[32m            }[m
             //Dequeue recipient and Reply-To addresses with IDN[m
             foreach (array_merge($this->RecipientsQueue, $this->ReplyToQueue) as $params) {[m
[31m-                $params[1] = $this->punyencodeAddress($params[1]);[m
[32m+[m[32m                if (!$this->UseSMTPUTF8) {[m
[32m+[m[32m                    $params[1] = $this->punyencodeAddress($params[1]);[m
[32m+[m[32m                }[m
                 call_user_func_array([$this, 'addAnAddress'], $params);[m
             }[m
             if (count($this->to) + count($this->cc) + count($this->bcc) < 1) {[m
[36m@@ -2058,6 +2118,11 @@[m [mclass PHPMailer[m
         if (!$this->smtpConnect($this->SMTPOptions)) {[m
             throw new Exception($this->lang('smtp_connect_failed'), self::STOP_CRITICAL);[m
         }[m
[32m+[m[32m        //If we have recipient addresses that need Unicode support,[m
[32m+[m[32m        //but the server doesn't support it, stop here[m
[32m+[m[32m        if ($this->UseSMTPUTF8 && !$this->smtp->getServerExt('SMTPUTF8')) {[m
[32m+[m[32m            throw new Exception($this->lang('no_smtputf8'), self::STOP_CRITICAL);[m
[32m+[m[32m        }[m
         //Sender already validated in preSend()[m
         if ('' === $this->Sender) {[m
             $smtp_from = $this->From;[m
[36m@@ -2159,6 +2224,7 @@[m [mclass PHPMailer[m
         $this->smtp->setDebugLevel($this->SMTPDebug);[m
         $this->smtp->setDebugOutput($this->Debugoutput);[m
         $this->smtp->setVerp($this->do_verp);[m
[32m+[m[32m        $this->smtp->setSMTPUTF8($this->UseSMTPUTF8);[m
         if ($this->Host === null) {[m
             $this->Host = 'localhost';[m
         }[m
[36m@@ -2356,6 +2422,7 @@[m [mclass PHPMailer[m
             'smtp_detail' => 'Detail: ',[m
             'smtp_error' => 'SMTP server error: ',[m
             'variable_set' => 'Cannot set or reset variable: ',[m
[32m+[m[32m            'no_smtputf8' => 'Server does not support SMTPUTF8 needed to send to Unicode addresses',[m
         ];[m
         if (empty($lang_path)) {[m
             //Calculate an absolute path so it can work if CWD is not here[m
[36m@@ -2870,7 +2937,9 @@[m [mclass PHPMailer[m
         $bodyEncoding = $this->Encoding;[m
         $bodyCharSet = $this->CharSet;[m
         //Can we do a 7-bit downgrade?[m
[31m-        if (static::ENCODING_8BIT === $bodyEncoding && !$this->has8bitChars($this->Body)) {[m
[32m+[m[32m        if ($this->UseSMTPUTF8) {[m
[32m+[m[32m            $bodyEncoding = static::ENCODING_8BIT;[m
[32m+[m[32m        } elseif (static::ENCODING_8BIT === $bodyEncoding && !$this->has8bitChars($this->Body)) {[m
             $bodyEncoding = static::ENCODING_7BIT;[m
             //All ISO 8859, Windows codepage and UTF-8 charsets are ascii compatible up to 7-bit[m
             $bodyCharSet = static::CHARSET_ASCII;[m
[36m@@ -3507,7 +3576,8 @@[m [mclass PHPMailer[m
     /**[m
      * Encode a header value (not including its label) optimally.[m
      * Picks shortest of Q, B, or none. Result includes folding if needed.[m
[31m-     * See RFC822 definitions for phrase, comment and text positions.[m
[32m+[m[32m     * See RFC822 definitions for phrase, comment and text positions,[m
[32m+[m[32m     * and RFC2047 for inline encodings.[m
      *[m
      * @param string $str      The header value to encode[m
      * @param string $position What context the string will be used in[m
[36m@@ -3516,6 +3586,11 @@[m [mclass PHPMailer[m
      */[m
     public function encodeHeader($str, $position = 'text')[m
     {[m
[32m+[m[32m        $position = strtolower($position);[m
[32m+[m[32m        if ($this->UseSMTPUTF8 && !("comment" === $position)) {[m
[32m+[m[32m            return trim(static::normalizeBreaks($str));[m
[32m+[m[32m        }[m
[32m+[m
         $matchcount = 0;[m
         switch (strtolower($position)) {[m
             case 'phrase':[m
[36m@@ -4180,7 +4255,7 @@[m [mclass PHPMailer[m
         if ('smtp' === $this->Mailer && null !== $this->smtp) {[m
             $lasterror = $this->smtp->getError();[m
             if (!empty($lasterror['error'])) {[m
[31m-                $msg .= $this->lang('smtp_error') . $lasterror['error'];[m
[32m+[m[32m                $msg .= ' ' . $this->lang('smtp_error') . $lasterror['error'];[m
                 if (!empty($lasterror['detail'])) {[m
                     $msg .= ' ' . $this->lang('smtp_detail') . $lasterror['detail'];[m
                 }[m
[36m@@ -4267,6 +4342,45 @@[m [mclass PHPMailer[m
         return filter_var('https://' . $host, FILTER_VALIDATE_URL) !== false;[m
     }[m
 [m
[32m+[m[32m    /**[m
[32m+[m[32m     * Check whether the supplied address uses Unicode in the local part.[m
[32m+[m[32m     *[m
[32m+[m[32m     * @return bool[m
[32m+[m[32m     */[m
[32m+[m[32m    protected function addressHasUnicodeLocalPart($address)[m
[32m+[m[32m    {[m
[32m+[m[32m        return (bool) preg_match('/[\x80-\xFF].*@/', $address);[m
[32m+[m[32m    }[m
[32m+[m
[32m+[m[32m    /**[m
[32m+[m[32m     * Check whether any of the supplied addresses use Unicode in the local part.[m
[32m+[m[32m     *[m
[32m+[m[32m     * @return bool[m
[32m+[m[32m     */[m
[32m+[m[32m    protected function anyAddressHasUnicodeLocalPart($addresses)[m
[32m+[m[32m    {[m
[32m+[m[32m        foreach ($addresses as $address) {[m
[32m+[m[32m            if (is_array($address)) {[m
[32m+[m[32m                $address = $address[0];[m
[32m+[m[32m            }[m
[32m+[m[32m            if ($this->addressHasUnicodeLocalPart($address)) {[m
[32m+[m[32m                return true;[m
[32m+[m[32m            }[m
[32m+[m[32m        }[m
[32m+[m[32m        return false;[m
[32m+[m[32m    }[m
[32m+[m
[32m+[m[32m    /**[m
[32m+[m[32m     * Check whether the message requires SMTPUTF8 based on what's known so far.[m
[32m+[m[32m     *[m
[32m+[m[32m     * @return bool[m
[32m+[m[32m     */[m
[32m+[m[32m    public function needsSMTPUTF8()[m
[32m+[m[32m    {[m
[32m+[m[32m        return $this->UseSMTPUTF8;[m
[32m+[m[32m    }[m
[32m+[m
[32m+[m
     /**[m
      * Get an error message in the current language.[m
      *[m
[1mdiff --git a/vendor/phpmailer/phpmailer/src/POP3.php b/vendor/phpmailer/phpmailer/src/POP3.php[m
[1mindex 376fae2..1190a1e 100644[m
[1m--- a/vendor/phpmailer/phpmailer/src/POP3.php[m
[1m+++ b/vendor/phpmailer/phpmailer/src/POP3.php[m
[36m@@ -46,7 +46,7 @@[m [mclass POP3[m
      *[m
      * @var string[m
      */[m
[31m-    const VERSION = '6.9.3';[m
[32m+[m[32m    const VERSION = '6.10.0';[m
 [m
     /**[m
      * Default POP3 port number.[m
[1mdiff --git a/vendor/phpmailer/phpmailer/src/SMTP.php b/vendor/phpmailer/phpmailer/src/SMTP.php[m
[1mindex b4eff40..7226ee9 100644[m
[1m--- a/vendor/phpmailer/phpmailer/src/SMTP.php[m
[1m+++ b/vendor/phpmailer/phpmailer/src/SMTP.php[m
[36m@@ -35,7 +35,7 @@[m [mclass SMTP[m
      *[m
      * @var string[m
      */[m
[31m-    const VERSION = '6.9.3';[m
[32m+[m[32m    const VERSION = '6.10.0';[m
 [m
     /**[m
      * SMTP line break constant.[m
[36m@@ -159,6 +159,15 @@[m [mclass SMTP[m
      */[m
     public $do_verp = false;[m
 [m
[32m+[m[32m    /**[m
[32m+[m[32m     * Whether to use SMTPUTF8.[m
[32m+[m[32m     *[m
[32m+[m[32m     * @see https://www.rfc-editor.org/rfc/rfc6531[m
[32m+[m[32m     *[m
[32m+[m[32m     * @var bool[m
[32m+[m[32m     */[m
[32m+[m[32m    public $do_smtputf8 = false;[m
[32m+[m
     /**[m
      * The timeout value for connection, in seconds.[m
      * Default of 5 minutes (300sec) is from RFC2821 section 4.5.3.2.[m
[36m@@ -913,7 +922,15 @@[m [mclass SMTP[m
      * $from. Returns true if successful or false otherwise. If True[m
      * the mail transaction is started and then one or more recipient[m
      * commands may be called followed by a data command.[m
[31m-     * Implements RFC 821: MAIL <SP> FROM:<reverse-path> <CRLF>.[m
[32m+[m[32m     * Implements RFC 821: MAIL <SP> FROM:<reverse-path> <CRLF> and[m
[32m+[m[32m     * two extensions, namely XVERP and SMTPUTF8.[m
[32m+[m[32m     *[m
[32m+[m[32m     * The server's EHLO response is not checked. If use of either[m
[32m+[m[32m     * extensions is enabled even though the server does not support[m
[32m+[m[32m     * that, mail submission will fail.[m
[32m+[m[32m     *[m
[32m+[m[32m     * XVERP is documented at https://www.postfix.org/VERP_README.html[m
[32m+[m[32m     * and SMTPUTF8 is specified in RFC 6531.[m
      *[m
      * @param string $from Source address of this message[m
      *[m
[36m@@ -922,10 +939,11 @@[m [mclass SMTP[m
     public function mail($from)[m
     {[m
         $useVerp = ($this->do_verp ? ' XVERP' : '');[m
[32m+[m[32m        $useSmtputf8 = ($this->do_smtputf8 ? ' SMTPUTF8' : '');[m
 [m
         return $this->sendCommand([m
             'MAIL FROM',[m
[31m-            'MAIL FROM:<' . $from . '>' . $useVerp,[m
[32m+[m[32m            'MAIL FROM:<' . $from . '>' . $useSmtputf8 . $useVerp,[m
             250[m
         );[m
     }[m
[36m@@ -1364,6 +1382,26 @@[m [mclass SMTP[m
         return $this->do_verp;[m
     }[m
 [m
[32m+[m[32m    /**[m
[32m+[m[32m     * Enable or disable use of SMTPUTF8.[m
[32m+[m[32m     *[m
[32m+[m[32m     * @param bool $enabled[m
[32m+[m[32m     */[m
[32m+[m[32m    public function setSMTPUTF8($enabled = false)[m
[32m+[m[32m    {[m
[32m+[m[32m        $this->do_smtputf8 = $enabled;[m
[32m+[m[32m    }[m
[32m+[m
[32m+[m[32m    /**[m
[32m+[m[32m     * Get SMTPUTF8 use.[m
[32m+[m[32m     *[m
[32m+[m[32m     * @return bool[m
[32m+[m[32m     */[m
[32m+[m[32m    public function getSMTPUTF8()[m
[32m+[m[32m    {[m
[32m+[m[32m        return $this->do_smtputf8;[m
[32m+[m[32m    }[m
[32m+[m
     /**[m
      * Set error messages and codes.[m
      *[m
[1mdiff --git a/views/index.php b/views/index.php[m
[1mindex 4a4bfc1..c920ac3 100644[m
[1m--- a/views/index.php[m
[1m+++ b/views/index.php[m
[36m@@ -11,7 +11,7 @@[m
     <meta charset="UTF-8">[m
     <meta name="viewport" content="width=device-width, initial-scale=1.0">[m
     <title>Accueil - Location Maisons</title>[m
[31m-    <link rel="icon" type="image/png" href="https://images.unsplash.com/photo-1507089947368-19c1da9775ae?auto=format&fit=crop&w=60&q=80">[m
[32m+[m[32m    <link rel="icon" type="image/png" href="../images/logo/logos.avif">[m
     <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">[m
     <link href="https://fonts.googleapis.com/css?family=Montserrat:400,700&display=swap" rel="stylesheet">[m
     <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">[m
[36m@@ -231,39 +231,53 @@[m
 [m
     <!-- Modal de recherche -->[m
     <div class="modal fade" id="searchModal" tabindex="-1" aria-labelledby="searchModalLabel" aria-hidden="true">[m
[31m-      <div class="modal-dialog">[m
[32m+[m[32m      <div class="modal-dialog modal-lg modal-dialog-centered">[m
         <div class="modal-content">[m
           <form onsubmit="event.preventDefault(); /* Ajoutez ici votre logique de recherche */">[m
             <div class="modal-header">[m
[31m-              <h5 class="modal-title" id="searchModalLabel">Recherche de maison</h5>[m
               <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Fermer"></button>[m
             </div>[m
[31m-            <div class="modal-body">[m
[31m-              <div class="mb-3">[m
[31m-                <label for="nbChambres" class="form-label">Nombre de chambres</label>[m
[31m-                <input type="number" class="form-control" id="nbChambres" name="nbChambres" min="1" max="10" placeholder="Ex: 3">[m
[31m-              </div>[m
[31m-              <div class="mb-3">[m
[31m-                <label for="qualite" class="form-label">Qualité de la maison</label>[m
[31m-                <select class="form-select" id="qualite" name="qualite">[m
[31m-                  <option value="">Choisir...</option>[m
[31m-                  <option value="standard">Standard</option>[m
[31m-                  <option value="moderne">Moderne</option>[m
[31m-                  <option value="luxe">Luxe</option>[m
[31m-                </select>[m
[31m-              </div>[m
[31m-              <div class="mb-3">[m
[31m-                <label for="ville" class="form-label">Ville</label>[m
[31m-                <input type="text" class="form-control" id="ville" name="ville" placeholder="Ex: Paris">[m
[31m-              </div>[m
[31m-              <div class="mb-3">[m
[31m-                <label for="prixMax" class="form-label">Prix maximum ($)</label>[m
[31m-                <input type="number" class="form-control" id="prixMax" name="prixMax" min="0" step="100" placeholder="Ex: 1500">[m
[31m-              </div>[m
[31m-            </div>[m
[31m-            <div class="modal-footer">[m
[31m-              <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>[m
[31m-              <button type="submit" class="btn btn-primary">Rechercher</button>[m
[32m+[m[32m            <div class="main-section" id="recherche">[m
[32m+[m[32m                <div class="d-flex justify-content-between align-items-center pt-3 pb-2 mb-4 border-bottom">[m
[32m+[m[32m                    <h2 class="h4"><i class="fas fa-search me-2 text-primary"></i>Recherche de maison</h2>[m
[32m+[m[32m                    <button class="btn btn-outline-secondary" onclick="showSection('dashboard')">Retour</button>[m
[32m+[m[32m                </div>[m
[32m+[m[32m                <div class="mb-4">[m
[32m+[m[32m                    <input type="text" class="form-control" id="searchMaisonInput" placeholder="Rechercher par ville, quartier, prix, etc..." onkeyup="showResult(this.value)">[m
[32m+[m[32m                </div>[m
[32m+[m[32m                <div id="search-loader" class="text-center mb-2">[m
[32m+[m[32m                    <div class="spinner-border text-primary" role="status"><span class="visually-hidden">Chargement...</span></div>[m
[32m+[m[32m                </div>[m
[32m+[m[32m                <!-- Résultats AJAX -->[m
[32m+[m[32m                <div class="col-md-12">[m
[32m+[m[32m                    <div id="livesearch">[m
[32m+[m[32m                    </div>[m
[32m+[m[32m                </div>[m
[32m+[m[32m                <!-- Les résultats s'affichent ici -->[m
[32m+[m[32m                <!-- Modal Détails Maison -->[m
[32m+[m[32m                <script>[m
[32m+[m[32m                function showResult(str) {[m
[32m+[m[32m                    var loader = document.getElementById("search-loader");[m
[32m+[m[32m                    if (loader) loader.style.display = "block";[m
[32m+[m[32m                    if (str.length==0) {[m
[32m+[m[32m                        document.getElementById("livesearch").innerHTML="";[m
[32m+[m[32m                        document.getElementById("livesearch").style.border="0px";[m
[32m+[m[32m                        if (loader) loader.style.display = "none";[m
[32m+[m[32m                        return;[m
[32m+[m[32m                    }[m
[32m+[m[32m                    var xmlhttp=new XMLHttpRequest();[m
[32m+[m[32m                    xmlhttp.onreadystatechange=function() {[m
[32m+[m[32m                        if (this.readyState==4 && this.status==200) {[m
[32m+[m[32m                            document.getElementById("livesearch").innerHTML=this.responseText;[m
[32m+[m[32m                            document.getElementById("livesearch").style.border="1px solid #A5ACB2";[m
[32m+[m[32m                            if (loader) loader.style.display = "none";[m
[32m+[m[32m                        }[m
[32m+[m[32m                    }[m
[32m+[m[32m                    xmlhttp.open("GET","../ajax/recherche_maison.php?q="+encodeURIComponent(str),true);[m
[32m+[m[32m                    xmlhttp.send();[m
[32m+[m[32m                }[m
[32m+[m[32m                </script>[m
[32m+[m[41m                [m
             </div>[m
           </form>[m
         </div>[m
