This container runs openldap. This container assumes that you have a backup of ldap database that you want to load to it.

It is assumed that you are NOT running podman as root here.

At this time the container does not support ldaps.

# Create backup of the database

```
slapcat -n 0 > config.ldif
slapcat -n 1 > data.ldif
```

# Container isolation [optional]

To isolate users for different containers, run it with userns = auto. Note that this requires slapd running as a root inside of the container (and that's how the container is configured)

```
$ cat ~/.config/containers/containers.conf
[containers]
userns = "auto"
```


# Launch container

```
podman-compose up --build
```

# Add container to auto start

```
podman generate systemd --new server_ldap_1 >  ~/.config/systemd/user/server_ldap_1.service
```
