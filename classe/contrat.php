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
                  VALUES (:date_debut, :date_fin, :id_utilisateur, :id_maison)";
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":date_debut", $dated);
        $stmt->bindParam(":date_fin", $datef);
        $stmt->bindParam(":id_utilisateur", $id_utilisateur);
        $stmt->bindParam(":id_maison", $id_maison);

        if ($stmt->execute()) {
            return $this->conn->lastInsertId(); // retourne l'ID du contrat
        } else {
            return false;
        }
    }

    public function supprimercontrat($id_contrat)
    {
        $query = "DELETE FROM " . $this->table . " WHERE id_contrat = :id_contrat";
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":id_contrat", $id_contrat);

        return $stmt->execute();
    }

    public function modifiercontrat($id_contrat, $date_debut, $date_fin, $id_utilisateur, $id_maison)
    {
        $query = "UPDATE " . $this->table . "
                  SET date_debut = :date_debut, date_fin = :date_fin,
                      id_utilisateur = :id_utilisateur, id_maison = :id_maison
                  WHERE id_contrat = :id_contrat";
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":date_debut", $date_debut);
        $stmt->bindParam(":date_fin", $date_fin);
        $stmt->bindParam(":id_utilisateur", $id_utilisateur);
        $stmt->bindParam(":id_maison", $id_maison);
        $stmt->bindParam(":id_contrat", $id_contrat);

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

    public function getcontratById($id_contrat)
    {
        $query = "SELECT * FROM " . $this->table . " WHERE id_contrat = :id_contrat";
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":id_contrat", $id_contrat);
        $stmt->execute();

        return $stmt->fetch(PDO::FETCH_ASSOC);
    }

    public function getcontratByMaisonAndUser($maisonId, $userId)
    {
        $query = "SELECT * FROM " . $this->table . "
                  WHERE id_maison = :id_maison AND id_utilisateur = :id_utilisateur
                  ORDER BY id_contrat DESC";
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":id_maison", $maisonId);
        $stmt->bindParam(":id_utilisateur", $userId);
        $stmt->execute();

        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    public function modifierDateFinContrat($id_contrat, $date_fin)
    {
        $query = "UPDATE " . $this->table . " SET date_fin = :date_fin WHERE id_contrat = :id_contrat";
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":date_fin", $date_fin);
        $stmt->bindParam(":id_contrat", $id_contrat);

        return $stmt->execute();
    }

    public function getDernierContrat($id_utilisateur, $id_maison, $dated)
    {
        $sql = "SELECT id_contrat FROM " . $this->table . "
                WHERE id_utilisateur = ? AND id_maison = ? AND date_debut = ?
                ORDER BY id_contrat DESC LIMIT 1";
        $stmt = $this->conn->prepare($sql);
        $stmt->execute([$id_utilisateur, $id_maison, $dated]);
        $contrat = $stmt->fetch();

        return $contrat ? $contrat['id_contrat'] : false;
    }

    public function getdateFinContrat($id_contrat)
    {
        $query = "SELECT date_fin FROM " . $this->table . " WHERE id_contrat = :id_contrat";
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":id_contrat", $id_contrat);
        $stmt->execute();
        $result = $stmt->fetch(PDO::FETCH_ASSOC);

        return $result ? $result['date_fin'] : null;
    }

    public function verifierStatutContrat($id_contrat)
    {
        $date_fin = $this->getdateFinContrat($id_contrat);
        if (!$date_fin) return "Inconnu";

        $date_auj = new DateTime();
        $date_fin = new DateTime($date_fin);

        return ($date_fin >= $date_auj) ? "En cours" : "Clôturé";
    }
    public function getDetailsCompletContrat($id_maison, $id_utilisateur)
{
    $sql = "SELECT 
                u_loc.nom AS nom_locataire,
                u_loc.email AS email_locataire,
                u_prop.nom AS nom_proprietaire,
                u_prop.email AS email_proprietaire,
                cl.date_debut,
                cl.date_fin,
                p.montant,
                p.statut,
                m.prix,
                m.adresse
            FROM 
                demande_location d
            JOIN 
                maison m ON d.id_maison = m.id_maison
            JOIN 
                utilisateurs u_loc ON d.id_utilisateur = u_loc.id
            JOIN 
                utilisateurs u_prop ON m.id_utilisateur = u_prop.id
            JOIN 
                contrat_location cl ON cl.id_maison = m.id_maison AND cl.id_utilisateur = d.id_utilisateur
            JOIN 
                paiement p ON p.id_contrat = cl.id_contrat
            WHERE 
                d.id_maison = :id_maison AND d.id_utilisateur = :id_utilisateur
            ORDER BY 
                cl.date_debut DESC
            LIMIT 1";

    $stmt = $this->conn->prepare($sql);
    $stmt->bindParam(':id_maison', $id_maison, PDO::PARAM_INT);
    $stmt->bindParam(':id_utilisateur', $id_utilisateur, PDO::PARAM_INT);
    $stmt->execute();

    return $stmt->fetch(PDO::FETCH_ASSOC);
}

}
?>
