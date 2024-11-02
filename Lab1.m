% Parametry
N = 1000; % liczba punktów sygnału
t = linspace(0, 1, N); % wektor czasu
triangle_signal = sawtooth(2 * pi * 5 * t, 0.5); % generacja sygnału trójkątnego

% Rysunek 1: Oryginalny sygnał trójkątny
figure;
plot(t, triangle_signal);
title('Rysunek 1: Oryginalny sygnał trójkątny');
xlabel('Czas');
ylabel('Amplituda');
grid on;

% Naniesienie błędu na funkcję
variance = 0.2;
noise = sqrt(variance) * randn(1, N); % szum o rozkładzie normalnym
noisy_signal = triangle_signal + noise;

% Rysunek 3: Zaszumiony sygnał
figure;
plot(t, noisy_signal);
title('Rysunek 3: Zaszumiony sygnał (Var Zk = 0.2)');
xlabel('Czas');
ylabel('Amplituda');
grid on;

% Estymacja sygnału
H = 6; % wartość horyzontu estymacji
estimated_signal = zeros(1, N);
for k = H:N
    estimated_signal(k) = mean(noisy_signal(k-H+1:k));
end

% Rysunek: Sygnał estymowany
figure;
plot(t, noisy_signal, 'r--', t, estimated_signal, 'b-');
title('Sygnał zaszumiony i estymowany');
xlabel('Czas');
ylabel('Amplituda');
legend('Zaszumiony', 'Estymowany');
grid on;

% Wpływ H na MSE
H_values = 1:15;
MSE = zeros(1, length(H_values));
for idx = 1:length(H_values)
    H = H_values(idx);
    est_signal = zeros(1, N);
    for k = H:N
        est_signal(k) = mean(noisy_signal(k-H+1:k));
    end
    MSE(idx) = mean((est_signal - triangle_signal).^2);
end

% Rysunek 4: Zależność MSE od H
figure;
plot(H_values, MSE, 'o-');
title('Rysunek 4: Zależność MSE od H');
xlabel('H');
ylabel('MSE');
grid on;

% Zależność optymalnego H od wariancji zakłóceń
variances = 0.1:0.1:0.5;
optimal_H = zeros(1, length(variances));

for idx = 1:length(variances)
    noise = sqrt(variances(idx)) * randn(1, N);
    noisy_signal = triangle_signal + noise;
    
    mse_values = zeros(1, length(H_values));
    for h = H_values
        est_signal = zeros(1, N);
        for k = h:N
            est_signal(k) = mean(noisy_signal(k-h+1:k));
        end
        mse_values(h) = mean((est_signal - triangle_signal).^2);
    end
    [~, optimal_H(idx)] = min(mse_values);
end

% Rysunek 5: Zależność optymalnego H od wariancji zakłóceń
figure;
plot(variances, optimal_H, 'o-');
title('Rysunek 5: Zależność optymalnego H od wariancji zakłóceń');
xlabel('Wariancja zakłóceń');
ylabel('Optymalne H');
grid on;

% Zależność MSE od wariancji zakłóceń
MSE_variances = zeros(1, length(variances));
for idx = 1:length(variances)
    noise = sqrt(variances(idx)) * randn(1, N);
    noisy_signal = triangle_signal + noise;
    
    est_signal = zeros(1, N);
    for k = optimal_H(idx):N
        est_signal(k) = mean(noisy_signal(k-optimal_H(idx)+1:k));
    end
    MSE_variances(idx) = mean((est_signal - triangle_signal).^2);
end

% Rysunek 6: Zależność MSE od wariancji zakłóceń
figure;
plot(variances, MSE_variances, 'o-');
title('Rysunek 6: Zależność MSE od wariancji zakłóceń');
xlabel('Wariancja zakłóceń');
ylabel('MSE');
grid on;
