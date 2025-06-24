<?php
class connexion
{
private $host="localhost";
private $dbname="location_maison";
private $user="root";
private $password="";
private $port="";
public $pdo;
public function __construct() {
    return $this->getcon();
    
}
 public function getcon()
{
    $this->pdo=null;
    try {
        $this->pdo=new PDO("mysql:host=$this->host;dbname=$this->dbname",$this->user,$this->password);  
    } catch (PDOException $th)
     {
        throw new PDOException("Erreur lors de la connexion: " . $th->getMessage());
    }
    return $this->pdo;
}
}
?>