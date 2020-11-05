#!/bin/bash
OF=/data/backup/$(date +%Y%m%d)
rsync -aAXv / --exclude={"/bin/","/boot/","/etc/","/dev/*","/lib/","/lib64/","/opt/","/root/","/sbin/","/srv/","/usr/","/var/","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found""/data"} $OF