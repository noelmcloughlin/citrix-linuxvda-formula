# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "linuxvda/map.jinja" import linuxvda with context %}

  {%- for svc in linuxvda.services %}
linuxvda_{{ svc }}_service:
  service.running:
    - name: {{ svc }}
    - enable: True
  {% endfor %}

