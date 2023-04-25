# PlayCoin Manager Portable

Download the latest version here:
https://github.com/BigRedBrent/PlayCoinManagerPortable/raw/main/PlayCoinManagerPortable.zip
___

PlayCoin Manager Portable uses a command line argument that is built into the PlayCoin Manager, to store the settings and coin files in the same folder as this script, instead of in your computer's local user settings folder.

This allows you to store your coins and run the manager from a single location, such as a USB flash drive.  
You can then copy the "PlayCoin Manager Portable" folder to multiple safe locations or flash drives to make backup copies of all of your coins.
___

This script only works with the windows version of PlayCoin Manager.

This script will attempt to find existing PlayCoin Manager files, and copy them into this portable folder.  
If copied, the original files will not be altered in any way.

You may find the settings and coin files in the "Settings" folder.  
To start with a new blank copy of settings, select no when prompted to copy existing settings.  
To remove any existing settings files that have been copied, you will have to find and delete them yourself.  
Existing settings files are located in a directory that looks like this: "C:\Users\USER\playcoin_manager"

To use the locally installed PlayCoin Manager, select no when prompted to copy the PlayCoin Manager.  
To copy the PlayCoin Manager to the portable folder after originally selecting not to,  
simply delete the "PlayCoin Manager" folder and run this script again.

After the PlayCoin Manager is installed, run: "Start PlayCoin Manager Portable.cmd"
