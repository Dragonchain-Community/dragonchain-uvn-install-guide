## How to get your Dragonchain node credentials: the easy way

It's a pretty common issue that you need to recover your credentials (public ID, access ID and key, etc.) from your running node.

To make things easier, ssh back into your node's server and run the commands below! This guide and script should work for any Dragonchain node (whether you installed from the automatic script or the manual process in this guide or rolled your own).

1. **If you haven't already done this step previously**, run the following command:

    ```wget https://raw.githubusercontent.com/Dragonchain-Community/dragonchain-uvn-credentials/master/fetch-dragonchain-credentials.sh && chmod u+x ./fetch-dragonchain-credentials.sh```

2. Run the following command to retrieve your credentials:

    ```./fetch-dragonchain-credentials.sh```

3. Bask in the glory of your now-revealed credentials. :)
