clc; clear all; close all;
% Parametry
c = 0.3;
N = 800;
t = linspace(0, 40, N);

% Generowanie szumu z rozkładu normalnego
z = c * randn(1, N);  % średnia = 0, odchylenie standardowe = c

% Generowanie sygnału trójkątnego
xTrue = sawtooth(2 * pi * 0.2 * t, 0.5);  % 0.5 oznacza sygnał trójkątny

% Dodanie szumu do sygnału
x = xTrue + z;

% Wykres szumu i sygnału zakłóconego
figure;
plot(t, z, 'o', 'MarkerSize', 1, 'LineStyle', 'none', 'DisplayName', 'Szum (normalny)');
hold on;
plot(t, x, 'DisplayName', 'Sygnał zakłócony');
grid on;
legend;
hold off;

% Estymacja sygnału
H1 = 2;
H2 = 320;
xEstimated1 = zeros(1, N);
xEstimated2 = zeros(1, N);

for k = H1:H2
    xEstimated1(k) = mean(x(k-H1+1:k));
end
for k = H2+1:N
    xEstimated1(k) = mean(x(k-H1+1:k));
    xEstimated2(k) = mean(x(k-H2+1:k));
end

% Wykres estymacji
figure;
plot(t, xTrue, 'DisplayName', 'Sygnał oryginalny');
hold on;
plot(t, xEstimated1, 'DisplayName', sprintf('Estymacja dla małego H=%d', H1));
plot(t(H2+1:N), xEstimated2(H2+1:N), 'DisplayName', sprintf('Estymacja dla dużego H=%d', H2));
legend;
hold off;

% Wykres MSE od h (optymalne h to 3)
mse = zeros(1, 20);
for i = 1:20
    xEstimated = zeros(1, N);
    for k = i+1:N
        xEstimated(k) = mean(x(k-i+1:k));
    end
    mse(i) = mean((xEstimated(i+1:N) - xTrue(i+1:N)).^2);
end

[~, hOptymalne] = min(mse);

figure;
plot(1:20, mse, 'o', 'DisplayName', 'Wartości MSE dla różnych h');
xlabel('h');
ylabel('MSE');
xline(hOptymalne, '--r', 'DisplayName', 'Optymalne h');
title('Zależność MSE od h');
grid on;
legend;

% Estymacja dla optymalnego h
xEstimated = zeros(1, N);
for k = hOptymalne+1:N
    xEstimated(k) = mean(x(k-hOptymalne+1:k));
end

figure;
plot(t, xTrue, 'DisplayName', 'Sygnał oryginalny');
hold on;
plot(t, xEstimated, 'DisplayName', sprintf('Estymacja dla optymalnego H=%d', hOptymalne));
legend;
hold off;

% Wykres MSE od różnych wariancji szumu
cForMSE = linspace(0, 1, 20);
varianceArray = zeros(1, 20);
mse = zeros(1, 20);

for i = 1:20
    c = cForMSE(i);
    varianceArray(i) = c^2;
    z = c * randn(1, N);  % szum normalny
    x = xTrue + z;
    
    % Wykonujemy badania dla przykładowego h = 3
    xEstimated = zeros(1, N);
    for k = 4:N
        xEstimated(k) = mean(x(k-3+1:k));
    end
    mse(i) = mean((xEstimated(4:N) - xTrue(4:N)).^2);
end

figure;
plot(varianceArray, mse, 'o');
xlabel('Wariancja szumu');
ylabel('MSE');
title('Zależność MSE od wariancji szumu dla h=3');
grid on;
