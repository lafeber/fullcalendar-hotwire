import { Application } from "@hotwired/stimulus"

const application = Application.start()

import { Modal } from "tailwindcss-stimulus-components"
application.register('modal', Modal)

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }
