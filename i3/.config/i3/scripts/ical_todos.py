#!/usr/bin/env python3
from ical_parse import get_entries, process_todo
import requests
import operator
import os


if __name__ == "__main__":
    ical_str = open(os.path.expanduser("~/general.ical")).read()
    todos, events = get_entries(ical_str)
    todos.sort(key=operator.attrgetter("SUMMARY"))
    for todo in todos:
        print(todo.SUMMARY)
