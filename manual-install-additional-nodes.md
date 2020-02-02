# Manual Installation - Installing Additional Nodes on the Same Machine

It is possible and very cost efficient to run multiple verification nodes on a single VPS or machine. This document will point out the things you should know and the tweaks to the process of getting your additional nodes up and running.

### General Notes

1. **Be Organized!** - There's a lot of data you'll want to keep up with (chain ID, token, credentials, IP address and port number, etc.) when following this process. I recommend a simple text file that you can use to keep track of the important information as you go through the installation process.

Here's what my individual blocks of information look like in my file:

```
Node Name: L2-0
----------------
Console Chain ID: asdfasdf-asdfasdf-asdfasdf-asdfasdf
Console Matchmaking Token: asdfasdf-asdfasdf-asdfasdf-asdfasdf
Server IP: 12.34.56.78
Server Port: 30000
Root HMAC key details: ID: ASDFQWERASDFQWER | KEY: as123asdfqwer1234asdf2342356
Public ID: 1234asdf1234asdfsdfh2352346
```

This makes it very simple to setup the block explorer and so forth down the line

2. **Be Sure to Comment Out the Noted Lines in Each Install Script As You Go!** This will make it incredibly simple to run the upgrades for each of your nodes as they are required without breaking anything. The lines to comment out will be indicated in the text of the manual installation instructions.

3. **Don't Stack ALL of Your Nodes on One VPS!** While the general rule (as far as I've tested it) seems to be that you can generally run 1 less VPS than you have gigabytes of RAM (so on a 4GB VPS, you can run 3 nodes; on an 8GB you can run 7), it's NOT a good idea to put all of the nodes you want to run on a single VPS.

This means your entire node operation goes down if that one VPS goes down. Instead, I recommend running no more than 3 nodes per VPS, then just create additional VPS'es for any others you want to setup *in different datacenters*. This way you keep verifying transactions even if one particular datacenter has trouble. Plus, for Linode at least, it costs the same to run 4x4GB nodes as it does to run 1x16GB node.

### How to Install Your Additional Nodes

First, you'll need to follow the [manual installation guide](manual-install.md) in this repository.

Next, after installing your first node from start to finish, **you just need to repeat steps 6 through 12** under the Manual Installation - Dragonchain Installation section of the manual process!

**Note:** at step 6, when creating your installation script, just add the number or name of the node to the filename to keep things organized. So in my case, assuming I use the node name pattern "l2-0, l2-1, l2-2", etc., my install script filenames will be "install_dragonchain_0.sh, install_dragonchain_1.sh, install_dragonchain_2.sh", etc.

Other than that, everything should be fairly straightforward.

### How to Delete a Node 

If you ever need to delete one of your nodes (it crashes, etc.), you can use the following command to do so without affecting your other running nodes:

`sudo helm delete --purge yournodename`

You'll need to replace the "yournodename" with the actual name of the node to delete (so something like "l2-3" in my example).

If you have any questions or trouble along the way, feel free to ping us in Telegram or on Slack, and happy (multi) noding!
