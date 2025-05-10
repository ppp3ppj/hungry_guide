// js/hooks/theme_selector.js

export default {
  mounted () {
    console.log("ThemeSelector hook mounted!")
    const form = document.querySelector('#backpex-theme-selector-form')
    const storedTheme = window.localStorage.getItem('backpexTheme')

    // Marking current theme as active when the component is mounted
    if (storedTheme != null) {
      const activeThemeRadio = form.querySelector(
        `input[name='theme-selector'][value='${storedTheme}']`
      )
      if (activeThemeRadio) {
        activeThemeRadio.checked = true
      }
    }

    // Listen for theme change events
    window.addEventListener('backpex:theme-change', this.handleThemeChange.bind(this))
  },

  // Handle the theme change event, store it and update the server session
  async handleThemeChange () {
        console.log("change")
    const form = document.querySelector('#backpex-theme-selector-form')
    const csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute('content')
    const cookiePath = form.dataset.cookiePath
    const selectedTheme = form.querySelector(
      'input[name="theme-selector"]:checked'
    )

    if (selectedTheme) {
      window.localStorage.setItem('theme', selectedTheme.value)
      document.documentElement.setAttribute('data-theme', selectedTheme.value)

      console.log("selected theme: ", selectedTheme.value)
      console.log("cookie path: ", cookiePath)
      await fetch(cookiePath, {
        body: `select_theme=${selectedTheme.value}`,
        method: 'POST',
        headers: {
          'Content-type': 'application/x-www-form-urlencoded',
          'x-csrf-token': csrfToken
        }
      })
    }
  },

  // Set the stored theme when the LiveView is mounted
  setStoredTheme () {
    console.log("settt")
    const storedTheme = window.localStorage.getItem('theme')

    if (storedTheme != null) {
      document.documentElement.setAttribute('data-theme', storedTheme)
    }
  },

  // Clean up event listeners when the component is destroyed
  destroyed () {
    window.removeEventListener('backpex:theme-change', this.handleThemeChange.bind(this))
  }
}

