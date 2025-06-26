<?php
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

require_once("../connexion/connexion.php");
require_once("../classe/maison.php");
require_once("../classe/utilisateurs.php");
require_once(__DIR__ . '/../vendor/autoload.php');

class DemandeLocation
{
    private $conn;
    private $table = "demande_location";

    public function __construct()
    {
        $con = new connexion();
        $this->conn = $con->getcon();
    }

    public function ajouterDemande($id_utilisateur, $id_maison)
    {
        $query = "INSERT INTO {$this->table} (date, statut, id_utilisateur, id_maison)
                  VALUES (NOW(), 'en_attente', :id_utilisateur, :id_maison)";
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":id_utilisateur", $id_utilisateur, PDO::PARAM_INT);
        $stmt->bindParam(":id_maison", $id_maison, PDO::PARAM_INT);
        return $stmt->execute();
    }

    public function supprimerDemande($id_demande)
    {
        $query = "DELETE FROM {$this->table} WHERE id_demande = :id_demande";
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":id_demande", $id_demande, PDO::PARAM_INT);
        return $stmt->execute();
    }

    public function getDemandes()
    {
        $query = "SELECT * FROM {$this->table} ORDER BY id_demande DESC";
        $stmt = $this->conn->prepare($query);
        $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    public function getDemande($id_demande)
    {
        $query = "SELECT * FROM {$this->table} WHERE id_demande = :id_demande";
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":id_demande", $id_demande, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }

    public function getDemandesByUtilisateur($id_utilisateur)
    {
        $query = "SELECT * FROM {$this->table} WHERE id_utilisateur = :id_utilisateur ORDER BY id_demande DESC";
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":id_utilisateur", $id_utilisateur, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    public function actionStatut($id_demande, $statut)
    {
        $query = "UPDATE {$this->table} SET statut = :statut WHERE id_demande = :id_demande";
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":statut", $statut, PDO::PARAM_STR);
        $stmt->bindParam(":id_demande", $id_demande, PDO::PARAM_INT);
        return $stmt->execute();
    }

    public function getDemandesByStatut($statut)
    {
        $query = "SELECT * FROM {$this->table} WHERE statut = :statut ORDER BY id_demande DESC";
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":statut", $statut, PDO::PARAM_STR);
        $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    public function getDemandesEnvoyeesAMaMaison($id_utilisateur_maison)
    {
        $query = "SELECT 
                    dl.id_demande,
                    dl.date AS date_demande,
                    dl.statut,
                    u.id AS id_locataire,
                    u.nom AS nom_locataire,
                    u.email AS email_locataire,
                    m.id_maison,
                    m.adresse,
                    m.prix
                  FROM {$this->table} dl
                  INNER JOIN maison m ON dl.id_maison = m.id_maison
                  INNER JOIN utilisateurs u ON dl.id_utilisateur = u.id
                  WHERE m.id_utilisateur = :id_utilisateur_maison
                  ORDER BY dl.id_demande DESC";
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":id_utilisateur_maison", $id_utilisateur_maison, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    public function getNombreDemandesPourMesMaisons($id_utilisateur_maison)
    {
        $query = "SELECT COUNT(*) as total
                  FROM {$this->table} dl
                  INNER JOIN maison m ON dl.id_maison = m.id_maison
                  WHERE m.id_utilisateur = :id_utilisateur_maison";
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":id_utilisateur_maison", $id_utilisateur_maison, PDO::PARAM_INT);
        $stmt->execute();
        $result = $stmt->fetch(PDO::FETCH_ASSOC);
        return $result ? (int)$result['total'] : 0;
    }

    /**
     * Accepte ou refuse une demande de location.
     * Si acceptée, annule les autres demandes et notifie les utilisateurs concernés.
     * Si refusée, notifie le locataire.
     */
    public function traiterDemande($id_demande, $action)
    {
        $demande = $this->getDemande($id_demande);
        if (!$demande) {
            return false;
        }

        $id_maison = $demande['id_maison'];
        $id_locataire = $demande['id_utilisateur'];

        $utilisateur = new Utilisateur();
        $locataire = $utilisateur->getUtilisateur($id_locataire);

        $query = "SELECT dl.id_demande, u.email, u.nom, dl.id_utilisateur
                  FROM {$this->table} dl
                  INNER JOIN utilisateurs u ON dl.id_utilisateur = u.id
                  WHERE dl.id_maison = :id_maison";
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":id_maison", $id_maison, PDO::PARAM_INT);
        $stmt->execute();
        $demandes = $stmt->fetchAll(PDO::FETCH_ASSOC);

        if ($action === 'accepter') {
            $this->actionStatut($id_demande, 'acceptee');

            // Notifier le demandeur accepté
            if ($locataire && !empty($locataire['email'])) {
                $this->envoyerMail(
                    $locataire['email'],
                    $locataire['nom'],
                    "Demande de location acceptée",
                    "Bonjour {$locataire['nom']},\n\nVotre demande de location a été acceptée avec succès. Félicitations !"
                );
            }

            // Annuler les autres demandes et notifier les autres demandeurs
            foreach ($demandes as $d) {
                if ($d['id_demande'] != $id_demande) {
                    $this->actionStatut($d['id_demande'], 'annulee');
                    if (!empty($d['email'])) {
                        $this->envoyerMail(
                            $d['email'],
                            $d['nom'],
                            "Demande de location refusée",
                            "Bonjour {$d['nom']},\n\nVotre demande de location a été refusée car une autre demande a été acceptée."
                        );
                    }
                }
            }

            // Mettre à jour le statut de la maison à "indisponible"
            $maison = new Maison();
            $maison->changerStatut($id_maison, 'indisponible');

        } elseif ($action === 'refuser') {
            $this->actionStatut($id_demande, 'refusee');
            if ($locataire && !empty($locataire['email'])) {
                $this->envoyerMail(
                    $locataire['email'],
                    $locataire['nom'],
                    "Demande de location refusée",
                    "Bonjour {$locataire['nom']},\n\nVotre demande de location a été refusée."
                );
            }
        } else {
            return false;
        }
        return true;
    }

    /**
     * Envoie un email via PHPMailer.
     */
    private function envoyerMail($to, $toName, $subject, $body)
    {
        $mail = new PHPMailer(true);
        try {
            $mail->isSMTP();
            $mail->Host = 'smtp.gmail.com';
            $mail->SMTPAuth = true;
            $mail->Username = 'nehemiekasereka2003@gmail.com'; // À sécuriser
            $mail->Password = 'naya kwtc bfow qozd'; // À sécuriser
            $mail->SMTPSecure = PHPMailer::ENCRYPTION_STARTTLS;
            $mail->Port = 587;

            $mail->setFrom('nehemiekasereka2003@gmail.com', 'ACCIAC');
            $mail->addAddress($to, $toName);

            $mail->isHTML(false);
            $mail->Subject = $subject;
            $mail->Body = $body;

            $mail->send();
        } catch (Exception $e) {
            // Log ou gestion d'erreur si besoin
        }
    }

    /**
     * Récupère les demandes acceptées pour un locataire donné, avec les infos de la maison.
     */
    public function getDemandesApprouveesPourLocataire($id_utilisateur)
    {
        $query = "SELECT 
                    dl.id_demande,
                    dl.date AS date_demande,
                    dl.statut,
                    m.id_maison,
                    m.adresse,
                    m.prix
                  FROM {$this->table} dl
                  INNER JOIN maison m ON dl.id_maison = m.id_maison
                  WHERE dl.id_utilisateur = :id_utilisateur
                  AND dl.statut = 'acceptee'
                  ORDER BY dl.id_demande DESC";
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":id_utilisateur", $id_utilisateur, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

}
?>
