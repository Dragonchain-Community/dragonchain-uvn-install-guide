## Overview
This repository hosts the step-by-step installation guides to launch an unmanaged Dragonchain verification node to begin earning $DRGN cryptocurrency for your participation in the Dragon Net blockchain network.

## About the Course
In this course on the Dragonchain Academy, you'll be guided from start to finish launching an operational Dragonchain Level 2 verification node running on a Ubuntu server (even if you've never heard the words "Linux" or "command line" before). 

**In the course, you'll learn and be guided through:**
- General preparation and registering on the Dragonchain console website
- How to launch a brand new Ubuntu linux virtual server in the cloud from scratch
- Installation option #1, an automatic process that's almost 100% hands-off
- Installation option #2, the step-by-step, command for command process if you want complete control
- The basics of using the Dragonchain SDK to write code to query your new node for information

## Step by Step Guide Quick Links
-   [General Preparation and Registering on Dragon Net](general-preparation.md)
-   [Launch a Ubuntu Server VPS on Linode](launch-a-vps-on-linode.md)
-   [Installation Option #1: Automatic Installation](automatic-install.md)
-   [Installation Option #2: Manual Installation](manual-install.md)
-   [Try the Dragonchain SDK](setup-dragonchain-sdk.md)

## Disclaimers
-   Basic command-line linux admin skills are very handy but not required
-   This is not a production-ready workflow for a large scale kubernetes cluster. It works. That’s about all I’ll guarantee.    
-   I can provide no guarantees on the security of this setup (especially if running on a local network with open ports).
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

-   Dragonchain Telegram:
	- [https://t.me/dragontalk/](https://t.me/dragontalk/)
    
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
