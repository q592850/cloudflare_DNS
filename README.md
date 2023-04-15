# 不要怀疑我编写脚本的专业性
这TM是ChatGPT写的！<br>
我只在CnetOS7.9上用，其他平台我没有测试，自行测试<br>
需要的环境：<br>

yum -y install nc

yum -y install jq

# 如果你不是CentOS的系统怎么办？
复制脚本代码扔到ChatGPT里面<br>
然后说：“以此为基础，我的系统平台是乌班图，请帮我修改成乌班图能使用的脚本，功能请保持不变！”<br>
就完事儿了！我只是以乌班图系统举例，你自己啥平台，就写啥系统<br>

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
你流量转发买了多家 或 同一家，但是不通入口。<br>
在终端用户什么都不修改的情况下，主要入口坏了，那么此时需要切换到备用上，在用户不修改的情况下切换过去！<br>
这样可以做到终端用户什么都不用修改。<br>
前提是 流量转发要做同样的端口<br>

## 举例
在某某家购买了流量转发，他们家拥有广州移动入口、上海电信入口 或者说 广港隧道、沪港隧道<br>
你要做的是，不同入口做同样出口！<br>
主广港隧道 A.12345.com:55555<br>
备沪港隧道 B.12345.com:55555<br>

### 在检查目标端口开启这里
  if nc -w 2 `cm1.blackpink520.cyou 49803` < /dev/null 2>&1 | grep -q Connected; then
  
  修改成<br>
  
  if nc -w 2 `A.12345.com:55555` < /dev/null 2>&1 | grep -q Connected; then 
  
  这个时候会监视 主广港隧道 的端口是否正常<br>
  如果正常的那就用这个主广港隧道，如果关闭了，会解析到 `备沪港隧道 B.12345.com:55555`<br>
  如果主入口修复了，会解析回`主广港隧道 A.12345.com:55555`
  
# 此时会有叼毛问 如何运行脚本
`./cloudflare_DNS.sh`
# 此时又会有叼毛问 如何后台运行脚本
`nohup ./cloudflare_DNS.sh`
然后关闭ssh窗口
