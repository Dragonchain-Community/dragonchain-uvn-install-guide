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

    ```sudo curl -LO https://git.io/get_helm.sh && sudo bash get_helm.sh --version v2.14.3 && sudo rm get_helm.sh```

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

7. Add the dragonchain repo to helm:

   ```sudo helm repo add dragonchain https://dragonchain-charts.s3.amazonaws.com && sudo helm repo update```

8. Create a new script called "install_dragonchain.sh":
   
   ```nano install_dragonchain.sh```

   then copy/paste the following:

```
# Arbitrary name for your node (recommend all lowercase letters/numbers/dashes, NO spaces)
DRAGONCHAIN_UVN_NODE_NAME="mydragonchain"

# Your Matchmaking Token from the Dragonchain Console Website
DRAGONCHAIN_UVN_REGISTRATION_TOKEN="YOURMATCHMAKINGTOKENFROMCONSOLE"

# Your Chain ID from the Dragonchain Console Website
DRAGONCHAIN_UVN_INTERNAL_ID="YOURCHAINIDFROMCONSOLE"

# Your Endpoint URL including http:// (or https:// if you know SSL has been configured)
DRAGONCHAIN_UVN_ENDPOINT_URL="YOUR ENDPOINT URL"

# The port to install on (30000 is default; only change if you know what you're doing)
DRAGONCHAIN_UVN_NODE_PORT="30000"

sudo helm upgrade --install $DRAGONCHAIN_UVN_NODE_NAME --namespace dragonchain dragonchain/dragonchain-k8s \
--set global.environment.DRAGONCHAIN_NAME="$DRAGONCHAIN_UVN_NODE_NAME" \
--set global.environment.REGISTRATION_TOKEN="$DRAGONCHAIN_UVN_REGISTRATION_TOKEN" \
--set global.environment.INTERNAL_ID="$DRAGONCHAIN_UVN_INTERNAL_ID" \
--set global.environment.DRAGONCHAIN_ENDPOINT="$DRAGONCHAIN_UVN_ENDPOINT_URL:$DRAGONCHAIN_UVN_NODE_PORT" \
--set-string global.environment.LEVEL=2 \
--set service.port=$DRAGONCHAIN_UVN_NODE_PORT \
--set dragonchain.storage.spec.storageClassName="microk8s-hostpath" \
--set redis.storage.spec.storageClassName="microk8s-hostpath" \
--set redisearch.storage.spec.storageClassName="microk8s-hostpath""
```

then make the following changes:

   1. Replace DRAGONCHAIN_HELM_CHART_VERSION with the latest chart version (NOT Dragonchain version)	
   2. Replace “mydragonchain” with a real name (your choice)
       - Recommend all lowercase letters, numbers, or dashes
   3. Replace "YOURMATCHMAKINGTOKENFROMCONSOLE" with the correct value
   4. Replace "YOURCHAINIDFROMCONSOLE" with the correct value
   5. Replace "YOUR ENDPOINT URL" with your address (domain name, IP address)
       - **Don’t forget the http:// here!**
       - Example: http://yourdomainname.com
       - Example: http://12.34.56.78 (replace 12.34.56.78 with your ip address)
   6. CTRL + O to save, then Enter to confirm
   7. CTRL + X to exit

#### Let’s install dragonchain!

9. Make the install script executable:

   ```chmod u+x ./install_dragonchain.sh```

10. Run the installation command:    

    ```sudo ./install_dragonchain.sh```

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
    
```sudo microk8s.enable registry```

If you still have trouble after that, check in on Telegram or the developer's Slack. 

Happy noding!
