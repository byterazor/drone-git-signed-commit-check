# drone-redmine

## Description

This is a [Drone CI](https://www.drone.io/) plugin to check if commits have been signed by a GPG key 
and verify the signature.

### Requirements
    - drone

### Working

This plugin will parse through the given number of commits starting from the newest one.
First it will check if a signature exists at all and if it does it will verify the signature with GPG.
For the later to work you have to mount a GPG directory with a public key list to /home/gpg.

### Alert

This is very early work and may and may not work for you yet.

### Settings Variables

* `ACTION` - which action to perform (check, verfiy), check will only tests for the existence of a signature **not** verify it (default is "check")
* `NR_COMMITS` - how far in the past you want to check. Keep in mind that testing thousands of commits might require a long time (default is 30)
* `BRANCH` - The Branch you want the commits checked in. Can be taken from DRONE_BRANCH

## Supported Architectures
- amd64
- arm64

## Updates

I am trying to update the image weekly as long as my private Kubernetes cluster is available. So I do not promise anything and do **not** rely 
your business on this image.


## Source Repository

* https://gitea.federationhq.de/Container/drone-git-signed-commit-check

## Project Homepage

* https://rm.byterazor.de/projects/drone-git-signed-commit-check

## Prebuild Images

* https://hub.docker.com/repository/docker/byterazor/drone-git-signed-commit-check

## Authors

* **Dominik Meyer** - *Initial work* 

## License

This project is licensed under the MPLv2 License - see the [LICENSE](LICENSE) file for details.
