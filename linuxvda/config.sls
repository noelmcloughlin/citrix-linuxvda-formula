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
      - pkg: linuxvda_software
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
      - setupcmd: {{ linuxvda.citrix.setupcmd }}
  cmd.run:
    - name: {{ linuxvda.citrix.vdasetup_script }}
    - onchanges: 
      - file: {{ linuxvda.citrix.vdasetup_script }}

  {%- for svc in linuxvda.services %}
linuxvda_{{ svc }}_service_running:
  service.running:
    - name: {{ svc }}
    - enable: True
  {% endfor %}

