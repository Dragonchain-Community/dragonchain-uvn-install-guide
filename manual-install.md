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

    ```sudo apt update && sudo apt upgrade -y && sudo apt install -y jq openssl xxd snapd```

4. Install microk8s

    ```sudo snap install microk8s --channel=1.18/stable --classic```

5. Alias the kubectl command (if you don’t have normal kubectl installed)
    - If you DO have kubectl already installed (shouldn’t if this is a clean Ubuntu installation), you’ll need to prefix ANY kubectl commands below with “microk8s”, so “microk8s.kubectl get pods -n dragonchain” for example. This should only matter if you already know what you’re doing.

    ```sudo snap alias microk8s.kubectl kubectl```

6. Setup networking stuff (firewall rules)

    ```sudo ufw --force enable && sudo ufw default allow routed && sudo ufw default allow outgoing && sudo ufw allow 22/tcp && sudo ufw allow 30000/tcp && sudo ufw allow in on cni0 && sudo ufw allow out on cni0```

7. Enable microk8s modules

    ```sudo microk8s.enable dns storage helm3```

8. Alias the helm command 

    ```sudo snap alias microk8s.helm3 helm```

9. Install the last microk8s modules

    ```sudo microk8s.enable registry```


# Manual Installation - Dragonchain Installation

1. Create a setup directory (just for organization)

    ```cd ~/ && mkdir setup && cd setup```

2. Download the node prep script

    ```wget https://raw.githubusercontent.com/Dragonchain-Community/dragonchain-uvn-install-guide/master/resources/node-prep.sh```

3. Enable execution on node prep script

    ```chmod +x ./node-prep.sh```

4. Execute the node-prep.sh script

    ```sudo ./node-prep.sh```

5. Remove execution ability on node-prep.sh (we don’t want to accidentally run again later)

    ```chmod -x ./node-prep.sh```

6. Create a new script called "install_dragonchain.sh":
   
   ```nano install_dragonchain.sh```

   then copy/paste the following:

```
# Arbitrary name for your node (recommend all lowercase letters/numbers/dashes, NO spaces)
DRAGONCHAIN_UVN_NODE_NAME="mydragonchain"

# Your Chain ID from the Dragonchain Console Website
DRAGONCHAIN_UVN_INTERNAL_ID="YOURCHAINIDFROMCONSOLE"

# Your Matchmaking Token from the Dragonchain Console Website
DRAGONCHAIN_UVN_REGISTRATION_TOKEN="YOURMATCHMAKINGTOKENFROMCONSOLE"

# Your Endpoint URL including http:// (or https:// if you know SSL has been configured)
DRAGONCHAIN_UVN_ENDPOINT_URL="YOUR ENDPOINT URL"

# The port to install on (30000 is default; only change if you know what you're doing)
DRAGONCHAIN_UVN_NODE_PORT="30000"

# The level of the verification node to install (note the requirements that must be met for level 3 or 4 nodes)
DRAGONCHAIN_NODE_LEVEL="2"

# ++++++++++++++++++ Comment out the next 6 lines after initial install: can then re-run the script to upgrade your node at anytime ++++++++++++++++++++++++
BASE_64_PRIVATE_KEY=$(openssl ecparam -genkey -name secp256k1 | openssl ec -outform DER | tail -c +8 | head -c 32 | xxd -p -c 32 | xxd -r -p | base64)
HMAC_ID=$(tr -dc 'A-Z' < /dev/urandom | fold -w 12 | head -n 1)
HMAC_KEY=$(tr -dc 'A-Za-z0-9' < /dev/urandom | fold -w 43 | head -n 1)
echo "Root HMAC key details: ID: $HMAC_ID | KEY: $HMAC_KEY"
SECRETS_AS_JSON="{\"private-key\":\"$BASE_64_PRIVATE_KEY\",\"hmac-id\":\"$HMAC_ID\",\"hmac-key\":\"$HMAC_KEY\",\"registry-password\":\"\"}"
kubectl create secret generic -n dragonchain "d-$DRAGONCHAIN_UVN_INTERNAL_ID-secrets" --from-literal=SecretString="$SECRETS_AS_JSON"
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

sudo helm upgrade --install $DRAGONCHAIN_UVN_NODE_NAME --namespace dragonchain dragonchain/dragonchain-k8s \
--set global.environment.DRAGONCHAIN_NAME="$DRAGONCHAIN_UVN_NODE_NAME" \
--set global.environment.REGISTRATION_TOKEN="$DRAGONCHAIN_UVN_REGISTRATION_TOKEN" \
--set global.environment.INTERNAL_ID="$DRAGONCHAIN_UVN_INTERNAL_ID" \
--set global.environment.DRAGONCHAIN_ENDPOINT="$DRAGONCHAIN_UVN_ENDPOINT_URL:$DRAGONCHAIN_UVN_NODE_PORT" \
--set-string global.environment.LEVEL=$DRAGONCHAIN_NODE_LEVEL \
--set service.port=$DRAGONCHAIN_UVN_NODE_PORT \
--set dragonchain.storage.spec.storageClassName="microk8s-hostpath" \
--set redis.storage.spec.storageClassName="microk8s-hostpath" \
--set redisearch.storage.spec.storageClassName="microk8s-hostpath"
```

