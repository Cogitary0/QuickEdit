import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D


HEIGHT_FACTOR = 2.
K_FACTOR =.05
func_mount = lambda x, y : HEIGHT_FACTOR * np.exp(-K_FACTOR * x * x) * np.abs(HEIGHT_FACTOR * np.exp(-K_FACTOR * y * y))


fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')


x = np.linspace(-10, 10, 50)
y = np.linspace(-10, 10, 50)
x, y = np.meshgrid(x, y)

z = func_mount(x, y)

ax.scatter(
    x.ravel(), y.ravel(), z.ravel(), 
    c=z.ravel(),
    cmap='viridis'
    )

ax.set_xlabel('X')
ax.set_ylabel('Y')
ax.set_zlabel('Z')
ax.set_title('3d vis solve mount')

plt.show()