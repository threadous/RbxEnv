---
sidebar_position: 1
---

# About RbxEnv

**RbxEnv** is a Roblox framework that helps developers streamline their workflow. It allows developers to declare shared variables under an environment and use them accross all their scripts. From declaring variables to remote events to bindable events, RbxEnv makes your game organization much easier by allowing you to fetch shared variables through a single line of code.

## Getting Started

Import the RbxEnv package either from the Roblox Marketplace or the Github and place the folder in `ReplicatedStorage`. 

For the sake of this tutorial, the getting started will be guiding you to create a **Centralized** framework. In the future, depending whether you intend to create a **Centralized** or **Decentralized** framework, your set up might vary.

**What's the difference?**
 - **Centralized**: Most of the environment structure is avaiable to you in a fully organized module script. Heirarchy can easily be determined saves you the time of writing code to create environments. It is a much more refined way to set up your framework. **HIGHLY RECOMMENDED for environments that are going to be replicated to the client**.

 - **Decentralized**: You will be able to build environments in scripts using the `RbxEnv.new` function to set up all your environments (you can still achieve this through the centralized version). Using this setup method may result in some environments and variables **not** replicating the client. This setup was originally developed in the raw build of the framework for testing and small scale purposes.


## Setting up

As for this tutorial, it will be guiding you through setting up a **centralized framework**. You may name the scripts/folders as you may in this tutorial, names are indicated just for you to follow along. If names are not supposed to be changed or set to a certain name, it will be explicitly stated.

Head over to `ServerScriptService` and create a folder (*Core*) and add a script (*Main*) in that folder followed by a module script in the same folder (*GameConfig* **Name it exactly as GameConfig**)

Next, open the `GameConfig` module script and add the following code:

```lua
return {
  ["GameEnvironments"] = {

  },

  ["GameNetworks"] = {

  },

  ["GameConstants"] = {

  },
}
```

## Create An Environment

In the same *GameConfig* module script, add the name of your environment in the *GameEnvironments* table as so:

```lua
  ["GameEnvironments"] = {

    "EnvironmentBasics",
  }
```

Add the name of your environment as the `key` to an empty table `{}` in the `GameNetworks` and the `GameConstants` part as well. 

This creates a new environment called *EnvironmentBasics* for you to work in and code. This will also be replicated to the client, meaning any values/variables/events you store within this environment will be available to the client to access. **Any environment not declared in GameConfig will NOT replicate to the client as long as it is created AFTER the RbxEnv initialization.**
