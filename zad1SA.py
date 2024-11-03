import numpy as np
import matplotlib.pyplot as plt
import numpy.random
import math
from scipy.signal import sawtooth

# Parametry
c = 0.3
N = 800
t = np.linspace(0, 40, N)

# Generowanie szumu z rozkładu normalnego
z = numpy.random.normal(0, c, N)  # średnia = 0, odchylenie standardowe = c

# Generowanie sygnału trójkątnego
xTrue = sawtooth(2 * np.pi * 0.2 * t, 0.5)  # 0.5 oznacza sygnał trójkątny

# Dodanie szumu do sygnału
x = xTrue + z

# Wykres szumu i sygnału zakłóconego
plt.figure()
plt.plot(t, z, markersize=1, marker='o', linestyle='None', label='Szum (normalny)')
plt.plot(t, x, label='Sygnał zakłócony')
plt.grid()
plt.legend()
plt.show()

# Estymacja sygnału
H1 = 2
H2 = 320
xEstimated1 = np.zeros(N)
xEstimated2 = np.zeros(N)
for k in range(H1, H2):
    xEstimated1[k] = np.mean(x[k - H1:k])
for k in range(H2, N):
    xEstimated1[k] = np.mean(x[k - H1:k])
    xEstimated2[k] = np.mean(x[k - H2:k])

# Wykres estymacji
plt.figure()
plt.plot(t, xTrue, label='Sygnał oryginalny')
plt.plot(t, xEstimated1, label=f'Estymacja dla małego H={H1}')
plt.plot(t[H2:N], xEstimated2[H2:N], label=f'Estymacja dla dużego H={H2}')
plt.legend()
plt.show()

# Wykres MSE od h (optymalne h to 3)
mse = np.zeros(20)
for i in range(1, 21):
    xEstimated = np.zeros(N)
    for k in range(i, N):
        xEstimated[k] = np.mean(x[k - i:k])
    mse[i - 1] = np.mean((xEstimated[i:N] - xTrue[i:N])**2)

hOptymalne = np.argmin(mse) + 1
plt.figure()
plt.plot(range(1, 21), mse, marker='o', label="Wartości mse dla różnych h")
plt.xlabel('h')
plt.ylabel('MSE')
plt.axvline(hOptymalne, color='red', linestyle='--', label='Optymalne h')
plt.title('Zależność MSE od h')
plt.grid()
plt.legend()
plt.show()

# Estymacja dla optymalnego h
xEstimated = np.zeros(N)
for k in range(hOptymalne, N):
    xEstimated[k] = np.mean(x[k - hOptymalne:k])

plt.figure()
plt.plot(t, xTrue, label='Sygnał oryginalny')
plt.plot(t, xEstimated, label=f'Estymacja dla optymalnego H={hOptymalne}')
plt.legend()
plt.show()

# Wykres MSE od różnych wariancji szumu
cForMSE = np.linspace(0, 1, 20)
varianceArray = np.zeros(20)
mse = np.zeros(20)
xEstimated = np.zeros(N)
for i, c in enumerate(cForMSE):
    varianceArray[i] = (c**2)
    z = numpy.random.normal(0, c, N)  # średnia = 0, odchylenie standardowe = c
    x = xTrue + z
    # Wykonujemy badania dla przykładowego h = 3
    for k in range(3, N):
        xEstimated[k] = np.mean(x[k - 3:k])
    mse[i] = np.mean((xEstimated[3:N] - xTrue[3:N]) ** 2)

plt.figure()
plt.plot(varianceArray, mse, marker='o')
plt.xlabel('Wariancja szumu')
plt.ylabel('MSE')
plt.title('Zależność MSE od wariancji szumu dla h=3')
plt.grid()
plt.show()
