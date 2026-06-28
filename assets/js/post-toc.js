(() => {
    const tocContainers = Array.from(document.querySelectorAll('[data-post-toc]'));
    const headings = Array.from(document.querySelectorAll('.post-content h2, .post-content h3'));

    if (tocContainers.length === 0 || headings.length < 2) {
        return;
    }

    const usedIds = new Set(
        Array.from(document.querySelectorAll('[id]'))
            .map((element) => element.id)
            .filter(Boolean)
    );

    const createHeadingId = (heading, index) => {
        if (heading.id) {
            return heading.id;
        }

        const normalizedText = heading.textContent
            .trim()
            .toLowerCase()
            .replace(/\s+/g, '-')
            .replace(/[^\p{Letter}\p{Number}-]/gu, '')
            .replace(/-+/g, '-')
            .replace(/^-|-$/g, '');
        const baseId = normalizedText || `section-${index + 1}`;
        let id = baseId;
        let suffix = 2;

        while (usedIds.has(id)) {
            id = `${baseId}-${suffix}`;
            suffix += 1;
        }

        usedIds.add(id);
        heading.id = id;
        return id;
    };

    const headingEntries = headings.map((heading, index) => ({
        element: heading,
        id: createHeadingId(heading, index),
        level: Number(heading.tagName.slice(1)),
        text: heading.textContent.trim()
    }));

    const allLinks = [];

    const buildToc = (container) => {
        const rootList = document.createElement('ul');
        rootList.className = 'post-toc__list';
        let currentSectionItem = null;

        headingEntries.forEach((entry) => {
            const item = document.createElement('li');
            item.className = 'post-toc__item';

            const link = document.createElement('a');
            link.className = 'post-toc__link';
            link.href = `#${entry.id}`;
            link.textContent = entry.text;
            link.dataset.tocTarget = entry.id;
            item.appendChild(link);
            allLinks.push(link);

            if (entry.level === 3 && currentSectionItem) {
                let childList = currentSectionItem.querySelector(':scope > .post-toc__list');

                if (!childList) {
                    childList = document.createElement('ul');
                    childList.className = 'post-toc__list';
                    currentSectionItem.appendChild(childList);
                }

                childList.appendChild(item);
                return;
            }

            rootList.appendChild(item);
            currentSectionItem = entry.level === 2 ? item : null;
        });

        container.appendChild(rootList);
    };

    tocContainers.forEach(buildToc);
    document.querySelectorAll('.post-toc').forEach((toc) => {
        toc.hidden = false;
    });

    const prefersReducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)');

    allLinks.forEach((link) => {
        link.addEventListener('click', (event) => {
            const target = document.getElementById(link.dataset.tocTarget);

            if (!target) {
                return;
            }

            event.preventDefault();
            history.pushState(null, '', `#${encodeURIComponent(target.id)}`);
            target.scrollIntoView({
                behavior: prefersReducedMotion.matches ? 'auto' : 'smooth',
                block: 'start'
            });

            window.setTimeout(() => {
                target.setAttribute('tabindex', '-1');
                target.focus({ preventScroll: true });
            }, prefersReducedMotion.matches ? 0 : 350);
        });
    });

    let activeId = '';
    let ticking = false;

    const updateActiveLink = () => {
        const threshold = Math.min(window.innerHeight * 0.3, 180);
        let currentEntry = headingEntries[0];

        headingEntries.forEach((entry) => {
            if (entry.element.getBoundingClientRect().top <= threshold) {
                currentEntry = entry;
            }
        });

        if (currentEntry.id === activeId) {
            ticking = false;
            return;
        }

        activeId = currentEntry.id;
        allLinks.forEach((link) => {
            if (link.dataset.tocTarget === activeId) {
                link.setAttribute('aria-current', 'location');
            } else {
                link.removeAttribute('aria-current');
            }
        });

        const activeSidebarLink = document.querySelector(
            `.post-toc--sidebar [data-toc-target="${CSS.escape(activeId)}"]`
        );

        if (activeSidebarLink) {
            const sidebar = activeSidebarLink.closest('.post-toc--sidebar');

            if (window.getComputedStyle(sidebar).display !== 'none') {
                const sidebarRect = sidebar.getBoundingClientRect();
                const linkRect = activeSidebarLink.getBoundingClientRect();

                if (linkRect.top < sidebarRect.top) {
                    sidebar.scrollTop -= sidebarRect.top - linkRect.top;
                } else if (linkRect.bottom > sidebarRect.bottom) {
                    sidebar.scrollTop += linkRect.bottom - sidebarRect.bottom;
                }
            }
        }

        ticking = false;
    };

    const requestActiveLinkUpdate = () => {
        if (ticking) {
            return;
        }

        ticking = true;
        window.requestAnimationFrame(updateActiveLink);
    };

    window.addEventListener('scroll', requestActiveLinkUpdate, { passive: true });
    window.addEventListener('resize', requestActiveLinkUpdate);
    window.addEventListener('hashchange', requestActiveLinkUpdate);
    requestActiveLinkUpdate();
})();
