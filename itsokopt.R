library(minpack.lm)  # nlsLM için
library(ggplot2)

# X ve Y değerlerini tanımlama
X_data <- 18:59  # 18'den 59'a kadar X değerleri
Y_data <- 42 - (X_data - 18)  # 42'den başlayarak 1'er 1'er azalan Y değerleri

# Logistik büyüme modeli fonksiyonu
logistic_model <- function(x, L, k, x0) {
  L / (1 + exp(-k * (x - x0)))
}

# Modeli verilere uydurma
model <- nlsLM(Y_data ~ logistic_model(X_data, L, k, x0),
               start = list(L = 50, k = 0.1, x0 = 40),
               control = nls.lm.control(maxiter = 100))

# Parametreler
params <- coef(model)
L <- params["L"]
k <- params["k"]
x0 <- params["x0"]
cat("L, k, x0 degerleri:", L, k, x0, "\n")

# Modelleme sonuçlarını görselleştirme
ggplot(data = data.frame(X_data, Y_data), aes(x = X_data, y = Y_data)) +
  geom_point(color = 'red', size = 2, alpha = 0.6) +
  stat_function(fun = function(x) logistic_model(x, L, k, x0),
                color = "blue", size = 1) +
  ggtitle('Logistik Model Uydurma') +
  xlab('X Değerleri') +
  ylab('Y Değerleri') +
  theme_minimal()
