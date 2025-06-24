<?php
require_once("../connexion/connexion.php");
class Avis
{
    private $conn;
    private $table = "avis";

    public function __construct()
    {
         $con = new connexion();
        $this->conn = $con->getcon();
    }

    public function ajouterAvis($note, $commentaire, $id_utilisateur, $id_maison)
    {
        $query = "INSERT INTO " . $this->table . " (note, commentaire, id_utilisateur, id_maison) 
                  VALUES (:note, :commentaire, :id_utilisateur, :id_maison)";
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":note", $note);
        $stmt->bindParam(":commentaire", $commentaire);
        $stmt->bindParam(":id_utilisateur", $id_utilisateur);
        $stmt->bindParam(":id_maison", $id_maison);

        return $stmt->execute();
    }

    public function supprimerAvis($id_avis)
    {
        $query = "DELETE FROM " . $this->table . " WHERE id_avis = :id_avis";
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":id_avis", $id_avis);

        return $stmt->execute();
    }

    public function modifierAvis($id_avis, $note, $commentaire, $id_utilisateur, $id_maison)
    {
        $query = "UPDATE " . $this->table . " SET note = :note, commentaire = :commentaire, id_utilisateur = :id_utilisateur, id_maison = :id_maison WHERE id_avis = :id_avis";
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":note", $note);
        $stmt->bindParam(":commentaire", $commentaire);
        $stmt->bindParam(":id_utilisateur", $id_utilisateur);
        $stmt->bindParam(":id_maison", $id_maison);
        $stmt->bindParam(":id_avis", $id_avis);

        return $stmt->execute();
    }

    public function getAvis()
    {
        $query = "SELECT * FROM " . $this->table . " ORDER BY id_avis DESC";
        $stmt = $this->conn->prepare($query);
        $stmt->execute();

        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    public function getAvisByMaison($id_maison)
    {
        $query = "SELECT * FROM " . $this->table . " WHERE id_maison = :id_maison ORDER BY id_avis DESC";
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":id_maison", $id_maison);
        $stmt->execute();

        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    public function getAvisByUtilisateur($id_utilisateur)
    {
        $query = "SELECT * FROM " . $this->table . " WHERE id_utilisateur = :id_utilisateur ORDER BY id_avis DESC";
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":id_utilisateur", $id_utilisateur);
        $stmt->execute();

        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    public function getAvisById($id_avis)
    {
        $query = "SELECT * FROM " . $this->table . " WHERE id_avis = :id_avis";
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":id_avis", $id_avis);
        $stmt->execute();

        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    public function getAvisByMaisonAndUser($maisonId, $userId)
    {
        $query = "SELECT * FROM " . $this->table . " WHERE id_maison = :id_maison AND id_utilisateur = :id_utilisateur";
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":id_maison", $maisonId);
        $stmt->bindParam(":id_utilisateur", $userId);
        $stmt->execute();

        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }
}
?>
