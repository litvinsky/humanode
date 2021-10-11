#!/bin/bash

#Make telegram-send script and move it to /usr/bin folder
printf "#!/bin/bash
GROUP_ID="TELEGRAM_GROUP_ID"
BOT_TOKEN="YOUR_TELEGRAM_TOKEN"
curl -s --data "text=$1" --data "chat_id=$GROUP_ID" 'https://api.telegram.org/bot'$BOT_TOKEN'/sendMessage' > /dev/null" > /usr/bin/telegram-send
chmod +x /usr/bin/telegram-send && \
chown root:root /usr/bin/telegram-send

#Add script to crontab (Run every 15 minutes)
crontab -l | { cat; echo "*/15 * * * * /$HOME/humanode/notify.sh >/dev/null 2>&1"; } | crontab -

#Send test message to Telegram
telegram-send "Test!"
