FROM apache/hadoop:3.5.0

# Copy our config files over the defaults
COPY config/core-site.xml /opt/hadoop/etc/hadoop/core-site.xml
COPY config/hdfs-site.xml /opt/hadoop/etc/hadoop/hdfs-site.xml

# Override entrypoint to bypass broken envtoconf.py
ENTRYPOINT ["/opt/hadoop/bin/hdfs"]