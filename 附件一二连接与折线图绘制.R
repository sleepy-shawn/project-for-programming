# 加载必要的库
library(readxl)
library(dplyr)
library(ggplot2)
library(lubridate)
library(ggsci)

# 读取提供的Excel文件中的数据
setwd("/Users/jiaheguo/Desktop/C题")
附件1 <- read_excel("附件1.xlsx")
附件2 <- read_excel("附件2.xlsx")

# 基于“单品编码”合并两个数据框
合并数据 <- merge(附件2, 附件1, by = "单品编码")

# 按“销售日期”和“分类名称”汇总销售数据
汇总数据 <- 合并数据 %>%
  group_by(销售日期, 分类名称) %>%
  summarise(销量_千克 = sum(`销量(千克)`)) %>%
  ungroup()

# 将“销售日期”转换为日期格式并提取年份和月份
汇总数据 <- 汇总数据 %>%
  mutate(销售日期 = as.Date(销售日期),
         年月 = floor_date(销售日期, "month"))

# 按“年月”和“分类名称”汇总每月销售数据
每月汇总数据 <- 汇总数据 %>%
  group_by(年月, 分类名称) %>%
  summarise(每月销量_千克 = sum(销量_千克)) %>%
  ungroup()

# 使用ggplot2绘制折线图
ggplot(每月汇总数据, aes(x = 年月, y = 每月销量_千克, color = 分类名称, group = 分类名称)) +
  geom_line(size = 1) +
  geom_point() +
  labs(title = "各品类每月销售量变化",
       x = "年月",
       y = "每月销量（千克）",
       color = "分类名称") +
  theme_bw() +
  scale_color_npg() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))