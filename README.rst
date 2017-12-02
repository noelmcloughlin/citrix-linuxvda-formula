========================
citrix-linuxvda-formula
========================

A saltstack formula for CITRIX Linux Virtual-Desktop-Agent (VDA) software.

.. note::

    See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.
    Refer to pillar.example and defaults.yaml for configurable values.
    Supported linux distributions are Ubuntu, SuSE, RHEL, and CentOS.

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

``linuxvda.service``
--------------------

Manage running state of Linux VDA services.

``linuxvda.remove``
--------------------------

Stop services, remove postgres configuration, uninstall software, and delete <citrix-home>/VDA directory.

