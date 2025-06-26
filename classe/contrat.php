<?php
require_once("../connexion/connexion.php");
class Contrat
{
    private $conn;
    private $table = "contrat_location";

    public function __construct()
    {
         $con = new connexion();
        $this->conn = $con->getcon();
    }

    public function ajoutercontrat($dated, $datef, $id_utilisateur, $id_maison)
    {
        $query = "INSERT INTO " . $this->table . " (date_debut, date_fin, id_utilisateur, id_maison) 
                  VALUES (:note, :commentaire, :id_utilisateur, :id_maison)";
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":note", $dated);
        $stmt->bindParam(":commentaire", $datef);
        $stmt->bindParam(":id_utilisateur", $id_utilisateur);
        $stmt->bindParam(":id_maison", $id_maison);

        return $stmt->execute();
    }

    public function supprimercontrat($id_contrat)
    {
        $query = "DELETE FROM " . $this->table . " WHERE id_contrat = :id_avis";
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":id_avis", $id_contrat);

        return $stmt->execute();
    }

    public function modifiercontrat($id_avis, $note, $commentaire, $id_utilisateur, $id_maison)
    {
        $query = "UPDATE " . $this->table . " SET date_debut = :note, date_fin = :commentaire, id_utilisateur = :id_utilisateur, id_maison = :id_maison WHERE id_contrat = :id_avis";
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":note", $note);
        $stmt->bindParam(":commentaire", $commentaire);
        $stmt->bindParam(":id_utilisateur", $id_utilisateur);
        $stmt->bindParam(":id_maison", $id_maison);
        $stmt->bindParam(":id_avis", $id_avis);

        return $stmt->execute();
    }

    public function getcontrat()
    {
        $query = "SELECT * FROM " . $this->table . " ORDER BY id_contrat DESC";
        $stmt = $this->conn->prepare($query);
        $stmt->execute();

        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    public function getcontratByMaison($id_maison)
    {
        $query = "SELECT * FROM " . $this->table . " WHERE id_maison = :id_maison ORDER BY id_contrat DESC";
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":id_maison", $id_maison);
        $stmt->execute();

        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    public function getcontratByUtilisateur($id_utilisateur)
    {
        $query = "SELECT * FROM " . $this->table . " WHERE id_utilisateur = :id_utilisateur ORDER BY id_contrat DESC";
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":id_utilisateur", $id_utilisateur);
        $stmt->execute();

        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    public function getcontratById($id_avis)
    {
        $query = "SELECT * FROM " . $this->table . " WHERE id_contrat = :id_avis";
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":id_avis", $id_avis);
        $stmt->execute();

        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    public function getcontratByMaisonAndUser($maisonId, $userId)
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
