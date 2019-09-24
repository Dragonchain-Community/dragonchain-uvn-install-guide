# Manual Upgrade 

This guide is for manually uprading a **running** Dragonchain node. After connecting to your server with a program like Git Bash:

> Dragonchain Core Docs link for helm URLs:
>
> https://dragonchain-core-docs.dragonchain.com/latest/deployment/links.html


1. Download latest helm chart

    ```wget http://replace-with-latest-helm-CHART-link-from-docs-above```

2. Download latest helm config

    ```wget http://replace-with-latest-helm-VALUES-link-from-docs```

3. Edit the config file:

    ```nano opensource-config.yaml```
    
	- Make the following changes in the opensource-config.yaml resource file:
		1. Replace “ArbitraryName” with a real name (your choice)
			- Recommend consistency and an all lowercase name (dashes are okay)
			- DON'T include the letters "es" together in your name (don't ask)
		2. Put your MATCHMAKING TOKEN in the quotes on the REGISTRATION_TOKEN line
		3. Put your CHAIN ID in the quotes on the INTERNAL_ID line
		4. Replace the address in DRAGONCHAIN_ENDPOINT with your address (domain name, IP address) and port that can be reached from the outside world
			- **Don’t forget the http:// here!**
			- Example: http://yourdomainname.com:30000
			- Example: http://12.34.56.78:3000 (replace 12.34.56.78 with your ip address)
		5. Change LEVEL to “2”
		6. In the **dragonchain:** section:
			- Change “storageClassName: standard” to “storageClassName: microk8s-hostpath”
			- Change "version: latest" to "version: 4.0.0" (or whatever the latest version of DC is)
		7. In the **redis:** section, change “storageClassName: standard” to “storageClassName: microk8s-hostpath”
		8. In the **redisearch:** section, change “storageClassName: standard” to “storageClassName: microk8s-hostpath”
		9. CTRL + O to save, then Enter to confirm
		10. CTRL + X to exit


#### Let’s upgrade dragonchain!


4. Run the installation command:

    Replace **my-dragonchain** with the **name you used when originally installing dragonchain** in the following command. 
    
    **If you no longer remember the name you used, you can run `sudo helm list` to find the name.**

    ```sudo helm upgrade --install my-dragonchain dragonchain-k8s-1.0.0.tgz --values opensource-config.yaml --namespace dragonchain```

5. Check the status of the pod installations

    ```sudo kubectl get pods -n dragonchain```
    
	- Should see FIVE (5) pods listed with "1/1" in the READY column and "running" in the STATUS column for all 5 pods
		- This step may take several minutes (up to 30 minutes or more) depending on your server; be patient and keep checking with that command!
		- If you see “error” or “crash” statuses, check with dev Slack or TG

6. Get your PUBLIC chain ID and save for later (**if you don't already have it**)
  - In the following command, replace <POD_NAME_HERE> with the full name of the pod that looks like “mychain-webserver-......” listed after running the previous status command:

    ```sudo kubectl exec -n dragonchain <POD_NAME_HERE> -- python3 -c "from dragonchain.lib.keys import get_public_id; print(get_public_id())"```

- Save the string of characters that’s spit out

7. Check to see if you’ve successfully registered with Dragon Net (replace CHAIN_PUBLIC_ID with your public ID from the previous step)

    ```curl https://matchmaking.api.dragonchain.com/registration/verify/CHAIN_PUBLIC_ID```
    
	- Output should look something like this:
  
    ```{"success":"Dragon Net configuration is valid and chain is reachable. No issues found."}```

**At this point you should be up and running with your Level 2 Dragonchain node on Dragon Net! Congratulations!**

If you have trouble, check in on Telegram or the developer's Slack. 

Happy noding!
