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
    // Mettre à jour le statut d'un paiement
    public function mettreAJourStatutPaiement($id_paiement, $statut)
    {
        try {
            $query = "UPDATE " . $this->table . " SET statut = :statut WHERE id_paiement = :id_paiement";
            $stmt = $this->conn->prepare($query);
            $stmt->bindParam(":statut", $statut);
            $stmt->bindParam(":id_paiement", $id_paiement, PDO::PARAM_INT);
            return $stmt->execute();
        } catch (PDOException $e) {
            return false;
        }
    }
    // Récupérer le montant total des paiements pour un contrat
    public function getMontantTotalPaiements($id_contrat)
    {
        try {
            $query = "SELECT SUM(montant) AS total FROM " . $this->table . " WHERE id_contrat = :id_contrat";
            $stmt = $this->conn->prepare($query);
            $stmt->bindParam(":id_contrat", $id_contrat, PDO::PARAM_INT);
            $stmt->execute();
            $result = $stmt->fetch(PDO::FETCH_ASSOC);
            return $result['total'] ? floatval($result['total']) : 0.0;
        } catch (PDOException $e) {
            return 0.0;
        }
    }
    // Récupérer le dernier paiement pour un contrat
    public function getDernierPaiement($id_contrat)
    {
        try {
            $query = "SELECT * FROM " . $this->table . " WHERE id_contrat = :id_contrat ORDER BY date_paiement DESC LIMIT 1";
            $stmt = $this->conn->prepare($query);
            $stmt->bindParam(":id_contrat", $id_contrat, PDO::PARAM_INT);
            $stmt->execute();
            return $stmt->fetch(PDO::FETCH_ASSOC);
        } catch (PDOException $e) {
            return false;
        }
    }
    // Récupérer le nombre de paiements pour un contrat
    public function getNombrePaiements($id_contrat)
    {
        try {
            $query = "SELECT COUNT(*) AS nombre FROM " . $this->table . " WHERE id_contrat = :id_contrat";
            $stmt = $this->conn->prepare($query);
            $stmt->bindParam(":id_contrat", $id_contrat, PDO::PARAM_INT);
            $stmt->execute();
            $result = $stmt->fetch(PDO::FETCH_ASSOC);
            return intval($result['nombre']);
        } catch (PDOException $e) {
            return 0;
        }
    }
public function getPaiementsParProprietaire($idProprietaire)
{
    try {
        $query = "
            SELECT 
                loc.nom AS nom_locataire,
                p.montant,
                p.date,
                m.adresse AS adresse_maison,
                p.statut
            FROM paiement p
            INNER JOIN contrat c ON p.id_contrat = c.id_contrat
            INNER JOIN utilisateurs loc ON c.id_locataire = loc.id
            INNER JOIN maison m ON c.id_maison = m.id_maison
            WHERE 
                m.id_utilisateur = :id_proprietaire
                AND p.statut = 'payé'
            ORDER BY p.date DESC
        ";

        $stmt = $this->pdo->prepare($query);
        $stmt->execute([
            'id_proprietaire' => $idProprietaire
        ]);

        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    } catch (PDOException $e) {
        error_log("Erreur Paiement::getPaiementsParProprietaire - " . $e->getMessage());
        return [];
    }
}
 // Récupérer les paiements par locataire
    public function getPaiementsParLocataire($idLocataire)
    {
        try {
            $query = "
                SELECT 
                    p.*,
                    c.date_debut,
                    c.date_fin,
                    m.adresse AS adresse_maison
                FROM paiement p
                INNER JOIN contrat c ON p.id_contrat = c.id_contrat
                INNER JOIN maison m ON c.id_maison = m.id_maison
                WHERE c.id_locataire = :id_locataire
                ORDER BY p.date_paiement DESC
            ";
            $stmt = $this->conn->prepare($query);
            $stmt->bindParam(":id_locataire", $idLocataire, PDO::PARAM_INT);
            $stmt->execute();
            return $stmt->fetchAll(PDO::FETCH_ASSOC);
        } catch (PDOException $e) {
            return [];
        }
    }

}