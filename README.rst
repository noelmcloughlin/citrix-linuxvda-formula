========================
citrix-linuxvda-formula
========================

A saltstack formula for CITRIX Linux Virtual-Desktop-Agent (VDA) software.

.. note::

    See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.
    Refer to pillar.example and defaults.yaml for configurable values.
    Supported linux distributions are Ubuntu, SuSE, RHEL, and CentOS.
    Using 'selinux enforcing' mode may cause state failures.

Available states
================

.. contents::
    :local:

``linuxvda``
------------

Meta-state for inclusion of all states (except remove).

``linuxvda.pkg``
--------------------

Download Linux VDA package, validate hashsum, and install the software.

``linuxvda.config``
--------------------

Disable mDNS in nsswitch.conf, execute Linux VDA setup script, and start services.

``linuxvda.remove``
--------------------------

Stop services, remove postgres configuration, uninstall software, and delete <citrix-home>/VDA directory.


Preparation
================

The target host is an AD domain member. The listed formulae satisfy pre-requisites for Citrix Linux VDA-

- `resolver-formula
<https://github.com/saltstack-formulas/resolver-formula>`_

- `chrony-formula
<https://github.com/saltstack-formulas/chrony-formula>`_

- `postgres-formula
<https://github.com/saltstack-formulas/postgres-formula>`_

- `kerberos-formula
<https://github.com/noelmcloughllin/kerberos-formula>`_

- `samba-formula
<https://github.com/noelmcloughlin/samba-formula>`_

FQDN
======
To ensure that the DNS domain name and FQDN of the machine are reported back correctly, change the following line of the /etc/hosts file to include the FQDN and hostname as the first two entries:

     127.0.0.1  hostname-fqdn hostname localhost localhost.localdomain localhost4 localhost4.localdomain4

For example:

     127.0.0.1  vda01.example.com vda01 localhost localhost.localdomain localhost4 localhost4.localdomain4

Remove any other references to hostname-fqdn or hostname from other entries in the file.

