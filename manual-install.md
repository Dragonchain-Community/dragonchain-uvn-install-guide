# Manual Installation - Server Setup

After connecting to your server with a program like Git Bash:

1. Make a required change in sysctl.conf

	```sudo nano /etc/sysctl.conf```

	- At the bottom of the file, insert the following line:
		- ```vm.max_map_count=262144```
	- Save by pressing CTRL + O, then Enter to confirm
	- Exit by pressing CTRL + X

2. Force the change on our live system:

    ```sudo sysctl -w vm.max_map_count=262144```

3. Ensure apt is updated and necessary packages are installed

    ```sudo apt update && sudo apt upgrade -y && sudo apt install -y jq openssl xxd```

4. Install microk8s

    ```sudo snap install microk8s --channel=1.15/stable --classic```

5. Alias the kubectl command (if you don’t have normal kubectl installed)
    - If you DO have kubectl already installed (shouldn’t if this is a clean Ubuntu installation), you’ll need to prefix ANY kubectl commands below with “microk8s”, so “microk8s.kubectl get pods -n dragonchain” for example. This should only matter if you already know what you’re doing.

    ```sudo snap alias microk8s.kubectl kubectl```
	

6. Setup networking stuff (firewall rules)

    ```sudo ufw --force enable && sudo ufw default allow routed && sudo ufw default allow outgoing && sudo ufw allow 22/tcp && sudo ufw allow 30000/tcp && sudo ufw allow in on cbr0 && sudo ufw allow out on cbr0```

7. Enable microk8s modules

    ```sudo microk8s.enable dns storage helm```

8. Install helm

    ```curl -LO https://git.io/get_helm.sh && bash get_helm.sh --version v2.14.3 && rm get_helm.sh```

9. Init helm

    ```sudo helm init --history-max 200```
	
  - If you get “tiller not found” error later, do the init again with upgrade, then wait a few minutes for it to do its thing:
  
      ```sudo helm init --history-max 200 --upgrade```

10. Install the last microk8s modules

    ```sudo microk8s.enable registry```


# Manual Installation - Dragonchain Installation

1. Create a setup directory (just for organization)

    ```cd ~/ && mkdir setup && cd setup```

2. Download the chain secrets template

    ```wget http://dragonchain-community.github.io/dragonchain-uvn-install-guide/resources/chainsecrets.sh```

3. Edit the chain secrets script

    ```nano chainsecrets.sh```
  
	- Paste chain secrets script from resources
	- Replace INTERNAL_ID with Chain ID on Dragon Net section of Dragonchain console
	- Copy and save the “d-chain_id-secrets” value (after replacing) for later
	- Save with CTRL + O, then Enter to confirm
	- Exit with CTRL + X

4. Enable execution on chainsecrets script

    ```chmod +x ./chainsecrets.sh```

5. Execute the chainsecrets.sh script

    ```sudo ./chainsecrets.sh```
    
	- Copy and save the line that reads “Root HMAC key details…” for later

6. Remove execution ability on chainsecrets.sh (we don’t want to accidentally run again later)

    ```chmod -x ./chainsecrets.sh```


> Dragonchain Core Docs link for helm URLs:
>
> https://dragonchain-core-docs.dragonchain.com/latest/deployment/links.html


7. Download latest helm chart

    ```wget http://replace-with-latest-helm-CHART-link-from-docs-above```

8. Download latest helm config

    ```wget http://replace-with-latest-helm-VALUES-link-from-docs```

9. Edit the config file:

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
			- Example: http://12.34.56.78:30000 (replace 12.34.56.78 with your ip address)
		5. Change LEVEL to “2”
		6. In the **service:** section, change "port: 30000" to the correct port number (if different)
		7. In the **dragonchain:** section:
			- Change “storageClassName: standard” to “storageClassName: microk8s-hostpath”
			- Change "version: latest" to "version: 4.0.0" (or whatever the latest version of DC is)
		8. In the **redis:** section, change “storageClassName: standard” to “storageClassName: microk8s-hostpath”
		9. In the **redisearch:** section, change “storageClassName: standard” to “storageClassName: microk8s-hostpath”
		10. CTRL + O to save, then Enter to confirm
		11. CTRL + X to exit


#### Let’s install dragonchain!


10. Run the installation command:

    *Replace **my-dragonchain** with a name you like (lowercase & dashes only; remember consistency...; and **DON'T** include the letters "es" in your name) in the following command if you wish*

    ```sudo helm upgrade --install my-dragonchain dragonchain-k8s-1.0.0.tgz --values opensource-config.yaml --namespace dragonchain```

12. Check the status of the pod installations

    ```sudo kubectl get pods -n dragonchain```
    
	- Should see FIVE (5) pods listed with "1/1" in the READY column and "running" in the STATUS column for all 5 pods
		- This step may take several minutes (up to 30 minutes or more) depending on your server; be patient and keep checking with that command!
		- If you see “error” or “crash” statuses, check with dev Slack or TG

13. Get your PUBLIC chain ID and save for later
  - In the following command, replace <POD_NAME_HERE> with the full name of the pod that looks like “mychain-webserver-......” listed after running the previous status command:

    ```sudo kubectl exec -n dragonchain <POD_NAME_HERE> -- python3 -c "from dragonchain.lib.keys import get_public_id; print(get_public_id())"```

- Save the string of characters that’s spit out

13. Check to see if you’ve successfully registered with Dragon Net (replace CHAIN_PUBLIC_ID with your public ID from the previous step)

    ```curl https://matchmaking.api.dragonchain.com/registration/verify/CHAIN_PUBLIC_ID```
    
	- Output should look something like this:
  
    ```{"success":"Dragon Net configuration is valid and chain is reachable. No issues found."}```

14. In case you DIDN’T save your HMAC ID and Key earlier (or ever need to get it again), get your HMAC_ID and HMAC_KEY values from the chain secrets deployed earlier
	
  - Note: **DON’T** re-run the chainsecrets.sh script if you lost your id or key
	- Replace [your-secret-name] with saved value from chainsecrets.sh earlier in the following:
  
    ```sudo kubectl get secret -n dragonchain [your-secret-name] -o json | jq -r .data.SecretString | base64 -d | jq```
    
	- Copy and save the value for hmac-id and hmac-key


**At this point you should be up and running with your Level 2 Dragonchain node on Dragon Net! Congratulations!**

If you get stuck (status never goes all 1/1s and "running," etc.), try running the following commands, then starting over at **Step 4** in this guide:


```sudo microk8s.reset```

```sudo microk8s.enable dns storage helm```

```sudo helm init --history-max 200```
    
*WAIT 30 SECONDS*
    
```sudo microk8s.enable registry ingress fluentd```

If you still have trouble after that, check in on Telegram or the developer's Slack. 

Happy noding!
