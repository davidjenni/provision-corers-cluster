# etcd configuration and bootstrap with TLS
Create private CA that can be used to generate TSL certificates to encrypt and authenticate connections to [etcd](https://coreos.com/etcd/).

## Prereqs:
Tools needed, either:
### OSX
install the following using [brew])https://github.com/Homebrew/brew/)
```bash
brew install cfssl
brew install fleetctl
```

### docker
`TBD`


## Initialize local CA
A small script creates the CA cert needed to sign the different etcd certs. To change cert subject or CN, edit localCerts/ca-csr.json

Certs will be placed into folder localCA/certs/. Copy and safeguard the localCA/certs/ca-key.pem file if needed beyond the etcd bootstrapping.

To initialize this local CA:

```bash
sh ./init-ca.sh
```

## Create etcd certs
All etcd certs are signed with the local CA cert above.

## Create CoreOS nodes
### DigitalOcean
Creation script assumes two env variables:
```bash
export DO_TOKEN=<yourToken>
export DO_SSH_PUB_KEY_FILE=~/.ssh/<your-SSH-public-key-file>
```
  - `DO_TOKEN` is set to [your DigitalOcean API key](https://cloud.digitalocean.com/settings/api/tokens):
  - `DO_SSH_PUB_KEY_FILE` is set to your SSH public key file you want to use for SSH access to the CoreOS nodes

## Access your nodes with fleetctl
The firewall rules in the cloud-config.yaml file will block access to the usual etcd & fleetd ports (2379 & 4001),
but fleetctl supports tunneling via SSH. `fleetctl` doesn't support much control which SSH key file to chose.
The key file must be loaded into the SSH agent, even on OSX.

```bash
eval `ssh-agent -s`
ssh-add $DO_SSH_PUB_KEY_FILE
```

To convince `fleetctl` to use the SSH tunnel, set its environment variable to the IP address of one of your nodes.
Lookup the public IP address of one of the cluster nodes at [your droplet page](https://cloud.digitalocean.com/droplets)

```bash
export FLEETCTL_TUNNEL=<public IP address>
fleetctl list-machines
```
Accept the ECDSA key fingerprint (which is a consequence of the SSH connection to a new CoreOS node).

To connect to one of the cluster machines (i.e. the host CoreOS), use the machine name from the `fleetctl list-machines` output;
it's sufficient to use the first 3-5 characters):

```bash
fleetctl ssh 9963e
```
Accept the SSH fingerprint, it is a result of the tunnel to the private network (it's typically for an IP address like 10.134.4.141).



## References
https://github.com/coreos/docs/blob/master/os/generate-self-signed-certificates.md
https://github.com/cloudflare/cfssl
