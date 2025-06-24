  // Navigation entre sections
    function showSection(section) {
        document.querySelectorAll('.main-section').forEach(s => s.classList.remove('active'));
        document.getElementById(section).classList.add('active');
        document.querySelectorAll('.sidebar .nav-link').forEach(link => link.classList.remove('active'));
        document.querySelector('.sidebar .nav-link[data-section="'+section+'"]')?.classList.add('active');
    }
    document.querySelectorAll('.sidebar .nav-link[data-section]').forEach(link => {
        link.addEventListener('click', function(e) {
            e.preventDefault();
            showSection(this.getAttribute('data-section'));
        });
    });
    document.addEventListener('DOMContentLoaded', function() {
    // Étape suivante
    document.getElementById('toStep2').addEventListener('click', function() {
        // Validation simple de l'étape 1
        var adresse = document.getElementById('adresse').value.trim();
        var chambres = document.getElementById('nombre_de_chambre').value;
        var photo = document.getElementById('photo').files.length;
        if (!adresse || !chambres || !photo) {
            alert('Veuillez remplir tous les champs de cette étape.');
            return;
        }
        document.getElementById('step1').classList.add('d-none');
        document.getElementById('step2').classList.remove('d-none');
    });
    // Retour à l'étape 1
    document.getElementById('backStep1').addEventListener('click', function() {
        document.getElementById('step2').classList.add('d-none');
        document.getElementById('step1').classList.remove('d-none');
    });
    // Réinitialiser le formulaire à l'ouverture
    var modalAnnonce = document.getElementById('modalAnnonce');
    modalAnnonce.addEventListener('show.bs.modal', function () {
        document.getElementById('step1').classList.remove('d-none');
        document.getElementById('step2').classList.add('d-none');
        document.getElementById('formAnnonce').reset();
    });
});