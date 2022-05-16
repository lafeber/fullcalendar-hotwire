import { Controller } from "@hotwired/stimulus"
import { Calendar } from '@fullcalendar/core';
import dayGridPlugin from '@fullcalendar/daygrid';
import timeGridPlugin from '@fullcalendar/timegrid';
import listPlugin from '@fullcalendar/list';
import interactionPlugin from '@fullcalendar/interaction';

export default class extends Controller {
  connect() {
    let calendar = new Calendar(this.element, {
      plugins: [ dayGridPlugin, timeGridPlugin, listPlugin, interactionPlugin ],
      selectable: true,
      timeZone: 'UTC',
      slotLabelFormat: {hour: 'numeric', minute: '2-digit', hour12: false},
      height: '800px',
      events: '/events.json',
      initialView: 'timeGridWeek',
      headerToolbar: {
        left: 'prev,next',
        center: 'today',
        right: 'dayGridMonth,timeGridWeek,listWeek'
      },
      eventClick: function(info) {
        document.querySelector("#modal").src = '/events/' + info.event.id + '/edit';
      },
      select: function(info) {
        document.querySelector("#modal").src = '/events/new?start=' + info.startStr + '&end=' + info.endStr;
      },
    });
    calendar.render();
  }
}
