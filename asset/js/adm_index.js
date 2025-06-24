// Sidebar toggle for mobile
document.addEventListener('DOMContentLoaded', function () {
    const sidebar = document.getElementById('sidebarMenu');
    const toggleBtn = document.getElementById('sidebarToggle');

    if (sidebar && toggleBtn) {
        toggleBtn.addEventListener('click', function () {
            sidebar.classList.toggle('show');
        });

        // Hide sidebar when clicking outside (mobile)
        document.addEventListener('click', function (e) {
            if (
                window.innerWidth < 768 &&
                !sidebar.contains(e.target) &&
                !toggleBtn.contains(e.target)
            ) {
                sidebar.classList.remove('show');
            }
        });
    }

    // Multi-step modal logic
    const steps = document.querySelectorAll('#ajoutUtilisateurModal .step');
    const nextBtn = document.querySelector('#ajoutUtilisateurModal .next-step');
    const prevBtn = document.querySelector('#ajoutUtilisateurModal .prev-step');
    const submitBtn = document.querySelector('#ajoutUtilisateurModal [type="submit"]');
    let currentStep = 0;

    function showStep(index) {
        steps.forEach((step, i) => {
            step.classList.toggle('d-none', i !== index);
        });
        if (prevBtn) prevBtn.classList.toggle('d-none', index === 0);
        if (nextBtn) nextBtn.classList.toggle('d-none', index === steps.length - 1);
        if (submitBtn) submitBtn.classList.toggle('d-none', index !== steps.length - 1);
    }

    if (nextBtn) {
        nextBtn.addEventListener('click', function () {
            if (currentStep < steps.length - 1) {
                currentStep++;
                showStep(currentStep);
            }
        });
    }

    if (prevBtn) {
        prevBtn.addEventListener('click', function () {
            if (currentStep > 0) {
                currentStep--;
                showStep(currentStep);
            }
        });
    }

    const ajoutUtilisateurModal = document.getElementById('ajoutUtilisateurModal');
    if (ajoutUtilisateurModal) {
        ajoutUtilisateurModal.addEventListener('show.bs.modal', function () {
            currentStep = 0;
            showStep(currentStep);
            const form = document.getElementById('ajoutUtilisateurForm');
            if (form) form.reset();
        });
    }

    // Section display management
    document.querySelectorAll('a[data-section]').forEach(function (link) {
        link.addEventListener('click', function (e) {
            e.preventDefault();
            // Remove active class from all links
            document.querySelectorAll('a[data-section]').forEach(function (l) {
                l.classList.remove('active');
            });
            // Add active class to clicked link
            this.classList.add('active');
            // Hide all sections
            document.querySelectorAll('.section-content').forEach(function (sec) {
                sec.style.display = 'none';
            });
            // Show the corresponding section
            var sectionId = 'section-' + this.getAttribute('data-section');
            var section = document.getElementById(sectionId);
            if (section) section.style.display = '';
        });
    });

    // Show the "utilisateurs" section by default
    const defaultSectionLink = document.querySelector('a[data-section="utilisateurs"]');
    if (defaultSectionLink) defaultSectionLink.click();
});