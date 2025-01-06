/*!
 * Inspired by https://github.com/twbs/bootstrap/blob/main/site/static/docs/5.3/assets/js/color-modes.js.
 *
 * To avoid darkmode flickering, insert the following <script> directly into the <head>, before all other scripts:
 *
 *  <script src="{{ asset('js/theme.js') }}"></script>
 */

const initTheme = () => setTheme(getStoredTheme());
const nextTheme = () => setTheme(getNextTheme(getStoredTheme()));
const getStoredTheme = () => localStorage.getItem('theme') || 'auto';
const setStoredTheme = (theme) => localStorage.setItem('theme', theme);
const getNextTheme = (theme) => ({'light': 'dark', 'dark': 'auto', 'auto': 'light'})[theme];
const activeThemeIcon = (element) => element.querySelector('svg use').setAttribute('href', `#theme-icon-${getStoredTheme()}`)

const setTheme = (theme) => {
    setStoredTheme(theme);

    document.documentElement.classList.remove('light', 'dark', 'auto');

    if (theme === 'auto') {
        document.documentElement.classList.add('auto');
        theme = window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light';
    }

    document.documentElement.classList.add(theme);
};

initTheme();

window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', () => initTheme());