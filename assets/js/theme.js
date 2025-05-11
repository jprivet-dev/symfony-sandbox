/*!
 * To avoid darkmode flickering, insert the following <script> directly into the <head>, before all other scripts:
 *
 *  <script src="{{ asset('js/theme.js') }}"></script>
 *
 * By default, a <script> tag interrupts the parsing of the HTML and block rendering until the script has been downloaded, analyzed and executed.
 * Thanks to this trick, the theme is initialized well before the page is rendered, avoiding flickering between light and dark themes.
 * Inspired by https://github.com/twbs/bootstrap/blob/v5.3.6/site/static/docs/%5Bversion%5D/assets/js/color-modes.js.
 */

(() => {
    'use strict';

    const init = () => setTheme(getStoredTheme());
    const next = () => setTheme(chooseNext(getStoredTheme()));
    const opposite = (theme) => theme === 'dark' ? 'light' : 'dark';
    const chooseNext = (theme) => ({ 'light': 'dark', 'dark': 'auto', 'auto': 'light' })[theme];
    const getStoredTheme = () => localStorage.getItem('theme') || 'auto';
    const setStoredTheme = (theme) => localStorage.setItem('theme', theme);
    const getMatchMediaPrefersColorSchema = () => window.matchMedia(`(prefers-color-scheme: dark)`).matches ? 'dark' : 'light';

    const setTheme = (theme) => {
        setStoredTheme(theme);
        theme = theme === 'auto' ? getMatchMediaPrefersColorSchema() : theme;
        document.documentElement.classList.add(theme);
        document.documentElement.classList.remove(opposite(theme));
        document.documentElement.dispatchEvent(new CustomEvent('theme:active', { detail: { theme: getStoredTheme() } }));
    };

    document.documentElement.addEventListener('theme:init', () => init());
    document.documentElement.addEventListener('theme:next', () => next());
    window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', () => init());

    init();
})();
