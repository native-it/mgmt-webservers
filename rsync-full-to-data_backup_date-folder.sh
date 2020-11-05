#!/bin/bash
OF=/data/backup/full/$(date +%Y%m%d)
rsync -aAXv / --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found","/data"} $OF