# -*- coding: utf-8 -*-
# vim: ft: sls

{% from 'linuxvda/map.jinja' import linuxvda with context %}

include:
  - linuxvda.pkg
  - linuxvda.config

extend:
  {%- for svc in linuxvda.services %}
  linuxvda_{{ svc }}_running:
    service:
      - listen:
        - pkg: linuxvda_package
        - cmd: linuxvda_setup
      - require:
        - pkg: linuxvda_package
        - cmd: linuxvda_setup
  {%- endfor %}
