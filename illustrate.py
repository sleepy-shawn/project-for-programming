import numpy as np

import matplotlib.pyplot as plt

# Generate random data
np.random.seed(42)
n = 100  # Number of data points
x = np.random.rand(n)
y = np.random.rand(n)
z = np.random.rand(n)
colors = np.random.rand(n)

# Create the 3D scatter plot
fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')
ax.scatter(x, y, z, c=colors, cmap='rainbow')

# Set labels and title
ax.set_xlabel('X')
ax.set_ylabel('Y')
ax.set_zlabel('Z')
ax.set_title('3D Scatter Plot')

# Show the plot
plt.show()