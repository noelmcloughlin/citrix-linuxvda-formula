{% from "linuxvda/map.jinja" import linuxvda with context %}

linuxvda_dependencies:
  file.directory:
    - name: '{{ linuxvda.dl.tmpdir }}'
    - clean: True
    - makedirs: True
    - require_in:
      - cmd: linuxvda_package
    - unless: test -d '{{ linuxvda.dl.tmpdir }}'
  pkg.installed:
    - pkgs:
    {% for pkg in linuxvda.pkgs %}
      - {{ pkg }}
    {% endfor %}
    - require_in:
      - pkg: linuxvda_package

linuxvda_package:
  cmd.run:
    - name: curl {{linuxvda.dl.opts}} -o {{linuxvda.dl.tmpdir}}/{{linuxvda.src_pkg}} {{linuxvda.citrix.uri ~ linuxvda.src_pkg}}
    {% if grains['saltversioninfo'] >= [2017, 7, 0] %}
    - retry:
      attempts: {{ linuxvda.dl.retries }}
      interval: {{ linuxvda.dl.interval }}
    {% endif %}
  module.run:
    - name: file.check_hash
    - path: {{ linuxvda.dl.tmpdir }}/{{ linuxvda.src_pkg }}
    - file_hash: {{ linuxvda.src_hash }}
    - onlyif: test -f {{ linuxvda.dl.tmpdir }}/{{ linuxvda.src_pkg }}
    - require_in:
      - pkg: linuxvda_package
  pkg.installed:
    - sources:
      - {{ linuxvda.normalname }}: {{ linuxvda.dl.tmpdir }}/{{ linuxvda.src_pkg }}

