# All-in-One Vault AppRole Demo
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


## Done
 - Implemented all-in-one vagrantfile that creates everything needed to leverage Vault's AppRole feature.

