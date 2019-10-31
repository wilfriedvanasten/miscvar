#!/usr/bin/env python
import psutil
import os
import time

def create_bar(filled):
    low = '.'
    high = '|'
    if filled > 1:
        low = str(int(filled))
        high = str(int(filled + 1))
        filled = filled - int(filled)
    filled = int(filled * 10)
    if filled < 5:
        color = "green"
    elif filled < 8:
        color = "yellow"
    else:
        color = "red"
    bar = '#[fg=' + color + ']['
    bar += high * filled
    bar += low * (10 - filled)
    bar += ']#[fg=default]'
    return bar


while True:
    meminfo = psutil.virtual_memory()
    numcpus = psutil.cpu_count()
    load, _, _, = psutil.getloadavg()

    with open(os.path.expanduser("~/.memblock"), "w") as memblock:
        memblock.write(create_bar((meminfo.total - meminfo.available) / meminfo.total))
    with open(os.path.expanduser("~/.cpuutilblock"), "w") as cpuutilblock:
        cpuutilblock.write(create_bar(load / numcpus))
    time.sleep(20)
