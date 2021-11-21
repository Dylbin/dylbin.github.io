#!/bin/sh
echo "start install deb">/tmp/pangu.log
debs=(/var/root/Library/pangu/*.deb)
if [[ ${#debs[@]} -ne 0 && -f ${debs[0]} ]]; then
dpkg -i "${debs[@]}" 2>/tmp/dpkg.log 1>&2
rm -f "${debs[@]}"
fi
echo "finish loop" >> /tmp/pangu.log
