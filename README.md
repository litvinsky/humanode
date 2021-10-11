INSTALL AS A DAEMON
Prerequisites:
1. You should install humanode as in original manual (https://testnet.humanode.io/run-your-own-humanode)
2. Humanode files must be in /your_home_directory/humanode
3. Ngrok binary file should be located in /usr/bin directory

To install humanode and ngrok as a daemon you shoult to edit installer.sh file and add your own variables:
NAME= Your node name, for example "SuPerValiDat0r"
RPC_URL= Your Ngrok url, you can see it on the ngrok website (https://dashboard.ngrok.com/endpoints/status)
NGROK_TOKEN= Your Ngrok authentification token

Then make this file executable (run a command chmod +x installer.sh) and run it!

TELEGRAM NOTIFICATIONS
Prerequisites: 
Humanode and Ngrok should run as a services (daemons)

You should to create your own telegram bot:
Just open Telegram, find @BotFather and type /start. Then follow instructions to create bot and get token to access the HTTP API.
Create a new group in Telegram and add your bot as a member. So your bot could send messages to the group.
In order to get Group Id, first, post any message to the Group. Then use this link template to get Group Id:
https://api.telegram.org/bot<YourBOTToken>/getUpdates

Here is a response example:

{
  "ok":true,
  "result": [
    {
      "update_id":123,
      "channel_post": {
        "message_id":48,
        "chat": {
          "id":-123123123, // this is your group id
          "title":"Notifications",
          "type":"group"
        },
        "date":1574485277,
        "text":"test"
      }
    }
  ]
}

1. Put notify.sh to your humanode directory (it should be $HOME/humanode) and make him executable
2. Edit telegram-notify.sh and add your own variables:
GROUP_ID="TELEGRAM_GROUP_ID"
BOT_TOKEN="YOUR_TELEGRAM_TOKEN"
3. Make this file executable (run a command chmod +x telegram-notify.sh) and run it!
4. Script will check your humanode logs every 15 minutes
