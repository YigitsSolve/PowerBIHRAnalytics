library(readxl)
library(dplyr)

# Excel dosyasını yükleme
Employee <- read_excel("C:/Users/Safa/Desktop/Employee.xlsx")

# Gerekli Paketleri Yükle
packages <- c("titanic", "dplyr", "ggplot2", "VIM", "naniar", "mice", "caret", "randomForest", "gbm")
new_packages <- packages[!(packages %in% installed.packages()[,"Package"])]
if(length(new_packages)) install.packages(new_packages)

#Kütüphaneler
library(ggplot2)
library(VIM)
library(naniar)
library(mice)
library(caret)
library(randomForest)
library(gbm)
library(dplyr)
# Kategorik değişkenleri faktöre çevirme (Over18 sütunu kaldırıldı)
categorical_columns <- c("Attrition", "BusinessTravel", "Department", "EducationField", "Gender", "JobRole", "MaritalStatus", "OverTime")
Employee[categorical_columns] <- lapply(Employee[categorical_columns], factor)

# Tek değere sahip sütunları tespit et ve çıkar
single_value_columns <- sapply(Employee, function(x) length(unique(x)) == 1)
Employee <- Employee[, !single_value_columns]
Employee
# Veri çerçevesinden belirli sütunları seç
df_selected <- select(Employee,Age, Attrition, BusinessTravel, DistanceFromHome,
                      EnvironmentSatisfaction,
                      Gender,JobInvolvement,JobSatisfaction, MaritalStatus,
                      NumCompaniesWorked, OverTime,RelationshipSatisfaction,
                      TotalWorkingYears, TrainingTimesLastYear, WorkLifeBalance, YearsAtCompany,
                      YearsInCurrentRole, YearsSinceLastPromotion, YearsWithCurrManager)

# Logistik regresyon modeli
model <- glm(Attrition ~ ., data = df_selected, family = binomial())

# Model özeti
summary(model)


library(pROC)
# Tahmin edilen olasılıklar/ katsayılar
predicted_probabilities <- predict(model, type = "response")

# Gerçek değerler - Attrition sütununu faktör olarak belirlemek gerekebilir
actual_values <- factor(df_selected$Attrition, levels = c("No", "Yes"))

# ROC Eğrisi ve AUC
roc_curve <- roc(actual_values, predicted_probabilities)
plot(roc_curve, main = "ROC Curve")
auc_value <- auc(roc_curve)
cat("AUC Value:", auc_value, "\n")

# Confusion Matrix ve diğer metrikler
#0.7 tahmin edilen olasılıkların bir sınıfa (örneğin "Evet") atanması için kullanılan eşik değeri
library(caret)
predicted_classes <- ifelse(predicted_probabilities > 0.7, "Yes", "No")
conf_matrix <- confusionMatrix(as.factor(predicted_classes), actual_values)
print(conf_matrix)

# Hassasiyet, Duyarlılık ve F1-Skoru
precision <- conf_matrix$byClass['Precision']
recall <- conf_matrix$byClass['Sensitivity']
f1_score <- 2 * (precision * recall) / (precision + recall)
cat("Precision:", precision, "\n")
cat("Recall:", recall, "\n")
cat("F1 Score:", f1_score, "\n")


###############
###############

# Gerekli paketi yükleme (Eğer yüklü değilse önce yükle)
#install.packages("gtsummary")

# Paketi çağır
#library(gtsummary)

# Modeli düzgün bir formatta özetleyerek referans kategoriyi açıkça 0 olarak göster
#tbl_regression(model, exponentiate = FALSE)

###############

# Paketi çağır
#library(gtsummary)

# Modeli tekrar oluştur
#model <- glm(Attrition ~ ., data = df_selected, family = binomial())

# (Intercept) ve tüm değişkenleri göstermek için `include = everything()` ekleyelim
#tbl_regression(model, exponentiate = FALSE, include = everything())
#tbl_regression(model,exponentiate = TRUE, include = everything())
###########
# Gerekli paketi yükleme (eğer yüklü değilse)
#install.packages("gtsummary")

# Kütühane
library(gtsummary)

# Model tekrarı
model <- glm(Attrition ~ ., data = df_selected, family = binomial())

# (Intercept) dahil etmek için `intercept = TRUE` ekle
tbl_regression(model, exponentiate = FALSE, intercept = TRUE)

################


# Veri setini eğitim ve test setlerine ayır
set.seed(123)  # Reproducibility için seed ayarı
split <- createDataPartition(df_selected$Attrition, p = 0.66, list = FALSE)
training_set <- df_selected[split, ]
test_set <- df_selected[-split, ]

# Eğitim seti üzerinde logistik regresyon modeli
model <- glm(Attrition ~ ., data = training_set, family = binomial())

# Model özeti
summary(model)

# Test seti üzerinde tahminler
predicted_probabilities <- predict(model, newdata = test_set, type = "response")
actual_values <- factor(test_set$Attrition, levels = c("No", "Yes"))

# ROC Eğrisi ve AUC
roc_curve <- roc(actual_values, predicted_probabilities)
plot(roc_curve, main = "ROC Curve")
auc_value <- auc(roc_curve)
cat("AUC Value:", auc_value, "\n")

# Confusion Matrix ve diğer metrikler
predicted_classes <- ifelse(predicted_probabilities > 0.5, "Yes", "No")
conf_matrix <- confusionMatrix(as.factor(predicted_classes), actual_values)
print(conf_matrix)

# Hassasiyet, Duyarlılık ve F1-Skoru
precision <- conf_matrix$byClass['Precision']
recall <- conf_matrix$byClass['Sensitivity']
f1_score <- 2 * (precision * recall) / (precision + recall)
cat("Precision:", precision, "\n")
cat("Recall:", recall, "\n")
cat("F1 Score:", f1_score, "\n")




library(gbm)
library(dplyr)

# Yanıt değişkenini sayısallaştırma
training_set <- training_set %>%
  mutate(Attrition = ifelse(Attrition == "Yes", 1, 0))

test_set <- test_set %>%
  mutate(Attrition = ifelse(Attrition == "Yes", 1, 0))

#Seed
set.seed(123)

# Boosting modeli
boosting_model <- gbm(Attrition ~ ., data=training_set, distribution="bernoulli",
                      n.trees=50, interaction.depth=1, shrinkage=0.01,
                      cv.folds=5, n.minobsinnode = 10)

# Boosting modeli ile tahmin
boosting_predictions <- predict(boosting_model, newdata=test_set, n.trees=50, type="response")
boosting_predicted_classes <- ifelse(boosting_predictions > 0.5, 1, 0)

# Performans değerlendirme
library(caret)
boosting_conf_matrix <- confusionMatrix(factor(boosting_predicted_classes, levels=c(0, 1)), factor(test_set$Attrition, levels=c(0, 1)))
print(boosting_conf_matrix)














