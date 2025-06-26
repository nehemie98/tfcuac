<?php
require_once("../connexion/connexion.php");
class Maison
{
    private $conn;
    private $table = "maison";

    public function __construct()
    {
        $con = new connexion();
        $this->conn = $con->getcon();
    }

    public function ajouterMaison($adresse, $nombre_de_chambre, $photo, $statut, $prix, $description, $id_utilisateur)
    {
        $query = "INSERT INTO " . $this->table . " (adresse, nombre_de_chambre, photo, statut, prix, description, id_utilisateur) 
                  VALUES (:adresse, :nombre_de_chambre, :photo, :statut, :prix, :description, :id_utilisateur)";
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":adresse", $adresse);
        $stmt->bindParam(":nombre_de_chambre", $nombre_de_chambre);
        $stmt->bindParam(":photo", $photo);
        $stmt->bindParam(":statut", $statut);
        $stmt->bindParam(":prix", $prix);
        $stmt->bindParam(":description", $description);
        $stmt->bindParam(":id_utilisateur", $id_utilisateur);

        return $stmt->execute();
    }

    public function supprimerMaison($id_maison)
    {
        $query = "DELETE FROM " . $this->table . " WHERE id_maison = :id_maison";
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":id_maison", $id_maison);

        return $stmt->execute();
    }

    public function getMaisons()
    {
        $query = "SELECT * FROM " . $this->table . " ORDER BY id_maison DESC";
        $stmt = $this->conn->prepare($query);
        $stmt->execute();

        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    public function getMaison($id_maison)
    {
        $query = "SELECT * FROM " . $this->table . " WHERE id_maison = :id_maison";
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":id_maison", $id_maison);
        $stmt->execute();

        return $stmt->fetch(PDO::FETCH_ASSOC);
    }

    public function getMaisonsByUtilisateur($id_utilisateur)
    {
        $query = "SELECT * FROM " . $this->table . " WHERE id_utilisateur = :id_utilisateur ORDER BY id_maison DESC";
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":id_utilisateur", $id_utilisateur);
        $stmt->execute();

        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    public function valider($id_maison, $validite)
    {
        $query = "UPDATE " . $this->table . " SET validite = :validite WHERE id_maison = :id_maison";
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":validite", $validite);
        $stmt->bindParam(":id_maison", $id_maison);

        return $stmt->execute();
    }

    public function getMaisonsApprouvees()
    {
        $query = "SELECT * FROM " . $this->table . " WHERE validite = 'approuver' AND statut='Disponible' ORDER BY id_maison DESC";
        $stmt = $this->conn->prepare($query);
        $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }
    public function changerStatut($id_maison, $statut)
    {
        $query = "UPDATE " . $this->table . " SET statut = :statut WHERE id_maison = :id_maison";
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":statut", $statut);
        $stmt->bindParam(":id_maison", $id_maison);
        return $stmt->execute();
    }
}
