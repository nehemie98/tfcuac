<?php
require_once("../connexion/connexion.php");

class Paiement
{
    private $conn;
    private $table = "paiement";

    public function __construct()
    {
        $con = new connexion();
        $this->conn = $con->getcon();
    }

    // Ajouter un paiement
    public function ajouterPaiement($date_paiement, $montant, $statut, $id_contrat)
    {
        try {
            $query = "INSERT INTO " . $this->table . " (date_paiement,montant,statut,id_contrat)
                      VALUES (:date_paiement, :montant, :statut, :id_contrat)";
            $stmt = $this->conn->prepare($query);
            $stmt->bindParam(":date_paiement", $date_paiement);
            $stmt->bindParam(":montant", $montant);
            $stmt->bindParam(":statut", $statut);
            $stmt->bindParam(":id_contrat", $id_contrat, PDO::PARAM_INT);
            return $stmt->execute();
        } catch (PDOException $e) {
            // Log ou afficher l'erreur selon vos besoins
            return false;
        }
    }

    // Récupérer tous les paiements
    public function getPaiements()
    {
        try {
            $query = "SELECT * FROM " . $this->table . " ORDER BY id_paiement DESC";
            $stmt = $this->conn->prepare($query);
            $stmt->execute();
            return $stmt->fetchAll(PDO::FETCH_ASSOC);
        } catch (PDOException $e) {
            return [];
        }
    }

    // Récupérer un paiement par son ID
    public function getPaiement($id_paiement)
    {
        try {
            $query = "SELECT * FROM " . $this->table . " WHERE id_paiement = :id_paiement";
            $stmt = $this->conn->prepare($query);
            $stmt->bindParam(":id_paiement", $id_paiement, PDO::PARAM_INT);
            $stmt->execute();
            return $stmt->fetch(PDO::FETCH_ASSOC);
        } catch (PDOException $e) {
            return false;
        }
    }

    // Supprimer un paiement
    public function supprimerPaiement($id_paiement)
    {
        try {
            $query = "DELETE FROM " . $this->table . " WHERE id_paiement = :id_paiement";
            $stmt = $this->conn->prepare($query);
            $stmt->bindParam(":id_paiement", $id_paiement, PDO::PARAM_INT);
            return $stmt->execute();
        } catch (PDOException $e) {
            return false;
        }
    }

    // Récupérer les paiements par contrat
    public function getPaiementsByContrat($id_contrat)
    {
        try {
            $query = "SELECT * FROM " . $this->table . " WHERE id_contrat = :id_contrat ORDER BY date_paiement DESC";
            $stmt = $this->conn->prepare($query);
            $stmt->bindParam(":id_contrat", $id_contrat, PDO::PARAM_INT);
            $stmt->execute();
            return $stmt->fetchAll(PDO::FETCH_ASSOC);
        } catch (PDOException $e) {
            return [];
        }
    }
}