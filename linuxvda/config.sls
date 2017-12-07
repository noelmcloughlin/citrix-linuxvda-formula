# -*- coding: utf-8 -*-
# vim: ft: sls

{% from "linuxvda/map.jinja" import linuxvda with context %}

include:
  - linuxvda.pkg

  {% for config in linuxvda.nsswitch.regex %}
linuxvda_nsswitch_{{ config[0] }}:
  file.replace:
    - name: /etc/nsswitch.conf
    - pattern: {{ config[1] }}
    - repl: {{ config[2] }}
    - backup: '.salt.bak'
    - require:
      - pkg: linuxvda_package
    - require_in:
      - file: linuxvda_setup
  {% endfor %}

linuxvda_setup:
  file.managed:
    - name: {{ linuxvda.dl.tmpdir }}/vdasetup.sh
    - source: salt://linuxvda/files/vdasetup.sh
    - user: root
    - group: root
    - mode: 755
    - makedirs: True
    - template: jinja
    - context:
      - ctxsetup: {{ linuxvda.citrix.ctxsetup }}
  cmd.run:
    - name: {{ linuxvda.dl.tmpdir }}/vdasetup.sh
    - onchanges: 
      - file: {{ linuxvda.dl.tmpdir }}/vdasetup.sh

  {%- for svc in linuxvda.services %}
linuxvda_{{ svc }}_running:
  service.running:
    - name: {{ svc }}
    - enable: True
  {% endfor %}

