## Let’s Play with the Dragonchain SDK

**Note: Don’t do this ON your dragonchain server!**

It probably WOULDN'T hurt, but why mess with something that’s working? :smile:

Off we go:

1. Make sure nodejs is installed

    ```sudo apt update && sudo apt install npm```
    
2. Download and edit our credentials file

  - Insert YOUR credentials gathered from the installation process in the sample credential file
  - Follow the instructions on the Dragonchain SDK website for where to put it!
    - For a linux box, it’s ~/.dragonchain/credentials
    - See more here:
      - https://node-sdk-docs.dragonchain.com/latest/index.html
  
    - If downloading directly, [click here](http://dragonchain-community.github.io/dragonchain-uvn-install-guide/resources/credentials).
  
    - If downloading from the command line:
  
        ```wget http://dragonchain-community.github.io/dragonchain-uvn-install-guide/resources/credentials```
    
  - Make edits, then CTRL+O to save, CTRL+X to exit
    - Note that your endpoint URL should be the FULL url and port that you used when installing your node
    - Example for Linode users: http://12.34.56.78:30000 (replacing 12.34.56.78 with your actual IP)
    
3. Install the dragonchain sdk:

    ```sudo npm i dragonchain-sdk --save```

4. Create the queryblocks.js script provided in the resources (no changes needed)

5. Download the queryblocks.js script:

    - If downloading directly, [click here](http://dragonchain-community.github.io/dragonchain-uvn-install-guide/resources/queryblocks.js).
  
    - If downloading from the command line:
  
        ```wget http://dragonchain-community.github.io/dragonchain-uvn-install-guide/resources/queryblocks.js```
    
5. Run the queryblocks.js script:

    ```node queryblocks.js```

6. Profit.
