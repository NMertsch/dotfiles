#!/usr/bin/env python3
import operator
from datetime import datetime, timedelta
from sys import argv
import os

from ical_parse import get_entries, process_event

def print_event(event):
    if event.DTSTART.time() == event.DTEND.time() and event.DTSTART.hour == 0 and event.DTEND.minute == 0:
        dt_format_out = "%d.%m.%Y"
    else:
        dt_format_out = "%d.%m.%Y  %H:%M"
    print(f"  {datetime.strftime(event.DTSTART, dt_format_out)}")
    print(f"- {datetime.strftime(event.DTEND, dt_format_out)}")
    print(f"{event.SUMMARY.center(18)}")

if __name__ == "__main__":
    ical_str = open(os.path.expanduser("~/general.ical")).read()
    todos, events = get_entries(ical_str)
    events.sort(key=operator.attrgetter("DTSTART"))
    events = [event for event in events if event.DTEND.date() >= datetime.now().date()]

    if len(argv) == 1:
        num_events = 5
    else:
        num_events = int(argv[1])

    print_event(events[0])
    for event in events[1:num_events]:
        print()
        print_event(event)
