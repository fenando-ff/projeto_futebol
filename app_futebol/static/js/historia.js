document.addEventListener('DOMContentLoaded', function() {
    const events = document.querySelectorAll('.timeline-event');
    const overlay = document.getElementById('historia-modal-overlay');
    const modalImg = document.getElementById('historia-modal-img');
    const modalTitle = document.getElementById('historia-modal-title');
    const modalDesc = document.getElementById('historia-modal-desc');
    const closeBtn = document.getElementById('historia-modal-close');

    if (!overlay || !modalImg) return;

    events.forEach(function(eventElement) {
        eventElement.addEventListener('click', function(e) {
            e.preventDefault();
            
            const imageSrc = eventElement.getAttribute('data-image-src');
            const titleText = eventElement.getAttribute('data-title');
            const descText = eventElement.getAttribute('data-description');

            modalImg.src = imageSrc || '';
            modalTitle.textContent = titleText || '';
            modalDesc.textContent = descText || '';
            
            overlay.classList.add('active');
        });
    });

    function closeModal() {
        overlay.classList.remove('active');
        modalImg.src = '';
        modalTitle.textContent = '';
        modalDesc.textContent = '';
    }

    if (closeBtn) closeBtn.addEventListener('click', closeModal);
    overlay.addEventListener('click', function(e) { if (e.target === overlay) closeModal(); });
    document.addEventListener('keydown', function(e) { if (e.key === 'Escape') closeModal(); });
});
