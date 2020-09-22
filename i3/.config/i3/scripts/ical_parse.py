from collections import defaultdict, namedtuple
from datetime import datetime as dt

dt_format_in = "%Y%m%dT%H%M%S"
t_format_in = "%Y%m%d"

Event = namedtuple("Event", ["SUMMARY", "DTSTART", "DTEND"])
TODO = namedtuple("TODO", ["SUMMARY"])

def process_date_entry(date_str):
    if date_str.endswith("Z"):
        date_str = date_str[:-1]
    if date_str.isnumeric():
        return dt.strptime(date_str, t_format_in)
    return dt.strptime(date_str, dt_format_in)

def process_event(event):
    short_event = dict()
    for key, value in event.items():
        if key.startswith("DTSTART"):
            short_event["DTSTART"] = process_date_entry(value)
        if key.startswith("DTEND"):
            short_event["DTEND"] = process_date_entry(value)
        if key == "SUMMARY":
            short_event["SUMMARY"] = value
    return Event(short_event["SUMMARY"], short_event["DTSTART"], short_event["DTEND"])

def process_todo(todo):
    short_todo = dict()
    for key, value in todo.items():
        if key == "SUMMARY":
            short_todo["SUMMARY"] = value
    return TODO(short_todo["SUMMARY"])

def get_entries(ical_str):
    linesep = "\r\n" if "\r\n" in ical_str else "\n"
    in_header = True
    in_alarm = False
    current_entry_type = None
    entries = defaultdict(list)
    for line in ical_str.split(linesep):
        line = line.strip().replace("\\", "")
        if not line:
            continue

        if line == "END:VCALENDAR":
            break

        if line == "END:VTIMEZONE":
            in_header = False
            continue

        if line == "BEGIN:VALARM":
            in_alarm = True
            continue
        if line == "END:VALARM":
            in_alarm = False
            continue

        if in_header or in_alarm:
            continue

        if line.startswith("BEGIN:"):
            entry = {}
            current_entry_type = line[6:]
            continue

        if line.startswith("END:"):
            entries[current_entry_type].append(entry)
            continue

        key, value = line.split(":", maxsplit=1)
        entry[key] = value

    todos = [process_todo(entry) for entry in entries["VTODO"]]
    events = [process_event(entry) for entry in entries["VEVENT"]]
    return todos, events
