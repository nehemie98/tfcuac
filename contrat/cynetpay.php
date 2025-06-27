<?php 
require_once("../connexion/connexion.php");
require_once("../classe/contrat.php");
require_once("../classe/paiement.php");
require_once("../classe/maison.php");

$contrat = new Contrat();
$paiement = new Paiement();
$maison = new Maison();

// Vérifie si un montant est passé par GET
$montant = isset($_GET['mont']) ? floatval($_GET['mont']) : 0;
?>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Paiement en ligne CinetPay</title>
  <script src="https://cdn.cinetpay.com/seamless/main.js"></script> <!-- Script officiel CinetPay -->
  <style>
    body {
      font-family: Arial, sans-serif;
      padding: 40px;
      background: #f8f9fa;
    }
    .container {
      max-width: 500px;
      margin: auto;
      background: white;
      padding: 30px;
      border-radius: 10px;
      box-shadow: 0 0 15px rgba(0,0,0,0.1);
      text-align: center;
    }
    .checkout-btn {
      margin-top: 20px;
      background-color: #28a745;
      color: white;
      padding: 12px 20px;
      border: none;
      border-radius: 5px;
      font-size: 16px;
      cursor: pointer;
    }
    .message {
      margin-top: 20px;
      font-weight: bold;
    }
  </style>
</head>
<body>

  <div class="container">
    <h2>Paiement sécurisé</h2>

    <input type="hidden" id="amount" value="<?= htmlspecialchars($montant) ?>">
    
    <button class="checkout-btn" onclick="checkout()">Confirmer le paiement</button>

    <div id="message" class="message"></div>
  </div>

  <script>
    function checkout() {
      const amount = parseFloat(document.getElementById('amount').value);

      if (isNaN(amount) || amount <= 0) {
        alert("Montant invalide !");
        return;
      }

      // Configuration CinetPay
      CinetPay.setConfig({
        apikey: '164204345467d54866b27fd9.58129159', // 🔐 à sécuriser
        site_id: '105889944',
        notify_url: 'http://localhost/tfcuac/locataire/lc_index.php',
        mode: 'PRODUCTION' // ou 'SANDBOX'
      });

      // Initialisation du paiement
      const transaction_id = 'TXN' + Math.floor(Math.random() * 1000000000);
      CinetPay.getCheckout({
        transaction_id: transaction_id,
        amount: amount,
        currency: 'CDF',
        channels: 'ALL',
        description: 'Paiement de location',
        customer_name: "Utilisateur",
        customer_surname: "Locataire",
        customer_email: "user@example.com",
        customer_phone_number: "243840000000",
        customer_address: "Butembo",
        customer_city: "Butembo",
        customer_country: "CD",
        customer_state: "Nord-Kivu",
        customer_zip_code: "0000"
      });

      // Résultat
      CinetPay.waitResponse(function(data) {
        const msg = document.getElementById('message');
        if (data.status === "REFUSED") {
          msg.textContent = "Paiement refusé. Veuillez réessayer.";
          msg.style.color = "red";
          setTimeout(() => {
            window.location.href = "http://localhost/tfcuac/locataire/lc_index.php";
          }, 2000);
        } else if (data.status === "ACCEPTED") {
          msg.textContent = "Paiement réussi !";
          msg.style.color = "green";
          setTimeout(() => {
            window.location.href = "http://localhost/tfcuac/locataire/lc_index.php";
          }, 2000);
        }
      });

      // Gestion erreur technique
      CinetPay.onError(function(data) {
        console.error("Erreur CinetPay:", data);
        const msg = document.getElementById('message');
        msg.textContent = "Erreur lors du traitement du paiement.";
        msg.style.color = "red";
        setTimeout(() => {
          window.location.href = "https://votre-domaine.com/erreur.html";
        }, 2000);
      });
    }
  </script>

</body>
</html>
