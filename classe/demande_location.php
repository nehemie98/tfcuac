<?php
require_once("../connexion/connexion.php");

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
        $query = "INSERT INTO " . $this->table . " (date, statut, id_utilisateur, id_maison)
                  VALUES (NOW(), 'en_attente', :id_utilisateur, :id_maison)";
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":id_utilisateur", $id_utilisateur);
        $stmt->bindParam(":id_maison", $id_maison);

        return $stmt->execute();
    }

    public function supprimerDemande($id_demande)
    {
        $query = "DELETE FROM " . $this->table . " WHERE id_demande = :id_demande";
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":id_demande", $id_demande);

        return $stmt->execute();
    }

    public function getDemandes()
    {
        $query = "SELECT * FROM " . $this->table . " ORDER BY id_demande DESC";
        $stmt = $this->conn->prepare($query);
        $stmt->execute();

        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    public function getDemande($id_demande)
    {
        $query = "SELECT * FROM " . $this->table . " WHERE id_demande = :id_demande";
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":id_demande", $id_demande);
        $stmt->execute();

        return $stmt->fetch(PDO::FETCH_ASSOC);
    }

    public function getDemandesByUtilisateur($id_utilisateur)
    {
        $query = "SELECT * FROM " . $this->table . " WHERE id_utilisateur = :id_utilisateur ORDER BY id_demande DESC";
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":id_utilisateur", $id_utilisateur);
        $stmt->execute();

        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    // Méthode pour changer le statut d'une demande (accepter, refuser, etc.)
    public function actionStatut($id_demande, $statut)
    {
        $query = "UPDATE " . $this->table . " SET statut = :statut WHERE id_demande = :id_demande";
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":statut", $statut);
        $stmt->bindParam(":id_demande", $id_demande);

        return $stmt->execute();
    }

    public function getDemandesByStatut($statut)
    {
        $query = "SELECT * FROM " . $this->table . " WHERE statut = :statut ORDER BY id_demande DESC";
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":statut", $statut);
        $stmt->execute();

        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }
}
?>
