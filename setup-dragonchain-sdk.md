## Let’s Play with the Dragonchain SDK

**Note: Don’t do this ON your dragonchain server!**

It probably WOULDN'T hurt, but why mess with something that’s working? :smile:

Off we go:

1. Make sure nodejs is installed

    ```sudo apt update && sudo apt install npm```
    
2. Create our credentials file

- Insert YOUR credentials gathered from the installation process in the sample credential file
- Follow the instructions on the Dragonchain SDK website for where to put it!
  - For a linux box, it’s ~/.dragonchain/credentials
  - See more here:
    - https://node-sdk-docs.dragonchain.com/latest/index.html
    
3. Install the dragonchain sdk:

    ```sudo npm i dragonchain-sdk --save```

4. Create the queryblocks.js script provided in the resources (no changes needed)

5. Run the queryblocks.js script:

    ```node queryblocks.js```

6. Profit.
