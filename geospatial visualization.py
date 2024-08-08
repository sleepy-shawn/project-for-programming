import networkx as nx
import matplotlib.pyplot as plt

# 创建一个空的无向图
G = nx.Graph()

# 添加节点
G.add_node(1)
G.add_node(2)
G.add_node(3)
G.add_node(4)

# 添加边
G.add_edge(1, 2)
G.add_edge(1, 3)
G.add_edge(2, 4)
G.add_edge(3, 4)

# 绘制网络图
pos = nx.spring_layout(G)  # 使用spring布局
nx.draw(G, pos, with_labels=True, node_color='skyblue', edge_color='gray', node_size=2000, font_size=15)

# 显示图形
plt.title('Network Graph')
plt.show()
