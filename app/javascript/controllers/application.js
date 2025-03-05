import { Application } from "@hotwired/stimulus";
import { Modal, Alert } from "tailwindcss-stimulus-components";

const application = Application.start()
application.register('modal', Modal)
application.register('alert', Alert)

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }
