========================
citrix-linuxvda-formula
========================

A saltstack formula for CITRIX Linux Virtual-Desktop-Agent (VDA) software.

.. note::

    See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.

Available states
================

.. contents::
    :local:

``linuxvda``
------------

Meta-state for inclusion of all states (except remove).

``linuxvda.config``
--------------------

Installs the linuxvda package, runs Linux VDA setup, and starts the services.

``linuxvda.service``
--------------------

Manages startup and running state for Linux VDA services.

``linuxvda.remove``
--------------------------

Stop services, remove postgres configuration, uninstall software and remove <citrix-home>/VDA directory.

