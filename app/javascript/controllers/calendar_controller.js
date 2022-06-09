import { Controller } from "@hotwired/stimulus"
import { Calendar } from '@fullcalendar/core';
import dayGridPlugin from '@fullcalendar/daygrid';
import timeGridPlugin from '@fullcalendar/timegrid';
import listPlugin from '@fullcalendar/list';
import interactionPlugin from '@fullcalendar/interaction';

export default class extends Controller {
  static targets = [ "popup", "window" ];

  connect() {
    let overlay = this.popupTarget;

    this.calendar = new Calendar(this.windowTarget, {
      plugins: [ dayGridPlugin, timeGridPlugin, listPlugin, interactionPlugin ],
      selectable: true,
      timeZone: 'UTC',
      events: '/events.json',
      initialView: 'timeGridWeek',
      headerToolbar: {
        left: 'prev,next',
        center: 'today',
        right: 'dayGridMonth,timeGridWeek,listWeek'
      },
      eventClick: function(info) {
        overlay.src = '/events/' + info.event.id + '/edit';
      },
      select: function(info) {
        overlay.src = '/events/new?start=' + info.startStr + '&end=' + info.endStr;
      },
    });

    window.addEventListener('load', () => {
      this.calendar.render();
    });
  }

  refresh(e) {
    if (e.detail.success) {
      this.calendar.refetchEvents();
    }
  }
}
