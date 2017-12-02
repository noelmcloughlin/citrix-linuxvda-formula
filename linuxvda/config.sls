# -*- coding: utf-8 -*-
# vim: ft: sls

{% from "linuxvda/map.jinja" import linuxvda with context %}

linuxvda_software:
  pkg.installed:
    - name: {{ linuxvda.server }}

  {% for config in linuxvda.env.nsswitch.regex %}
linuxvda_nsswitch_{{ config[0] }}:
  file.replace:
    - name: /etc/nsswitch.conf
    - pattern: {{ config[1] }}
    - repl: {{ config[2] }}
    - backup: '.salt.bak'
    - require:
      - pkg: linuxvda_software
    - require_in:
      - file: linuxvda_setup
  {% endfor %}

  {%- for svc in linuxvda.services -%}
linuxvda_stop_{{ svc }}:
  service.dead:
    - name: {{ svc }}
    - require_in:
      - file: linuxvda_setup
  {% endfor %}

linuxvda_setup:
  file.managed:
    - name: {{ linuxvda.citrix.vdasetup_script }}
    - source: salt://linuxvda/files/vdasetup.sh
    - user: root
    - group: root
    - mode: 644
    - makedirs: True
    - template: jinja
    - context:
      - citrix_home: {{ linuxvda.citrix.home }}
      - setupcmd: {{ linuxvda.setupcmd }}
  cmd.run:
    - name: {{ linuxvda.citrix.vdasetup_script }}
    - onchanges: 
      - file: {{ linuxvda.citrix.vdasetup_script }}
  {%- for svc in linuxvda.services }}
  service.running:
    - name: {{ svc }}
    - enable: True
    - require:
      - cmd: linuxvda_setup
  {% endfor %}

