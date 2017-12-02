# -*- coding: utf-8 -*-
# vim: ft: sls

{% from "linuxvda/map.jinja" import linuxvda with context %}

  {%- for svc in linuxvda.services -%}
linuxvda_{{ svc }}_stop:
  service.dead:
    - name: {{ svc }}
    - require_in:
      - cmd: linuxvda_remove
  {% endfor %}

linuxvda_remove:
  cmd.run:
    - name: {{ linuxvda.citrix.cleanup }}
    - onlyif: test -f {{ linuxvda.citrix.cleanup }}
  pkg.removed:
    - name: {{ linuxvda.src_pkgname.split('-')[0] }}
    - require:
      - cmd: linuxvda_remove
  file.absent:
    - name: {{ linuxvda.citrix.prefix }}/VDA
    - require:
      - pkg: linuxvda_remove

