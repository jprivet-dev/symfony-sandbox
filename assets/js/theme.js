/*!
 * Inspired by https://github.com/twbs/bootstrap/blob/main/site/static/docs/5.3/assets/js/color-modes.js.
 *
 * To avoid darkmode flickering, insert the following <script> directly into the <head>, before all other scripts:
 *
 *  <script src="{{ asset('js/theme.js') }}"></script>
 */

const nextThemeMap = {
    'light': 'dark',
    'dark': 'auto',
    'auto': 'light',
};

const getStoredTheme = () => localStorage.getItem('theme') || 'auto';
const setStoredTheme = (theme) => localStorage.setItem('theme', theme);
const getNextTheme = (theme) => nextThemeMap[theme];

const setTheme = (theme) => {
    setStoredTheme(theme);
    document.documentElement.classList.remove('light', 'dark', 'auto');
    if (theme === 'auto') {
        document.documentElement.classList.add('auto');
        theme = window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light';
    }
    document.documentElement.classList.add(theme);
};

setTheme(getStoredTheme());

window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', () => setTheme(getStoredTheme()));
