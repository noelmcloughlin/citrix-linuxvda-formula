# -*- coding: utf-8 -*-
# vim: ft: sls

{% from 'linuxvda/map.jinja' import linuxvda, sls_block with context %}

include:
  - linuxvda.config
  - linuxvda.service

extend:
  {%- for svc in linuxvda.services %}
  linuxvda_{{ svc }}_service:
    service:
      - listen:
        - cmd: linuxvda_config
      - require:
        - cmd: linuxvda_config
  {%- endfor %}

