<?php 
require_once("../connexion/connexion.php");


class Utilisateur
 {
    private $conn;
    private $table = "utilisateurs";
    private $pdo;
    public $page ;
    public $limit = 6;
    public $offset = 0;
    public $total = 0;

    public function __construct()
    {
        $con=new connexion();
        $this->conn=$con->getcon();
    }

    public function inscrire($nom,$email,$role,$image,$password) {
        
        $hashed_password = password_hash($password, PASSWORD_BCRYPT);
        $query = "INSERT INTO " . $this->table . " (nom, email, mot_de_passe,pwdh, role,image_profile) VALUES (:nom, :email, :password,:pwdh, :role,:profile)";
        $stmt =$this->conn->prepare($query);
        $stmt->bindParam(":nom", $nom);
        $stmt->bindParam(":email", $email);
        $stmt->bindParam(":password", $password);
        $stmt->bindParam(":pwdh", $hashed_password);
        $stmt->bindParam(":role", $role);
        $stmt->bindParam(":profile", $image);
        return $stmt->execute();
    }

    public function getutilisateurs()
    {
        try {
        
            $sql = "SELECT * FROM ".$this->table ." ORDER BY id DESC";
            $stmt =$this->conn->prepare($sql);
            $stmt->execute();
            return $stmt->fetchAll(PDO::FETCH_ASSOC);
        } catch (PDOException $e) {
            throw new PDOException("Erreur lors de la récupération des utilisateurs : " . $e->getMessage());
        }
    }
    public function getutilisateur($id)
    {
        try {
        
            $sql = "SELECT * FROM ". $this->table ." WHERE id = ? ";
            $stmt =$this->conn->prepare($sql);
            $stmt->execute([$id]);
            return $stmt->fetch(PDO::FETCH_ASSOC);
        } catch (PDOException $e) {
            throw new PDOException("Erreur lors de la récupération des utilisateurs : " . $e->getMessage());
        }
    }
    public function deleteuser($id)
    {
        try {
            $sql = "DELETE FROM ".$this->table ." WHERE id = ?";
            $stmt = $this->conn->prepare($sql);
            return $stmt->execute([$id]);
        } catch (PDOException $e) {
            throw new PDOException("Erreur lors de la suppression de l'utilisateur : " . $e->getMessage());
        }
    }
    public function modification($id, $nom, $email, $role)
    {
        try {
            $sql = "UPDATE ".$this->table ." SET nom = ?, email = ?, `role` = ? WHERE id = ?";
            $stmt = $this->conn->prepare($sql);
            return $stmt->execute([$nom, $email, $role, $id]);
        } catch (PDOException $e) {
            throw new PDOException("Erreur lors de la mise à jour de l'utilisateur : " . $e->getMessage());
        }
    }

    public function connexion($nom,$password) {
        $query = "SELECT * FROM " .$this->table . " WHERE nom = :nom";
        $stmt =$this->conn->prepare($query);
        $stmt->bindParam(":nom", $nom);
        $stmt->execute();
        $user =$stmt->fetch(PDO::FETCH_ASSOC);
        if ($user && password_verify($password, $user["pwdh"]))
        { 
            if (session_status() === PHP_SESSION_NONE) {
                session_start();
            }
            $_SESSION['user'] = $user;
            
            return $user;
        }
        return false;
    }
    public function setpas($long = 8)
    {
        $characters = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'. "@@@\\\\????!!!!" ;
        $chaine = strlen($characters);
        $password = '';
        for ($i = 0; $i < $long; $i++) {
            $password .= $characters[rand(0, $chaine - 1)];
        }
        return $password;
    } 
    public function getpas()
    {
        return $this->motdepasse=$this->setpas();
    }
    public function pagination($page)
    {
        try {
            // Calculate total entries and set pagination properties
            $stmt = $this->conn->query("SELECT COUNT(*) as total FROM $this->table");
            $this->total = $stmt->fetch(PDO::FETCH_ASSOC)['total'];
            $this->page = $page;
            $this->offset = ($this->page - 1) * $this->limit;

            // Fetch paginated results
            $stmt = $this->conn->prepare("SELECT * FROM $this->table LIMIT ? OFFSET ?");
            $stmt->bindValue(1, $this->limit, PDO::PARAM_INT);
            $stmt->bindValue(2, $this->offset, PDO::PARAM_INT);
            $stmt->execute();
            $total_pages = ceil($this->total / $this->limit);

            // Return results and total pages
            return $stmt->fetchAll(PDO::FETCH_ASSOC);
        } catch (PDOException $e) {
            throw new PDOException("Erreur lors de la pagination : " . $e->getMessage());
        }
    }
    public function getpage()
    {
        return $this->page;
    }
    public function setpage($page)
    {
        $this->page = $page;
        $this->offset = ($this->page - 1) * $this->limit;
    }
    public function getlimit()
    {
        return $this->limit;
    }
    public function setlimit($limit)
    {
        $this->limit = $limit;
    }
    public function getoffset()
    {
        return $this->offset;
    }
    public function setoffset($offset)
    {
        $this->offset = $offset;
    }
    public function gettotal()
    {
        return $this->total;
    }
    public function settotal($total)
    {
        $this->total = $total;
    }
    public function gettable()
    {
        return $this->table;
    }
    public function settable($table)
    {
        $this->table = $table;
    }
    public function getadresse()
    {
        return $this->adresse;
    }
    public function setadresse($adresse)
    {
        $this->adresse = $adresse;
    }
    public function getpostnom()
    {
        return $this->postnom;
    }
    public function setpostnom($postnom)
    {
        $this->postnom = $postnom;
    }
    public function getgenre()
    {
        return $this->genre;
    }
    public function setgenre($genre)
    {
        $this->genre = $genre;
    }
    public function getmotdepasse()
    {
        return $this->motdepasse;
    }
    public function setmotdepasse($motdepasse)
    {
        $this->motdepasse = $motdepasse;
    }
    public function getpdo()
    {
        return $this->pdo;
    }
    public function setpdo($pdo)
    {
        $this->pdo = $pdo;
    }
}







