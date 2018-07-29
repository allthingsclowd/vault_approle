[![Build Status](https://travis-ci.org/allthingsclowd/vault_approle.svg?branch=master)](https://travis-ci.org/allthingsclowd/vault_approle)

# All-in-One Vault AppRole Demo

![913ee4e2-b01c-4749-8daa-f3ec5f8e5203](https://user-images.githubusercontent.com/9472095/43364036-20dbed52-930a-11e8-9e93-6de1290108b6.png)

This repository has everything needed to walk through HasihCorp's Vault AppRole process. Typically everything that is squashed onto a single instance here for demonstration purposes would be broken out across the CI/CD pipeline.

The Role ID is equivalent to a username, and Secret ID is the corresponding password. The app needs both to log in with Vault. Naturally, the next question becomes how to deliver those values to the expecting client.

A common solution involves three personas instead of two: admin, app, and trusted entity. The trusted entity delivers the Role ID and Secret ID to the client by separate means.

For example, Terraform injects the Role ID onto the virtual machine. When the app runs on the virtual machine, the Role ID already exists on the virtual machine.

See https://www.hashicorp.com/resources/approle-pull-authentication-vault for a detailed explaination.

## Refactor
What are we refactoring?
Why are we investing time on this?
How much time do we estimate we will use?
When PR merged, state how much time was used.



## New Features
What the new functionality needs to do?
Why we need this functionality?
Explanation on how this functionality was implemented goes in the PR.
### - Add Travis Testing
### - Add TAGGING



## Done
 - Implemented all-in-one vagrantfile that creates everything needed to leverage Vault's AppRole feature.
![8acc344a-0b17-44c0-bd5a-e4d4b92330b2](https://user-images.githubusercontent.com/9472095/43363712-b82736e2-9302-11e8-987b-5976bb2aca7b.png)

 - Add advanced response wrapping feature to secret-id
This advanced feature ensures that ONLY the application gets to see the actual Secret-Id


# Installation Example (Without Wrapping)

https://gist.github.com/allthingsclowd/f9ebd159057fe99e5ec8433460a621af

