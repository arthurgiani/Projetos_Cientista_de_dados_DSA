#Projeto DSA - Detecção de Fraudes TalkingData
library(data.table)
install.packages('dplyr')
library(dplyr)

datasetprov <- fread('train.csv', nrows = 30000000)
dataset <- sample_n(datasetprov, 500000)
rm(datasetprov)
head(dataset)
typeof(dataset)
str(dataset)

#Verificando valores missing

colSums(dataset == 0) #Valores esperados (0= fraude) e os zeros em 'os' e 'device' não são valores missing.
colSums(is.na(dataset)) #Não possui valores NA
colSums(dataset=='')#Referentes aos cliques de fraude (tempo de download não existiu)


#Definindo as variáveis categóricas
# 'ip', 'app', 'device', 'os', 'channel' são variáveis categóricas mas como os mesmos já estão representados
# por números e o Kaggle nao fornece as labels de cada coluna, não será feito a conversão para fator.

#COnversão da variável respota em fator
dataset$is_attributed <- as.factor(dataset$is_attributed)
str(dataset)


#Manipulação do dataset

#Excluíndo da coluna 'attributed_time' (redundância da variável resposta)
dataset <- dataset[,-7]

#Extraíndo as horas dos cliques (informação importante)
library(lubridate)
dataset$hour=hour(dataset$click_time)
dataset <- dataset[,-6] #coluna click-time nao é mais necessária
#Neste dataset, ano mes e dia nao fazem diferença pois o período de coleta da amostra foi muito curto.

#Gráficos (encontrei em um repositório do github e resolvi adaptar para este exercicio)

install.packages('highcharter')
library(highcharter)

#Gráficos com analises referentes aos cliques fraudulentos
h1 <- dataset %>% filter(is_attributed == 0) %>% group_by(app) %>% summarise(count = n()) %>% 
  arrange(desc(count)) %>% head(20) %>% mutate(app = as.character(app)) %>%
  hchart("bar", hcaes(x = app, y = count, color =-count)) %>%
  hc_add_theme(hc_theme_ffx()) %>% hc_title(text = "Top App vítimas de fraude")

h2 <- dataset %>% filter(is_attributed == 0) %>% group_by(os) %>% summarise(count = n()) %>% 
  arrange(desc(count)) %>% head(20) %>% mutate(os = as.character(os)) %>%
  hchart("bar", hcaes(x = os, y = count, color =-count)) %>%
  hc_add_theme(hc_theme_ffx()) %>% hc_title(text = "Top OS vítimas de fraude")

h3 <- dataset %>% filter(is_attributed == 0) %>% group_by(channel) %>% summarise(count = n()) %>% 
  arrange(desc(count)) %>% head(20) %>% mutate(channel = as.character(channel)) %>%
  hchart("bar", hcaes(x = channel, y = count, color =-count)) %>%
  hc_add_theme(hc_theme_ffx()) %>% hc_title(text = "Top Canais vítimas de fraude")

h4 <- dataset %>% filter(is_attributed == 0) %>% group_by(device) %>% summarise(count = n()) %>% 
  arrange(desc(count)) %>%  head(20) %>% mutate(device = as.character(device)) %>%
  hchart("bar", hcaes(x = device, y = count, color =-count)) %>%
  hc_add_theme(hc_theme_ffx()) %>% hc_title(text = "Top Smartphones vítimas de fraude")

h5 <- dataset %>% filter(is_attributed == 0) %>% group_by(hour) %>% summarise(count = n()) %>%
  arrange(desc(count)) %>% head(20) %>% mutate(hour = as.character(hour)) %>%
  hchart("bar", hcaes(x = hour, y = count, color =-count)) %>%
  hc_add_theme(hc_theme_ffx()) %>% hc_title(text = "Horário de maior ocorrência de fraudes")


#Verificando os gráficos da análise exploratória (para cliques fraudulentos)
h1
h2
h3
h4
h5


#Gráficos com analises referentes aos cliques não fraudulentos
h6 <- dataset %>% filter(is_attributed == 1) %>% group_by(app) %>% summarise(count = n()) %>% 
  arrange(desc(count)) %>% head(20) %>% mutate(app = as.character(app)) %>%
  hchart("bar", hcaes(x = app, y = count, color =-count)) %>%
  hc_add_theme(hc_theme_ffx()) %>% hc_title(text = "Top Apps baixados")

