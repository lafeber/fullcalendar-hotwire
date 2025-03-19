import { Controller } from "@hotwired/stimulus";
import { Calendar } from "@fullcalendar/core";
import dayGridPlugin from "@fullcalendar/daygrid";
import timeGridPlugin from "@fullcalendar/timegrid";
import listPlugin from "@fullcalendar/list";
import interactionPlugin from "@fullcalendar/interaction";
import { put } from "@rails/request.js";

export default class extends Controller {
  static targets = [ "popup", "window" ];

  connect() {
    let overlay = this.popupTarget;

    this.calendar = new Calendar(this.windowTarget, {
      plugins: [ dayGridPlugin, timeGridPlugin, listPlugin, interactionPlugin ],
      selectable: true,
      editable: true,
      timeZone: "UTF",
      events: "/events.json",
      initialView: "timeGridWeek",
      headerToolbar: {
        left: "prev,next",
        center: "today",
        right: "dayGridMonth,timeGridWeek,listWeek"
      },
      eventClick: function(info) {
        overlay.src = `/events/${info.event.id}?date=${info.event.startStr}`;
      },
      eventDrop: function(info) {
        put(`/events/${info.event.id}`,
          { body: { event: { start: info.event.startStr, end: info.event.endStr } }}
        );
      },
      select: function(info) {
        overlay.src = `/events/new?event[start]=${info.startStr}&event[end]=${info.endStr}`;
      },
    });

    window.addEventListener("load", () => {
      this.calendar.render();
      this.setView();
    });

    addEventListener("turbo:before-stream-render", (_event) => {
      this.calendar.refetchEvents();
    });

    window.addEventListener("resize", () => {
      this.setView();
    });
  }

  setView() {
    if (window.innerWidth < 800) {
      this.calendar.changeView('listWeek');
    }
  };
}
