# redbox_admin

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with puppet_redbox_admin](#setup)
    * [What puppet_redbox_admin affects](#what-puppet_redbox_admin-affects)
4. [Usage - Configuration options and additional functionality](#usage)


## Overview

Puppet redbox admin deploys nodejs, npm (including sails and forever) and redbox admin rpm. 

## Module Description



If your module has a range of functionality (installation, configuration,
management, etc.) this is the time to mention it.

## Setup

### What puppet_redbox_admin affects

* The forever/sails commands are controlled from rpm deployment.
* puppet_redbox: the proxy needs to be added to puppet_redbox hiera config

## Usage

* For installing redbox_admin :
puppet apply -e "class {'puppet_redbox_admin':}"

* To start/stop forever:
cd /opt/redbox/redbox-admin && forever <start|stop|restart> app.js --prod


