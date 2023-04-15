# cloudflare_DNS
自动更新cloudflare_DNS域名解析
# Cloudflare API 凭据
auth_email="##########" #Cloudflare 邮箱

auth_key="##########" #Cloudflare  KEY

name=""  # 主域名

name_2=""  # 二级域名

content_cm1=""  # 端口开启时的 CNAME 记录值

content_cm2=""  # 端口关闭时的 CNAME 记录值

# 检查目标端口是否开启
  if nc -w 2 `cm1.blackpink520.cyou 49803` < /dev/null 2>&1 | grep -q Connected; then
这里的主入口需要修改的
  
## 场景
你流量转发买了多家 或 同一家，但是不通入口。
举例：
在某某家购买了流量转发，他们家拥有广州移动入口、上海电信入口 或者说 广港隧道、沪港隧道
你要做的是，不同入口做同样出口！
主广港隧道 A.12345.com:55555
备沪港隧道 B.12345.com:55555
在检查目标端口开启这里
  if nc -w 2 `cm1.blackpink520.cyou 49803` < /dev/null 2>&1 | grep -q Connected; then
  修改成
  if nc -w 2 `A.12345.com:55555` < /dev/null 2>&1 | grep -q Connected; then
  这个时候会监视 主广港隧道 的端口是否正常
  如果正常的那就用这个主广港隧道，如果关闭了，会解析到 `备沪港隧道 B.12345.com:55555`
  如果主入口修复了，会解析回`主广港隧道 A.12345.com:55555`
  
