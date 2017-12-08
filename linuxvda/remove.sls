# -*- coding: utf-8 -*-
# vim: ft: sls

{% from "linuxvda/map.jinja" import linuxvda with context %}

  {% for svc in linuxvda.services %}
linuxvda_{{ svc }}_stop:
  service.dead:
    - name: {{ svc }}
    - require_in:
      - cmd: linuxvda_remove
  {% endfor %}

linuxvda_remove:
  cmd.run:
    - name: {{ linuxvda.citrix.ctxcleanup }}
    - onlyif: test -f {{ linuxvda.citrix.ctxcleanup }}
  pkg.removed:
    - name: {{ linuxvda.normalname }}
    - require:
      - cmd: linuxvda_remove
  file.absent:
    - name: /opt/Citrix/VDA
    - require:
      - pkg: linuxvda_remove

