# etcd configuration and bootstrap with TLS
Create private CA that can be used to generate TSL certificates to encrypt and authenticate connections to [etcd](https://coreos.com/etcd/).

## Prereqs:
Tools needed, either:
### OSX
install the following using [brew])https://github.com/Homebrew/brew/)
```bash
brew install cfssl
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


## 

## References
https://github.com/coreos/docs/blob/master/os/generate-self-signed-certificates.md
https://github.com/cloudflare/cfssl
