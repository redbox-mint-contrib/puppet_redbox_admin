# redbox_admin

#### Table of Contents

1. [Overview](#overview)
2. [Setup - The basics of getting started with puppet_redbox_admin](#setup)
    * [What puppet_redbox_admin affects](#what-puppet_redbox_admin-affects)
3. [Usage - Configuration options and additional functionality](#usage)


## Overview

Puppet redbox admin deploys nodejs, npm (including sails and forever) and redbox admin rpm.

## Setup

### What puppet_redbox_admin affects

* The forever/sails commands are controlled from rpm deployment.
* puppet_redbox: the proxy needs to be added to puppet_redbox hiera config

## Usage

* For installing redbox_admin :
puppet apply -e "class {'puppet_redbox_admin':}"

* To start/stop forever:
cd /opt/redbox/redbox-admin && forever <start|stop|restart> app.js --prod


