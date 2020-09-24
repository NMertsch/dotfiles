#!/usr/bin/env python3
from ical_parse import get_entries, process_todo
import requests
import operator
import os

ICAL_URL = "http://raspi:5232/niklas/29a7b730-4583-745d-658d-839825ae9019/"

if __name__ == "__main__":
    request = requests.get(ICAL_URL)
    if request.status_code == 200:
        open(os.path.expanduser("~/general.ical"), "w").write(request.text)
