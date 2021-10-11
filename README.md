<!-- #######  YAY, I AM THE SOURCE EDITOR! #########-->
<p><strong>INSTALL AS A DAEMON</strong></p>
<p><br />Prerequisites:<br />1. You should install humanode as in original manual (<a href="https://testnet.humanode.io/run-your-own-humanode">https://testnet.humanode.io/run-your-own-humanode</a>)<br />2. Humanode files must be in /your_home_directory/humanode<br />3. Ngrok binary file should be located in /usr/bin directory</p>
<p>To install humanode and ngrok as a daemon you shoult to edit installer.sh file and add your own variables:<br />NAME= Your node name, for example "SuPerValiDat0r"<br />RPC_URL= Your Ngrok url, you can see it on the ngrok website (<a href="https://dashboard.ngrok.com/endpoints/status">https://dashboard.ngrok.com/endpoints/status</a>)<br />NGROK_TOKEN= Your Ngrok authentification token</p>
<p>Then make this file executable (run a command chmod +x installer.sh) and run it!</p>
<p>&nbsp;</p>
<p><strong>TELEGRAM NOTIFICATIONS</strong></p>
<p><br />Prerequisites: <br />Humanode and Ngrok should run as a services (daemons)</p>
<p>You should to create your own telegram bot:<br />Just open Telegram, find @BotFather and type /start. Then follow instructions to create bot and get token to access the HTTP API.<br />Create a new group in Telegram and add your bot as a member. So your bot could send messages to the group.<br />In order to get Group Id, first, post any message to the Group. Then use this link template to get Group Id:<br />https://api.telegram.org/bot&lt;YourBOTToken&gt;/getUpdates</p>
<p>Here is a response example:</p>
<p>{<br />"ok":true,<br />"result": [<br />{<br />"update_id":123,<br />"channel_post": {<br />"message_id":48,<br />"chat": {<br />"id":-123123123, // this is your group id<br />"title":"Notifications",<br />"type":"group"<br />},<br />"date":1574485277,<br />"text":"test"<br />&nbsp; &nbsp;}<br />&nbsp; }<br />&nbsp;]<br />}</p>
<p>1. Put notify.sh to your humanode directory (it should be $HOME/humanode) and make him executable<br />2. Edit telegram-notify.sh and add your own variables:<br />GROUP_ID="TELEGRAM_GROUP_ID"<br />BOT_TOKEN="YOUR_TELEGRAM_TOKEN"<br />3. Make this file executable (run a command chmod +x telegram-notify.sh) and run it!<br />4. Script will check your humanode logs every 15 minutes</p>
