# -*- coding: utf-8 -*-
# vim: ft: sls

{% from 'linuxvda/map.jinja' import linuxvda with context %}

include:
  - linuxvda.pkg
  - linuxvda.config
  - linuxvda.xdping

extend:
  {%- for svc in linuxvda.services %}
  linuxvda_{{ svc }}_running:
    service:
      - listen:
        - pkg: linuxvda_package
        - cmd: linuxvda_config_setup
      - require:
        - pkg: linuxvda_package
        - cmd: linuxvda_config_setup
  {%- endfor %}
