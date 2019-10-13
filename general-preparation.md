# General Preparation for Launching a Dragonchain Unmanaged Verification Node

## Get Registered on Dragon Net

1. Login to the Dragonchain console website (https://console.dragonchain.com/)
2. Click the Dragon Net tab on the left
3. Click "Register Unmanaged Chain"
4. Give your chain a name and click "Create Unmanaged L2 Chain"
5. Click the Matchmaking tab at the top to retrieve your Chain ID and Matchmaking Token 

## Recommended VPS/VM Server Specifications
- 1 CPU and 2GB RAM is now working well with the latest Dragonchain release!
- 16GB Disk Space

## Security Considerations
It is absolutely possible to run a Dragonchain node on a virtual machine or dedicated PC on your home or office network. 

**Be aware that you WILL have to expose your PC and network to the outside internet if you choose this route.**

I cannot provide security recommendations for ensuring you've safely setup your network and server. 

For this reason, I **highly** recommend you use a service like Linode or Amazon Web Services to host your Dragonchain node!

## Notes for Users Running Nodes on Their Own Hardware/Network

In most cases by default your router/modem likely does not have port 30000 open (or whichever you choose to use). If this is the case, you will be able to run the script, however at the end when checking the connection, the script will issue a message similar to "Error: Unable to communicate with the matchmaking API. Timed out." 

In order to open a port on the router/modem side, a user must log in to the admin panel (typically the router) for their network. 

On a computer connected to the network, please open a command prompt or terminal session and execute the command "ipconfig" (on \*\*nix systems it is "ifconfig") if you don't already know your router's IP address (on a home router, this address will typically be listed on a sticker on the router along with the default username and password).

You are looking for the IP address of the "default gateway". Supposing the gateway IP is 192.168.0.1, open any browser and enter this as a url (some people may have 10.0.0.1, or many other possibilities).  Hit enter, and you will be directed to your network's admin panel. Unless you've changed it, the default login may be found by searching your router model online for "default login" (or checking for the aforementioned sticker on your router). Mine had a username of "admin" and a password of "password". 

Log in, and find (possibly under "Advanced" tab) the page for "Port Forwarding", all panels vary a little. You will need to enter the port number (probably 30000) as well as the internal IP address of the device you are running a node on. To find the internal IP, again issue the ip/ifconfig command and look for "IPv4 Address". For connection type you may select either TCP or TCP/UDP. Save these settings, and that's it, your computer will now be able to communicate with Net through this port.

One final note if you setup port forwarding to a device on your network: your device's INTERNAL IP address may change if you restart the device, the router is restarted, etc. You can set your device up to use a permanent internal IP address. 

**Windows Guide for Setting a Static Internal IP Address:**

https://kb.netgear.com/27476/How-do-I-set-a-static-IP-address-in-Windows

**Linux Guide for Setting a Static Internal IP Address:**

https://danielmiessler.com/study/manually-set-ip-linux/

If you have any questions or trouble, let us know in the Telegram chats.
