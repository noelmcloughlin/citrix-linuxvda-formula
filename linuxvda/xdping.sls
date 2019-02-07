{% from "linuxvda/map.jinja" import linuxvda with context %}


  {% if not (grains.os == 'Ubuntu' and grains.osmajorrelease|int >= 18) %}
     ### xdping is not working on Ubuntu 18.04 yet.

     {% if linuxvda.xdping.archive %}

linuxvda_xdping_tmpdir:
  file.directory:
    - name: '{{ linuxvda.dl.tmpdir }}'
    - makedirs: True
    - require_in:
      - cmd: linuxvda_xdping_download_archive
    - unless: test -d '{{ linuxvda.dl.tmpdir }}'

linuxvda_xdping_download_archive:
  cmd.run:
    - name: curl -o {{linuxvda.dl.tmpdir}}/{{linuxvda.xdping.archive}} {{linuxvda.citrix.uri ~ linuxvda.xdping.archive}}
    - unless: test -f {{linuxvda.dl.tmpdir}}/{{linuxvda.xdping.archive}}
         {% if grains['saltversioninfo'] >= [2017, 7, 0] %}
    - retry:
      attempts: {{ linuxvda.dl.retries }}
      interval: {{ linuxvda.dl.interval }}
      until: True
      splay: 10
         {% endif %}

         {%- if linuxvda.xdping.hash %}
linuxvda_xdping-check-archive-hash:
   # Check local archive using hashstring for older Salt / MacOS.
  module.run:
    - name: file.check_hash
    - path: {{ linuxvda.dl.tmpdir }}/{{ linuxvda.xdping.archive }}
    - file_hash: {{ linuxvda.xdping.hash }}
    - onlyif: test -f {{ linuxvda.dl.tmpdir }}/{{ linuxvda.xdping.archive }}
    - require:
      - cmd: linuxvda_xdping_download_archive
    - require_in:
      - archive: linuxvda_xdping_archive_extract
         {%- endif %}

linuxvda_xdping_archive_extract:
  archive.extracted:
    - source: 'file://{{ linuxvda.dl.tmpdir }}/{{ linuxvda.xdping.archive }}'
    - name: '{{ linuxvda.dl.tmpdir }}'
    - archive_format: tar
    - require:
      - cmd: linuxvda_xdping_download_archive
    - require_in:
      - pkg: linuxvda_xdping_package_install
            {% if grains['saltversioninfo'] < [2016, 11, 0] %}
    - if_missing: '{{ linuxvda.xdping.cmd }}'
            {% endif %}

linuxvda_xdping_package_install:
  cmd.run:
    - name: {{ linuxvda.dl.tmpdir }}/linux-xdping/uninstall.sh || echo "not installed"
    - onlyif: test -f {{ linuxvda.dl.tmpdir }}/linux-xdping/uninstall.sh
    - require_in:
      - pkg: linuxvda_xdping_package_install
  pkg.installed:
    - sources:
      - xdping: {{ linuxvda.dl.tmpdir }}/{{ linuxvda.xdping.package }}
    - require:
      - archive: linuxvda_xdping_archive_extract
    - onlyif: test -f {{ linuxvda.dl.tmpdir }}/{{ linuxvda.xdping.package }}
    - unless: {{ grains.os == 'Ubuntu' and grains.osmajorrelease|int >= 18 }}

   {% endif %}