h7 <- dataset %>% filter(is_attributed == 1) %>% group_by(os) %>% summarise(count = n()) %>% 
  arrange(desc(count)) %>% head(20) %>% mutate(os = as.character(os)) %>%
  hchart("bar", hcaes(x = os, y = count, color =-count)) %>%
  hc_add_theme(hc_theme_ffx()) %>% hc_title(text = "Top OS utilizados")

h8 <- dataset %>% filter(is_attributed == 1) %>% group_by(channel) %>% summarise(count = n()) %>% 
  arrange(desc(count)) %>% head(20) %>% mutate(channel = as.character(channel)) %>%
  hchart("bar", hcaes(x = channel, y = count, color =-count)) %>%
  hc_add_theme(hc_theme_ffx()) %>% hc_title(text = "Top Canais")

h9 <- dataset %>% filter(is_attributed == 1) %>% group_by(device) %>% summarise(count = n()) %>% 
  arrange(desc(count)) %>%  head(20) %>% mutate(device = as.character(device)) %>%
  hchart("bar", hcaes(x = device, y = count, color =-count)) %>%
  hc_add_theme(hc_theme_ffx()) %>% hc_title(text = "Top Smartphones")

h10 <- dataset %>% filter(is_attributed == 1) %>% group_by(hour) %>% summarise(count = n()) %>%
  arrange(desc(count)) %>% head(20) %>% mutate(hour = as.character(hour)) %>%
  hchart("bar", hcaes(x = hour, y = count, color =-count)) %>%
  hc_add_theme(hc_theme_ffx()) %>% hc_title(text = "Horario de maior ocorrência de downloads")

#Plot dos gráficos para análise dos downloads
h6
h7
h8
h9
h10

###Fim da análise exploratória


#Balanceamento da variável resposta
install.packages("ROSE")
library(ROSE)
library(ggplot2)

ggplot(dataset, aes(x = is_attributed)) + geom_bar(col = 'white', fill = 'blue') + ggtitle('Proporção de cliques fraudulentos e legítimos') +xlab("Clique")
dataset_balanceado <- ovun.sample(is_attributed ~ ., data = dataset, method = "over",N = 1000000)$data
ggplot(dataset_balanceado, aes(x = is_attributed)) + geom_bar(col = 'white', fill = 'blue') + ggtitle('Proporção balanceada de cliques fraudulentos e legítimos') +xlab("Clique")


#Divisão do dataset
install.packages("caTools")
library(caTools)
set.seed(101) 
amostra <- sample.split(dataset_balanceado$is_attributed, SplitRatio = 0.7) 
summary(amostra)

# Criando dados de treino - 70% dos dados
treino = subset(dataset_balanceado, amostra == TRUE)
# Criando dados de teste - 30% dos dados
teste = subset(dataset_balanceado, amostra == FALSE)

#Feature Selection
library(randomForest)

ImportanciaVariáveis <- randomForest(is_attributed ~., data = treino, ntree=10, nodezise = 10, importance = TRUE)
varImpPlot(ImportanciaVariáveis)

library(caret)
#Estimando a importância
importance <- varImp(ImportanciaVariáveis, scale=FALSE)
#Sumarizando
print(importance)


#Como nenhuma variável apresentou correlação muito alta de forma isolada, todas as variáveis serão utilizadas.


#Treinando o algoritmo via RandomForest

modelo.rf <- randomForest(is_attributed~app+channel+ip, data = treino, ntree=10, nodezise = 10, importance = TRUE)
modelo.rf


#Teste do algoritmo via RandomForest
previsao.rf <- predict(modelo.rf, newdata = teste)
previsao.rf
comparativo.rf <- data.frame('Real' = teste$is_attributed, 'Previsto' = previsao.rf)
comparativo.rf
summary(comparativo.rf)
confusionMatrix(comparativo.rf$Real, comparativo.rf$Previsto)

#Geração das curvas de aprendizagem

install.packages("ROCR")
library("ROCR")

# Gerando as classes de dados
class1 <- predict(modelo.rf, newdata = teste, type = 'prob')
class2 <- teste$is_attributed
class1
class2



# Gerando a curva ROC (RandomForest)
pred <- prediction(class1[,2], class2) 
pred
perf <- performance(pred, "tpr","fpr") 
plot(perf, col = rainbow(10), xlab = 'Taxa de falsos positivos', ylab = 'Taxa de verdadeiros positivos', title = "oi")










