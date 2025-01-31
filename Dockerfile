FROM alpine:3.21

RUN apk update && \
    apk add --no-cache openldap openldap-back-mdb openldap-overlay-syncprov

RUN mkdir -p /usr/local/var/
RUN install -m 755 -o ldap -g ldap -d /etc/openldap/slapd.d
RUN install -m 755 -o root -g root -d /var/run/slapd

EXPOSE 11389
EXPOSE 11636

ENTRYPOINT  ["slapd"]
CMD         ["-h", "ldap://0.0.0.0:11389/ ldapi://%2Fusr%2Flocal%2Fvar%2Fldapi ldaps://0.0.0.0:11636/", "-dStats,Stats2"]
#CMD         ["-h", "ldap://0.0.0.0:11389/ ldapi://%2Fusr%2Flocal%2Fvar%2Fldapi ldaps://0.0.0.0:11636/", "-u", "ldap", "-g", "ldap", "-dStats,Stats2"]
