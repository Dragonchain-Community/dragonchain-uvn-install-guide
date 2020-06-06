# Manual Upgrade 

This guide is for manually upgrading a **running** Dragonchain node. After connecting to your server with a program like Git Bash:

*Note: this guide assumes you followed the updated manual installation process to begin with. If you do not currently have a file named "install_dragonchain.sh" in your setup folder, please follow Step 6 and Step 9 under ["Manual Installation"](https://github.com/Dragonchain-Community/dragonchain-uvn-install-guide/blob/master/manual-install.md#manual-installation---dragonchain-installation) then continue here.*

1. Change to the setup directory

   ```cd ~/setup```
   
2. Update the helm repo to get the latest Dragonchain chart version

   ```sudo helm repo add dragonchain https://dragonchain-charts.s3.amazonaws.com && sudo helm repo update```
   
3. Run the install script again (it will automatically upgrade if a previous installation exists)

   ```sudo ./install_dragonchain.sh```

4. Check the status of the pod installations

    ```sudo kubectl get pods -n dragonchain```
    
	- Should see FOUR (4) pods listed with "1/1" in the READY column and "running" in the STATUS column for all 5 pods
		- This step may take several minutes (up to 30 minutes or more) depending on your server; be patient and keep checking with that command!
		- If you see “error” or “crash” statuses, check with dev Slack or TG

5. Get your PUBLIC chain ID and save for later (**if you don't already have it**)
	- In the following command, replace <POD_NAME_HERE> with the full name of the pod that looks like “mychain-webserver-......” listed after running the previous status command:

    ```sudo kubectl exec -n dragonchain <POD_NAME_HERE> -- python3 -c "from dragonchain.lib.keys import get_public_id; print(get_public_id())"```

	- Save the string of characters that’s spit out

6. Check to see if you’ve successfully registered with Dragon Net (replace CHAIN_PUBLIC_ID with your public ID from the previous step)

    ```curl https://matchmaking.api.dragonchain.com/registration/verify/CHAIN_PUBLIC_ID```
    
	- Output should look something like this:
  
    ```{"success":"Dragon Net configuration is valid and chain is reachable. No issues found."}```

**At this point you should be up and running with your Level 2 Dragonchain node on Dragon Net! Congratulations!**

If you have trouble, check in on Telegram or the developer's Slack. 

Happy noding!
