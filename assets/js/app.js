// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
import topbar from "../vendor/topbar"

// Define the theme switcher hook
const Hooks = {}

Hooks.ThemeSwitcher = {
  mounted() {
    console.log("Its mount")
    const form = document.querySelector('#backpex-theme-selector-form')
    const storedTheme = window.localStorage.getItem('backpexTheme')

    // Marking current theme as active
    if (storedTheme != null) {

    console.log("Its mount: strodTheme")
      const activeThemeRadio = form.querySelector(
        `input[name='theme-selector'][value='${storedTheme}']`
      )
      if (activeThemeRadio) {
        activeThemeRadio.checked = true
      }
    }

    window.addEventListener('backpex:theme-change', this.handleThemeChange.bind(this))
  },

  async handleThemeChange() {
    console.log("theme change")
    const form = document.querySelector('#backpex-theme-selector-form')
    const csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute('content')
    const cookiePath = form.dataset.cookiePath
    console.log("cookiePath ", cookiePath)
    const selectedTheme = form.querySelector(
      'input[name="theme-selector"]:checked'
    )

    if (selectedTheme) {
      window.localStorage.setItem('backpexTheme', selectedTheme.value)
      document.documentElement.setAttribute(
        'data-theme',
        selectedTheme.value
      )
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

  setStoredTheme() {
    const storedTheme = window.localStorage.getItem('backpexTheme')
        console.log("hhhIIIi")
        console.log(storedTheme)

    if (storedTheme != null) {

        console.log("Not null")
      document.documentElement.setAttribute('data-theme', storedTheme)
    }
  },

  destroyed() {
    window.removeEventListener('backpex:theme-change', this.handleThemeChange.bind(this))
  }
}



let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2500,
  params: {_csrf_token: csrfToken},
  hooks: Hooks
})

// Show progress bar on live navigation and form submits
topbar.config({barColors: {0: "#29d"}, shadowColor: "rgba(0, 0, 0, .3)"})
window.addEventListener("phx:page-loading-start", _info => topbar.show(300))
window.addEventListener("phx:page-loading-stop", _info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket


Hooks.ThemeSwitcher.setStoredTheme()
