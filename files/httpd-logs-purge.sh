#!/bin/bash

# inclusione libreria
. $(dirname $(realpath $0))/../lib/bash/softec-common.sh || exit

# inclusione configurazione
include_conf

# Compress files older than 2 days
$FIND $LOGPATH -type f -mtime +$COMPRESS_DAYS -not -name "*bz2" -exec $BZIP2 '{}' \;

# Remove files older than $REMOVE_DAYS days
$FIND $LOGPATH -type f -mtime +$REMOVE_DAYS -name "*bz2" -exec $RM '{}' \;
