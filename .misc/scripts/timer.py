#!/usr/bin/env python

import os
from sys import argv
from time import sleep
import datetime as dt


def check_play_installed():
    if os.system('which play >/dev/null') != 0:
        os.system('notify-send "Program play missing" "Please run sudo apt install sox" >/dev/null')
        return False
    return True


def beep(duration: int = 1, frequency: int = 440) -> None:
    os.system(f"play -nq -t alsa synth {duration} sine {frequency}")


def alarm(repeats: int = 5) -> None:
    for _ in range(repeats):
        beep(0.5)
        sleep(0.5)

def main():
    if not check_play_installed():
        return

    args = argv[1:]
    if len(args) == 0 or len(args) > 3:
        print("Expected 1 to 3 numbers ([hours] [minutes] seconds)")
        return

    wait_seconds = 0
    interval_seconds = 1

    for val in args[::-1]:
        wait_seconds += int(val) * interval_seconds
        interval_seconds *= 60

    timeformat_str = "%H:%M:%S"
    now = dt.datetime.now()
    now_str = now.strftime(timeformat_str)
    end = now + dt.timedelta(seconds=wait_seconds)
    end_str = end.strftime(timeformat_str)

    print(f"{now_str} - alarm will go off in {wait_seconds} seconds "
          f"(at {end_str})")

    try:
        sleep(wait_seconds)
        alarm()
    except KeyboardInterrupt:
        print()  # so that "^C" does not interfere with the prompt


if __name__ == "__main__":
    main()
