<?php
require_once '../classe/contrat.php';
require_once('../vendor/tecnickcom/tcpdf/tcpdf.php'); // Assure-toi que tcpdf est bien installé et accessible

$contrat = new Contrat();

if (isset($_POST['id_maison']) && isset($_POST['id_utilisateur'])) {
    $id_maison = intval($_POST['id_maison']);
    $id_utilisateur = intval($_POST['id_utilisateur']);

    // Récupération des détails complets du contrat
    $contratDetails = $contrat->getDetailsCompletContrat($id_maison, $id_utilisateur);

    if (!empty($contratDetails)) {

        class MYPDF extends TCPDF {
            public $contratDetails;

            public function Header() {
                // Logo entreprise à gauche
                $logo_acc = __DIR__ . '/../images/logo/logo.avif';
                if (file_exists($logo_acc)) {
                    $this->Image($logo_acc, 15, 10, 35);
                }

                // Drapeau RDC à droite
                $drapeau_rdc = __DIR__ . '/../images/logo/logo.avif';
                if (file_exists($drapeau_rdc)) {
                    $this->Image($drapeau_rdc, 160, 10, 30);
                }

                // Nom + email locataire à droite, sous drapeau
              if (!empty($this->contratDetails)) {
    $this->SetFont('times', '', 12);
    $locataire = "Locataire : " . $this->contratDetails['nom_locataire'] . " \nMail : " . $this->contratDetails['email_locataire'];
    $this->SetXY(10, 45); // Position horizontale plus confortable
    $this->MultiCell(90, 5, $locataire, 0, 'L', 0, 1);
}


                // Titre centré sous les images, vers Y=80
                $this->SetFont('times', 'B', 14);
                $this->SetXY(15, 58);
                $this->Cell(0, 10, 'CONTRAT DE LOCATION - ACCIAC', 0, 1, 'C');

                $this->Ln(5);
            }

            public function Footer() {
                $this->SetY(-15);
                $this->SetFont('times', 'I', 8);
                $this->Cell(0, 10, 'Page '.$this->getAliasNumPage().' / '.$this->getAliasNbPages(), 0, 0, 'C');
            }
        }

        // Création du PDF
        $pdf = new MYPDF('P', 'mm', 'A4', true, 'UTF-8', false);
        $pdf->contratDetails = $contratDetails; // Passer les données à l'entête
        $pdf->SetCreator('ACCIAC');
        $pdf->SetAuthor('ACCIAC');
        $pdf->SetTitle('Contrat de location');
        $pdf->SetMargins(15, 100, 15); // marge haute de 100mm pour laisser place à l'entête
        $pdf->SetAutoPageBreak(true, 25);

        // Image de fond : armoirie RDC en filigrane
        $armoirie = __DIR__ . '/../images/logo/logo.avif';
        $pdf->AddPage();

        if (file_exists($armoirie)) {
            $pdf->SetAlpha(0.1);
            $pdf->Image($armoirie, 40, 110, 130, 130, '', '', '', false, 300, '', false, false, 0);
            $pdf->SetAlpha(1);
        }

        $pdf->SetFont('times', '', 11);

        // Contenu justifié à partir d'environ 110mm vertical
        $html = '
        <p>Entre les soussignés :</p>
        <p><strong>Le Propriétaire :</strong> ' . htmlspecialchars($contratDetails['nom_proprietaire']) . ' (' . htmlspecialchars($contratDetails['email_proprietaire']) . '),</p>
        <p><strong>Le Locataire :</strong> ' . htmlspecialchars($contratDetails['nom_locataire']) . ' (' . htmlspecialchars($contratDetails['email_locataire']) . '),</p>
        <p>Il a été convenu ce qui suit :</p>
        <p>Le propriétaire loue au locataire la maison située à <strong>' . htmlspecialchars($contratDetails['adresse']) . '</strong>, pour un montant mensuel de <strong>' . number_format($contratDetails['prix'], 2, ',', ' ') . ' $</strong>.</p>
        <p>Le montant payé à ce jour est de <strong>' . number_format($contratDetails['montant'], 2, ',', ' ') . ' $</strong>.</p>
        <p>La location est conclue pour une durée allant du <strong>' . htmlspecialchars($contratDetails['date_debut']) . '</strong> au <strong>' . htmlspecialchars($contratDetails['date_fin']) . '</strong>.</p>
        <p>Le locataire s’engage à respecter les termes du présent contrat et à payer le montant convenu aux dates fixées.</p>
        <p>Le propriétaire garantit que la maison est conforme aux normes et peut être occupée durant la durée du contrat.</p>
        <p>Ce contrat est soumis à la législation en vigueur en République Démocratique du Congo.</p>
        <p><strong>Fait à Kinshasa, le :</strong> ' . date('d/m/Y') . '</p>
        ';

        $pdf->writeHTMLCell(0, 0, '', 110, $html, 0, 1, 0, true, 'J', true);

        $pdf->Ln(20);
        $pdf->Cell(90, 0, 'Signature du Locataire', 0, 0, 'C');
        $pdf->Cell(0, 0, 'Signature du Propriétaire', 0, 1, 'C');

        $pdf->Output('contrat_location_acciac.pdf', 'I');

    } else {
        echo '<div class="alert alert-warning text-center mt-4" role="alert">Aucun détail trouvé pour ce contrat.</div>';
    }
} else {
    header("Location: ../locataire/lc_index.php?error=" . urlencode("Paramètres manquants."));
    exit();
}
?>
