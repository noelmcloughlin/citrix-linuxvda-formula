{% from "linuxvda/map.jinja" import linuxvda with context %}

linuxvda-create-extract-dir:
  file.directory:
    - names: '{{ linuxvda.dl.tmpdir }}'
    - clean: True
    - makedirs: True
    - require_in:
      - cmd: linuxvda-distro-package
    - unless: test -d '{{ linuxvda.dl.tmpdir }}'

linuxvda-distro-package:
  cmd.run:
    - name: curl {{linuxvda.dl.opts}} -o '{{ linuxvda.dl.tmpdir }}/{{ linuxvda.src_pkgname }}' {{ linuxvda.dl.url }}
    {% if grains['saltversioninfo'] >= [2017, 7, 0] %}
    - retry:
      attempts: {{ linuxvda.dl.retries }}
      interval: {{ linuxvda.dl.interval }}
    {% endif %}
  module.run:
    - name: file.check_hash
    - path: '{{ linuxvda.dl.tmpdir }}/{{ linuxvda.src_pkgname }}'
    - file_hash: {{ linuxvda.src_hashsum }}
    - onlyif: test -f '{{ linuxvda.dl.tmpdir }}/{{ linuxvda.src_pkgname }}'
    - require_in:
      - pkg: linuxvda-distro-package
  pkg.installed:
    - sources:
      - linuxvda: '{{ linuxvda.dl.tmpdir }}/{{ linuxvda.src_pkgname }}'
    {% for pkg in linuxvda.requiredpkgs %}
      - {{ pkg.split('.')[0] }}: {{ pkg }}
    {% endfor %}
  file.absent:
    - name: '{{linuxvda.tmpdir}}'
    - onchanges:
      - file: linuxvda-create-extract-dir
 
