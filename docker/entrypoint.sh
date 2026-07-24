#!/bin/bash
set -e

mkdir -p \
 /hercules/config \
 /hercules/dasd \
 /hercules/tapes \
 /hercules/cards \
 /hercules/printers \
 /hercules/logs \
 /hercules/spool \
 /hercules/tmp


exec hercules \
    -f /hercules/config/hercules.cnf
