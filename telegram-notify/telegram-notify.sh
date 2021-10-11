#!/bin/bash

printf "#!/bin/bash

GROUP_ID="TELEGRAM_GROUP_ID"
BOT_TOKEN="YOUR_TELEGRAM_TOKEN"

curl -s --data "text=$1" --data "chat_id=$GROUP_ID" 'https://api.telegram.org/bot'$BOT_TOKEN'/sendMessage' > /dev/null" > /usr/bin/telegram-send

chmod +x /usr/bin/telegram-send && \
chown root:root /usr/bin/telegram-send
crontab -l | { cat; echo "*/15 * * * * /$HOME/humanode/humanode-notify.sh >/dev/null 2>&1"; } | crontab -
telegram-send "Test!"
