## Overview
This repository hosts the step-by-step installation guides to launch an unmanaged Dragonchain verification node to begin earning $DRGN cryptocurrency for your participation in the Dragon Net blockchain network.

## Step by Step Guide Quick Links
-   [Launch a Ubuntu Server VPS on Linode](launch-a-vps-on-linode.md)
-   [Installation Option #2: Manual Installation](manual-install.md)
-   [Try the Dragonchain SDK](setup-dragonchain-sdk.md)

## Disclaimers
-   You need basic linux admin skills (on the CLI) 
-   This is not a production-ready workflow for a large scale kubernetes cluster. It works. That’s about all I’ll guarantee.    
-   I can provide no PERSONAL guarantees on the security of this setup (especially if running on a local network with open ports).
-   This process WILL change: make sure you're referencing the latest version of these documents when installing

## Recommendations

-   Join the developers Telegram and Slack groups
-   Use an SSH client that lets you copy/paste (seriously)
	-   I like Git Bash on Windows
-   I run on AWS because I know how to and because it makes it easy for me to expose my dragonchain to the public internet safely; any VPS should work fine or even a box or VM in your bedroom/office, just know you have to expose it to traffic FROM the internet

## Notes

-   Make SURE your server is accessible FROM the internet
	- Specifically, you definitely need port 30000 open to incoming traffic
-   You CAN use minikube instead of microk8s. I chose to switch because minikube stores all data in a /tmp subfolder and I don’t trust it to stay there. No easy way to change this option, and microk8s works out of the box  
-   If you DON’T want to use a Ubuntu server, you’ll need to use minikube; I can’t help with storage issue (I believe devs are looking at it), but here are a few notes for getting minikube running:
	- Make SURE you follow recommended specs below
	- After installing the latest stable minikube version, follow the instructions in the docs to configure it to run with vm-driver “none” and configure it to use AT LEAST 4gb of memory
	-   Install docker.io DIRECTLY from your repo of choice (required since running without a vm)
	-   Install kubectl from your repo of choice
	- In opensource-config.yaml, change storageClass and storageClassName from “microk8s-hostpath” to “standard” (three changes)
	- Should be good to go otherwise (just skip the microk8s steps)

## Resources

-   Dragonchain Github:
	- [https://github.com/dragonchain/dragonchain](https://github.com/dragonchain/dragonchain)   

-   Dragonchain developers Slack:
	- [https://forms.gle/ec7sACnfnpLCv6tXA](https://forms.gle/ec7sACnfnpLCv6tXA)
    
-   Dragonchain Core Docs:
	- [https://dragonchain-core-docs.dragonchain.com/latest/deployment/requirements.html](https://dragonchain-core-docs.dragonchain.com/latest/deployment/requirements.html)
    
-   Minik8s docs:
	- [https://microk8s.io/docs/](https://microk8s.io/docs/)

-   Helm docs:
	- [https://helm.sh/docs/using_helm/#quickstart-guide](https://helm.sh/docs/using_helm/#quickstart-guide)
    
-   VirtualBox VM manager:
	- [https://www.virtualbox.org/](https://www.virtualbox.org/)
    
-   Ubuntu server installation image download:
	- [https://ubuntu.com/download/server](https://ubuntu.com/download/server)
