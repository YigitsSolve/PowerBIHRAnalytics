ÖNEMLİ NOT:Bu çalışma, etki faktörü olarak gerçekleştirilmiştir. Bu, başlangıç değerlerinin (referans değerlerinin) etkisinin sıfır olduğu anlamına gelmektedir.

Yaş ve Deneyim ile İşten Ayrılma Tahmini


1. Projenin Amacı

Bu proje, çalışanların yaş, deneyim ve diğer çeşitli faktörlere dayalı olarak işten ayrılma (“Attrition”) tahminini yapmak için oluşturulmuştur.
*Lojistik Regresyon kullanarak çalışanların ayrılma olasılığı tahmin edilir.
*ROC Eğrisi ve AUC Skoru ile model performansı değerlendirilir.
*Boosting Modeli (GBM) ile tahminlerin doğruluğu artırılır.
*Bu model, şirketlerin personel devir hızını anlaması ve tahmin etmesi için kullanılabilir.
*Lojistik Büyüleme Modeli ile yaşa göre deneyim tahmini.


2. Kullanılan Yöntemler
Bu projede şu makine öğrenmesi ve istatistiksel yöntemler kullanılmıştır:
*Lojistik Regresyon  (Olasılık bazlı tahmin yapar)
*Confusion Matrix (Modelin doğruluk oranını değerlendirir)
*ROC Eğrisi & AUC Skoru  (Modelin çalışma performansını ölçer)
*Boosting (GBM) ⚡ (Performansı artırmak için ek model)

3. Gereksinimler ve Kurulum
library(readxl)
library(dplyr)
library(ggplot2)
library(VIM)
library(naniar)
library(mice)
library(caret)
library(randomForest)
library(gbm)
library(pROC)
library(gtsummary)

Logistik Büyüme Modeli  Kısmı

1. Projenin Amacı Bu projenin amacı, logistik büyüme modeli kullanarak bir veri kümesine en uygun eğriyi uydurmak ve model parametrelerini belirlemektir. Doğrusal olmayan en küçük kareler yöntemi (nonlinear least squares) kullanılarak en iyi parametre tahminleri yapılmakta ve modelin doğruluğu görselleştirme ile analiz edilmektedir.

2. Gereksinimler ve Kurulum
install.packages("minpack.lm")
library(minpack.lm)  # nlsLM için
library(ggplot2)


Logistik Model Fonksiyonu

Logistik büyüme modeli aşağıdaki matematiksel formül

Y= L/1+e^(-k(X-x0)

L: Asimptotik maksimum değer (taşıma kapasitesi),

k: Büyüme hızı,

x0: Eğrinin orta noktasıdır.




