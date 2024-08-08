# 加载必要的库
library(readxl)
library(dplyr)
library(ggplot2)
library(lubridate)
library(reshape2)
library(tidyr)

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

# 将每月汇总数据转化为宽格式数据框，以“年月”为行，“分类名称”为列
宽格式数据 <- 每月汇总数据 %>%
  pivot_wider(names_from = 分类名称, values_from = 每月销量_千克, values_fill = list(每月销量_千克 = 0))

# 去除“年月”列，保留分类名称的销量数据
销量矩阵 <- as.matrix(宽格式数据[,-1])

# 计算分类名称之间的Spearman相关性矩阵
相关性矩阵 <- cor(销量矩阵[,], method = "spearman")

# 将相关性矩阵转化为长格式用于绘制热力图
相关性数据 <- melt(相关性矩阵)

# 使用ggplot2绘制相关系数热力图
ggplot(相关性数据, aes(Var1, Var2, fill = value)) +
  geom_tile(color = "white") +
  scale_fill_gradient2(low = "blue", high = "red", mid = "white", 
                       midpoint = 0, limit = c(-1, 1), space = "Lab", 
                       name = "Spearman\n相关系数") +
  theme_minimal() + 
  theme(axis.text.x = element_text(angle = 45, vjust = 1, 
                                   size = 12, hjust = 1)) +
  coord_fixed() +
  labs(x = "分类名称", y = "分类名称", title = "分类名称之间的Spearman相关系数热力图")