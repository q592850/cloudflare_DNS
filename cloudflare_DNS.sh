#!/bin/bash

# Cloudflare API 凭据
auth_email=""
auth_key=""

# 域名信息
name=""  # 主域名
name_2=""  # 二级域名
content_cm1=""  # 端口开启时的 CNAME 记录值
content_cm2=""  # 端口关闭时的 CNAME 记录值

# 获取区域 ID
zone=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones" \
-H "X-Auth-Email: ${auth_email}" \
-H "X-Auth-Key: ${auth_key}" \
-H "Content-Type: application/json" | jq -r '.result[] | select(.name == "'"${name}"'") | .id')

if [[ -z $zone ]]; then
  echo "错误：未找到区域 ID。"
  exit 1
fi

echo "区域 ID：$zone"

# 获取记录 ID
record=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/${zone}/dns_records" \
-H "X-Auth-Email: ${auth_email}" \
-H "X-Auth-Key: ${auth_key}" \
-H "Content-Type: application/json" | jq -r '.result[] | select(.name == "'"${name_2}"'") | .id')

if [[ -z $record ]]; then
  echo "错误：未找到记录 ID。"
  exit 1
fi

echo "记录 ID：$record"

# 设置初始 CNAME 记录值
initial_content="$content_cm1"

# 持续监视目标端口
while true; do
  # 检查目标端口是否开启
  if nc -w 2 cm1.blackpink520.cyou 49803 < /dev/null 2>&1 | grep -q Connected; then
    # 如果目标端口开启，则将 CNAME 记录值设置为初始值
    content="$initial_content"
  else
    # 如果目标端口关闭，则将 CNAME 记录值设置为备份值
    content="$content_cm2"
  fi

  # 使用新的 CNAME 记录值更新 DNS 记录
  response=$(curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/${zone}/dns_records/${record}" \
  -H "X-Auth-Email: ${auth_email}" \
  -H "X-Auth-Key: ${auth_key}" \
  -H "Content-Type: application/json" \
  --data "{\"type\":\"CNAME\",\"name\":\"${name_2}\",\"content\":\"${content}\",\"ttl\":120,\"proxied\":false}" | jq -r '.success')
  
  if [[ $response == "true" ]]; then
    echo "DNS 记录更新成功。"
  else
    echo "更新 DNS 记录时出错。"
  fi

  # 等待 5 分钟
  sleep 300
done
