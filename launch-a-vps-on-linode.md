## Launching and Logging Into Your First Linode Ubuntu VPS

 1. Sign up for a Linode account at https://www.linode.com/
 
 2. Click "Create > Linode" once you’re able to get to your dashboard
 
 3. Choose "Ubuntu 19.04" for the Distribution
 
 4. Select a Region to deploy your VPS to
 
 5. Select the "Linode 8GB" plan (2 CPU, 8GB RAM)
    - You CAN choose the "Linode 4GB" plan, but you may have trouble; I highly recommend 8GB for the current release of Dragonchain
 
 6. Enter a "root password" 
    - Make this a STRONG password; anyone who cracks it gets 100% access to your entire VPS
   
 7. Click the blue Create button after confirming your details
 
 8. Wait while Linode creates your new VPS, then continue
 
 9. Click "Launch Console" OR Download Git for Windows and use Git BASH 
    - Download here: https://gitforwindows.org/
   
 10. Go to the "Networking" tab
    - Record your IP address: this will be your "dragonchain endpoint" in the tutorial
    - Record the command displayed next to SSH Access (ssh root@YOURIP)
      - Use this command in Git BASH to login to your new VPS

**That’s all! You should be up and running, ready to tackle the rest of the L2 Node course!**
