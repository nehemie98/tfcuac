 // Menu responsive
        const toggle = document.querySelector('.menu-toggle');
        const menu = document.querySelector('.menu');
        toggle.addEventListener('click', () => {
            menu.classList.toggle('show');
        });
        // Fermer le menu au clic sur un lien (mobile)
        document.querySelectorAll('.menu a').forEach(link => {
            link.addEventListener('click', () => {
                if(window.innerWidth <= 700) menu.classList.remove('show');
            });
        });