FROM  python:3.4-alpine
MAINTAINER Shi Yunjin <admin@shiyunjin.cn>
ENV CONFIG_FILE /config.json
COPY requirements.txt /zabbix-cachet-metrics/requirements.txt
COPY zabbix-cachet-metrics.py /zabbix-cachet-metrics/zabbix-cachet-metrics.py
RUN pip3 install -r /zabbix-cachet-metrics/requirements.txt
WORKDIR /opt/

CMD ["python", "/zabbix-cachet-metrics/zabbix-cachet-metrics.py"]