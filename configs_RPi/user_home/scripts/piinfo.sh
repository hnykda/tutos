#!/usr/bin/bash
vcgencmd measure_clock arm
vcgencmd measure_temp
vcgencmd get_config int
vcgencmd get_mem arm && vcgencmd get_mem gpu

for id in core sdram_c sdram_i sdram_p ; do \
    echo -e "$id:\t$(vcgencmd measure_volts $id)" ; \
done
