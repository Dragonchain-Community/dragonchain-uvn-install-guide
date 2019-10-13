## Automatic Installation Guide

1. Make sure you have the required information gathered
    - Your Chain ID and Matchmaking Token from the Dragonchain Console
      - See the lesson on General Preparation to learn how to register your chain if you haven't    
    - The “endpoint URL” for your installation:
      - This will either be a domain name (http://example.com) or
      - Your server’s public IP address (http://12.34.56.78)
        - If following the Linode tutorial, your endpoint will be http://yourserveripaddress
    - The port number to use on your server
      - Unless you KNOW you need a different port, just use 30000 here
  
2. Connect to your VPS or VM using Git Bash or your terminal
    - If following the Linode tutorial, copy and paste the "ssh root@..." command you saved from the Networking tab
    
3. Download the automatic installation script (copy and paste the following command into Git Bash or your terminal)

    ```wget https://raw.githubusercontent.com/Dragonchain-Community/dragonchain-uvn-installer/release-v1.5-dragon-4.0.0/install_dragonchain_uvn.sh```
    
4. Make the script "runnable" (copy and paste the following command into Git Bash or your terminal)

    ```chmod u+x ./install_dragonchain_uvn.sh```

5. Run the installation script (copy and paste the following command into Git Bash or your terminal)

    ``` sudo ./install_dragonchain_uvn.sh```
    
6. Follow the prompts to input the information gathered in step 1.

7. Watch your Dragonchain node come alive!

If you have any trouble with this installation process, join us on the Dragonchain telegram and ask for assistance. We'll be around and happy to help!

Happy noding!
