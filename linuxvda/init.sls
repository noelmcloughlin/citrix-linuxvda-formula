# -*- coding: utf-8 -*-
# vim: ft: sls

{% from 'linuxvda/map.jinja' import linuxvda, sls_block with context %}

include:
  - linuxvda.pkg
  - linuxvda.config

extend:
  {%- for svc in linuxvda.services %}
  linuxvda_{{ svc }}_service:
    service:
      - listen:
        - pkg: linuxvda-distro-package
        - cmd: linuxvda_setup
      - require:
        - pkg: linuxvda-distro-package
        - cmd: linuxvda_setup
  {%- endfor %}