then make the following changes:

   1. Replace “mydragonchain” with a new name if desired (SEE NOTES BELOW)
       - ONLY use lowercase letters, numbers, or dashes
       - Example good names: l2-0 for the first L2 node you create, l2-1 for the second, etc.
   2. Replace "YOURCHAINIDFROMCONSOLE" with the correct value from the console website
   3. Replace "YOURMATCHMAKINGTOKENFROMCONSOLE" with the correct value from the console website
   4. Replace "YOUR ENDPOINT URL" with your address (domain name, IP address)
       - **Don’t forget the http:// here!**
       - Example: http://yourdomainname.com
       - Example: http://12.34.56.78 (replace 12.34.56.78 with your ip address)
   5. If needed (installing multiple nodes, etc.), change the node PORT value
   6. **Change the 2 in DRAGONCHAIN_NODE_LEVEL="2" if installing a level 3 or 4 node**
   7. CTRL + O to save, then Enter to confirm
   8. CTRL + X to exit

#### Let’s install dragonchain!

7. Make the install script executable:

   ```chmod u+x ./install_dragonchain.sh```

8. Run the installation command:    

    ```sudo ./install_dragonchain.sh```
    
    **Copy the line that reads "Root HMAC key details: ...."!! You WILL want this later!**
    
9. Edit the installation script:

   1. `nano install_dragonchain.sh`
   2. Comment out the **six lines** indicated beginning with BASE_64_PRIVATE_KEY by adding a # at the beginning of each line. The edited lines should like like the following after adding the comment indicator:
   ```
   #BASE_64_PRIVATE_KEY=$(openssl ecparam -genkey -name secp256k1 | openssl ec -outform DER | tail -c +8 | head -c 32 | xxd -p -c 32 | xxd -r -p | base64)
   #HMAC_ID=$(tr -dc 'A-Z' < /dev/urandom | fold -w 12 | head -n 1)
   #HMAC_KEY=$(tr -dc 'A-Za-z0-9' < /dev/urandom | fold -w 43 | head -n 1)
   #echo "Root HMAC key details: ID: $HMAC_ID | KEY: $HMAC_KEY"
   #SECRETS_AS_JSON="{\"private-key\":\"$BASE_64_PRIVATE_KEY\",\"hmac-id\":\"$HMAC_ID\",\"hmac-key\":\"$HMAC_KEY\",\"registry-password\":\"\"}"
   #kubectl create secret generic -n dragonchain "d-$DRAGONCHAIN_UVN_INTERNAL_ID-secrets" --from-literal=SecretString="$SECRETS_AS_JSON"
   ```
   3. CTRL + O, press Enter, then CTRL + X to exit

10. Check the status of the pod installations using the following command 
   
      `sudo kubectl get pods -n dragonchain`
    
   - You should see FOUR (4) pods listed with "1/1" in the READY column and "running" in the STATUS column for all 4 pods
   - This step may take several minutes depending on your server; be patient and keep checking with that command!
   - If you see “error” or “crash” statuses, check with dev Slack or TG

11. Get your PUBLIC chain ID and save for later  
    
   - Replace POD_NAME with the pod name that contains "webserver" in the following command
   
      ```sudo kubectl exec -n dragonchain POD_NAME -- python3 -c "from dragonchain.lib.keys import get_public_id; print(get_public_id())"```

   - Save the string of characters that’s spit out

12. Check to see if you’ve successfully registered with Dragon Net (replace CHAIN_PUBLIC_ID with your public ID from the previous step)

    ```curl https://matchmaking.api.dragonchain.com/registration/verify/CHAIN_PUBLIC_ID```
    
	- Output should look something like this:
  
    ```{"success":"Dragon Net configuration is valid and chain is reachable. No issues found."}```

**At this point you should be up and running with your Dragonchain verification node on Dragon Net! Congratulations!**

If you get stuck (status never goes all 1/1s and "running," etc.), check in on Telegram or the developer's Slack. 

Happy noding!
