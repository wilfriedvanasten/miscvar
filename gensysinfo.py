#!/usr/bin/env python3
import psutil
import os
import time
import math

blocks = ['▁', '▂', '▃', '▄', '▅', '▆', '▇', '█']

def create_bar(filled):
    if filled > 1:
        low = str(int(filled))
        high = str(int(filled + 1))
        filled = filled - int(filled)
    filled = int(filled * 100)
    if filled < 50:
        color = "green"
    elif filled < 80:
        color = "yellow"
    else:
        color = "red"
    block = math.floor(filled / (100 / 7) + 0.5)
    bar = '#[fg=' + color + ']▕'
    bar += blocks[block]
    bar += '▏'
    if filled >= 100:
        bar += str(filled)
    else:
        bar += "{0:2}%".format(filled)
    bar += '#[fg=default]'
    return bar


while True:
    meminfo = psutil.virtual_memory()
    numcpus = psutil.cpu_count()

    with open(os.path.expanduser("~/.memblock"), "w") as memblock:
        memblock.write(create_bar((meminfo.total - meminfo.available) / meminfo.total))
    with open(os.path.expanduser("~/.cpuutilblock"), "w") as cpuutilblock:
        cpuutilblock.write(create_bar(psutil.cpu_percent() / 100))
    time.sleep(20)
