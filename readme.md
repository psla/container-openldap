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

# Loading the data after first startup

Open the container's terminal (generally don't do it, this is only require for loading data for the first time and hopefully never again :) ):

```

$ podman container ls
CONTAINER ID  IMAGE                         COMMAND               CREATED         STATUS             PORTS                     NAMES
29cdd59c65fc  localhost/server_ldap:latest  -h ldap://0.0.0.0...  15 minutes ago  Up 15 minutes ago  0.0.0.0:11389->11389/tcp  server_ldap_1

$ podman exec -it 29cdd59c65fc /bin/sh
```
```
slapadd -n 0 -F /etc/openldap/slapd.d -l /data/config.ldif
slapadd -n 1 -F /etc/openldap/slapd.d -l /data/data.ldif
```

Compatibility issues:

The olcModulePath had to be modified in the config.ldif:

```
olcModulePath: /usr/lib/openldap
```

And similarly, data directory needs to be modified as well:

```
olcDataDirectory: /data
```

# Configure replication

slapadd -n 0 -F /etc/openldap/slapd.d -l /data/replication.ldif

