## Zabbix-Cachet-Metrics
This is python script which provide synchronisation between [Zabbix IT Services](https://www.zabbix.com/documentation/3.0/manual/it_services)
and [Cachet](https://cachethq.io/)

## 简介
主要用于更新Cachet的图表。    
支持从Zabbix中取某个监控项的最新数值 或者 统计WEB监控的可用性
支持统计Elasticsearch近一分钟内的日志数量，然后将数值插入图表中用于统计访问人数。

## Demo 
[SWAP Status](https://status.swap.wang)


## 配置文件
* update_interval: 更新时间 秒
* service：服务信息
 * cachet: 请填写Cachet的API地址与API Token
  * url: Cachet的API地址
  * api_key: Cachet的API Token
* config：以列表的形式记录数据源的信息，脚本会自动遍历该列表，根据配置信息逐一更新Cachet的图表
 * services：
   * zbx: zabbix
   * es6: elasticsearch
 * other:私有值 参考下面

* zbx: 私有值
  * type: host用于WEB可用性图表 item用于监控项图表
  * id: 监控项填写地址中的itemid WEB可用性请填写zabbix 
  * metric_id: Cachet的Metrics id
* es6：私有值
  * es6_api_url: elasticsearch地址
  * es6_index: 索引
  * metric_id: Cachet的Metrics id
  

## Zabbix 配置文件 ID 配置
* host:
    * 提取方式： 检测中->最新数据(/latest.php?ddreset=1)->"Failed step of scenario "******"."->历史记录->URL(/history.php?action=showvalues&itemids[]=28264) -> itemids[]=28264 -> 28264
    * Cachet图表设置: 每个度量点之间应当间隔多少分钟？->0  小数点位数->2  图表计算方法->Average  默认值->0
* item:
    * 提取方式： 配置->主机(/hosts.php?ddreset=1)->监控项-> Anyone -> URL(/items.php?form=update&hostid=10084&itemid=23316) -> itemid=23316 -> 23316
    * Cachet图表设置: 不一定自己研究

按上方提取方式填写。

## Docker部署 (推荐)
1. 创建 `/etc/zabbix-cachet-metrics.json` 请参考 `config-example.json`.
1.5. 如果你是中国服务器你可能需要先设置一下Docker加速器,否则下载会非常慢(阿里云和Daocloud都有免费提供) 
2. 运行Docker容器
    ```
    docker run --name zabbix-cachet-metrics -v /etc/zabbix-cachet-metrics.json:/config.json shiyunjin/zabbix-cachet-metrics
    ```

## 普通部署
本脚本使用python3编写，需要安装以下依赖包
* requests    

可通过以下命令安装：    
    
    pip3 install requests

该脚本直接执行即可：    
    
    /usr/bin/python3 ./zabbix-cachet-metrics.py    
    
建议将其加入crontab，实现自动更新：    
    
    */1 * * * * root /usr/bin/python3 /opt/cachet/zabbix-cachet-metrics.py

## 其他
脚本中elasticsearch的query payload仅在ES6中测试过，仅能统计指定索引在最近一分钟内的请求数。    
我的应用场景是为了统计nginx的请求数，因为每次访问都会产生一条日志，而在elasticsearch里则是一个条目，所以计算出的数量即为请求数。

## 鸣谢
原脚本地址 [NGX LAB](https://gitlab.ngx.hk/tc/some-script/tree/master/cachethq) 感谢提供脚本和基本思路,在此基础上添加了更多监控项图表和docker部署化支持
