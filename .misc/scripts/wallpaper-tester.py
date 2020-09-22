#!/usr/bin/env python

import os
import sys

if __name__ == "__main__":
    argv = sys.argv[1:]
    if len(argv) == 0:
        raise ValueError("No file or directory given")
    if len(argv) == 1:
        if os.path.isdir(argv[0]):
            img_files = [f"{argv[0]}/{file}" for file in os.listdir(argv[0]) if os.path.isfile(f"{argv[0]}/{file}")]
        elif os.path.isfile(argv[0]):
            img_files = [argv[0]]
        else:
            raise ValueError(f"No such file or directory: '{argv[0]}'")
    else:
        img_files = argv

    for i, file in enumerate(img_files, start=1):
        try:
            os.system(f"feh --bg-fill {file}")
            answer = input(f"File {i}/{len(img_files)}: Delete (y/n)? ")
            if answer == "y":
                os.remove(file)
        except KeyboardInterrupt:
            print()
            exit()
