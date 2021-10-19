#!/bin/bash
#
#Make telegram-send script and move it to /usr/bin folder
printf "#!/bin/bash
#
# script for sending TEXT/FILE to Telegram
#
# Usage: telegram-send "<text>" or "</path/to/file>"
# ..."folder non-exist" errors may be ignored
#
SEND_ME=$1
CHAT_ID=""
BOT_TOKEN=""
#
# Sending text-message
curl --socks5-basic \
-X POST https://api.telegram.org/bot$BOT_TOKEN/sendMessage \
-d chat_id=$CHAT_ID -d text="$SEND_ME"
#
chmod +x /usr/bin/telegram-send && \
chown root:root /usr/bin/telegram-send
#
# Add script to crontab (Run every 15 minutes)
crontab -l | { cat; echo "*/15 * * * * /$HOME/humanode/notify.sh >/dev/null 2>&1"; } | crontab -
#
# Send test message to Telegram
telegram-send "Working ..."
