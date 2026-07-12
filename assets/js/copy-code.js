(function () {
    'use strict';

    const copyIcon = `
        <svg aria-hidden="true" viewBox="0 0 24 24" focusable="false">
            <rect x="9" y="9" width="11" height="11" rx="2"></rect>
            <path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"></path>
        </svg>
    `;
    const checkIcon = `
        <svg aria-hidden="true" viewBox="0 0 24 24" focusable="false">
            <path d="m5 12 4 4L19 6"></path>
        </svg>
    `;

    const fallbackCopy = (text) => {
        const textarea = document.createElement('textarea');
        textarea.value = text;
        textarea.setAttribute('readonly', '');
        textarea.style.position = 'fixed';
        textarea.style.opacity = '0';
        document.body.appendChild(textarea);
        textarea.select();

        let copied = false;
        try {
            copied = document.execCommand('copy');
        } finally {
            textarea.remove();
        }

        return copied;
    };

    const copyText = async (text) => {
        if (navigator.clipboard && window.isSecureContext) {
            await navigator.clipboard.writeText(text);
            return true;
        }

        return fallbackCopy(text);
    };

    const setupCopyButtons = () => {
        document.querySelectorAll('.post-content pre > code').forEach((code) => {
            if (code.classList.contains('language-mermaid')) {
                return;
            }

            const pre = code.parentElement;
            if (pre.querySelector('.copy-code-button')) {
                return;
            }

            const button = document.createElement('button');
            button.className = 'copy-code-button';
            button.type = 'button';
            button.setAttribute('aria-label', 'コードをコピー');
            button.innerHTML = copyIcon;

            button.addEventListener('click', async () => {
                try {
                    if (!await copyText(code.textContent)) {
                        throw new Error('Copy command was not successful.');
                    }

                    button.classList.add('is-copied');
                    button.setAttribute('aria-label', 'コピーしました');
                    button.innerHTML = checkIcon;
                    window.setTimeout(() => {
                        button.classList.remove('is-copied');
                        button.setAttribute('aria-label', 'コードをコピー');
                        button.innerHTML = copyIcon;
                    }, 2000);
                } catch (error) {
                    button.setAttribute('aria-label', 'コードのコピーに失敗しました');
                    window.setTimeout(() => {
                        button.setAttribute('aria-label', 'コードをコピー');
                    }, 2000);
                }
            });

            pre.appendChild(button);
        });
    };

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', setupCopyButtons);
    } else {
        setupCopyButtons();
    }
})();
