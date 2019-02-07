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

Download Linux VDA package from `linuxvda.citrix.uri`, validate the hashsum, and install.

``linuxvda.config``
--------------------

Disable mDNS in nsswitch.conf, execute Linux VDA setup script, and start services.

``linuxvda.xdping``
--------------------

Download XDPing package from `linuxvda.citrix.uri`, validate the hashsum, and install.  (Disabled for Ubuntu 18.04 - Work in Progress)

``linuxvda.remove``
--------------------------

Stop services, remove postgres configuration, uninstall software, and delete <citrix-home>/VDA directory.


Preparation
================

The target host is an AD domain member. The listed formulae satisfy pre-requisites for Citrix Linux VDA-

- `firewalld-formula
<https://github.com/saltstack-formulas/firewalld-formula>`_

- `resolver-formula
<https://github.com/saltstack-formulas/resolver-formula>`_

- `chrony-formula
<https://github.com/saltstack-formulas/chrony-formula>`_

- `postgres-formula
<https://github.com/saltstack-formulas/postgres-formula>`_

- `kerberos-formula
<https://github.com/saltstack-formulas/kerberos-formula>`_

- `samba-formula
<https://github.com/saltstack-formulas/samba-formula>`_

Pillars
===================

Setting the following pillars should be sufficient.

.. code:: yaml

    linuxvda:
      citrix:
        uri: http://download.example.com/xendesktop/
        variables:
          CTX_XDL_DDC_LIST: ubuntu-dc.example.com

Common problems
=======================

Compare host's assigned (dhcp) ipaddress with DNS recorded ipaddress! Sometimes the values are out of sync.

.. code-block:: bash

     [myhost]$ ip addr
     [myhost]$ host myhost.example.com

Ensure system time is NTP synchronized (yes)!!

.. code-block:: bash

     $ # timedatectl
               Local time: Fri 2018-02-09 08:34:10 MST
           Universal time: Fri 2018-02-09 15:34:10 UTC
                 RTC time: Fri 2018-02-09 15:34:21
                Time zone: America/Denver (MST, -0700)
          Network time on: yes
         NTP synchronized: yes
          RTC in local TZ: no

If VDA Agent uses port 80 (default yes), check and fix port collisions with apache2, nginx, etc.

.. code-block:: bash

     $ netstat -a | grep :80

Run the Citrix XDping tool from the `linuxvda.xdping` state. Fix any big issues and run formula again.

.. code-block:: bash

     $ # xdping



