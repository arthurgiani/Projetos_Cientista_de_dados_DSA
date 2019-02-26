#Projeto DSA - Prevendo risco de crédito

# Carregando o dataset em um dataframe
dataset <- read.csv("credit_dataset.csv", header = TRUE, sep = ",")
head(dataset)
typeof(dataset)

#Verificando o tipo das variáveis do dataset
str(dataset)

#Verificando valores missing

colSums(dataset == 0)
colSums(is.na(dataset))

#Dataset já tratado

#Denominando as colunas numéricas e categóricas do dataset
#Definindo as variáveis categóricas
var.categ <- c('credit.rating', 'account.balance', 'previous.credit.payment.status',
               'credit.purpose', 'savings', 'employment.duration', 'installment.rate',
               'marital.status', 'guarantor', 'residence.duration', 'current.assets',
               'other.credits', 'apartment.type', 'bank.credits', 'occupation', 
               'dependents', 'telephone', 'foreign.worker')

#Definindo as variáveis numéricas
var.num <- c("credit.duration.months", "age", "credit.amount")

#Transformando a variável categórica em fator
to.factors <- function(df, variables){
  for (variable in variables){
    df[[variable]] <- as.factor(df[[variable]])
  }
  return(df)
}

dataset <- to.factors(dataset, var.categ)
str(dataset)


#Balanceando as amostras
library(ggplot2)
table(dataset$credit.rating) # 0=bom pagador , 1 = mal pagador
ggplot(dataset, aes(x = credit.rating)) + geom_bar(col = 'white', fill = 'chocolate') + ggtitle('Proporção de bons e maus pagadores') +xlab("Risco de Crédito")
install.packages("DMwR")
library(DMwR)
set.seed(100)
dataset <- SMOTE(credit.rating~., dataset, perc.over = 100)
table(dataset$credit.rating)

#Verificação da nova amostra
ggplot(dataset, aes(x = credit.rating)) + geom_bar(col = 'white', fill = 'chocolate') + ggtitle('Proporção de bons e maus pagadores após o SMOTE') 



#Análise exploratória
#Analisando as variáveis categóricas
lapply(var.categ, function(x){
  if(is.factor(dataset[,x])) {
    ggplot(dataset, aes_string(x)) +
      geom_bar(fill = 'chocolate') + 
      facet_grid(. ~ credit.rating) + 
      ggtitle(paste("Total de Credito Bom/Ruim por",x))}})


#Análise das variáveis numéricas
hist(dataset$credit.duration.months, main = 'Duração do pagamento do empréstimo', xlab = "Meses", col = "chocolate")
hist(dataset$age, main = 'Idade dos credores', xlab = "Anos", col = "chocolate")
hist(dataset$credit.amount, main = 'Quantia do empréstimo', xlab = "Valor(US$)", col = "chocolate")


#Normalizando as variáveis numéricas
normalizar <- function(df, variables){
  for (variable in variables){
    df[[variable]] <- scale(df[[variable]], center=T, scale=T)
  }
  return(df)
}
dataset <- normalizar(dataset, var.num)


#Divisão do dataset
install.packages("caTools")
library(caTools)
set.seed(101) 
amostra <- sample.split(dataset$credit.rating, SplitRatio = 0.8) 
summary(amostra)



# Criando dados de treino - 80% dos dados
treino = subset(dataset, amostra == TRUE)
# Criando dados de teste - 20% dos dados
teste = subset(dataset, amostra == FALSE)



##Verificação das variáveis importantes (60% ou mais entra, entre 55 e 60 verificar importância)
library(caret)

#Definindo os parâmetros
control <- trainControl(method="repeatedcv", number=10, repeats=3)
ImportanciaVar <- train(credit.rating~., data=treino, method="lvq", preProcess="scale", trControl=control)

#Estimando a importância
importance <- varImp(ImportanciaVar, scale=FALSE)
#Sumarizando
print(importance)
#Plotando a importância
plot(importance, main = 'Importância das variáveis', xlab = 'Importance %')


#Treinando o algoritmo via RandomForest
library(randomForest)
modelo.rf <- randomForest(credit.rating ~ account.balance + credit.duration.months+credit.amount +current.assets+previous.credit.payment.status+employment.duration+credit.purpose, data = treino, ntree=100, nodezise = 10, importance = TRUE)
modelo.rf


#Teste do algoritmo via RandomForest
previsao.rf <- predict(modelo.rf, newdata = teste)
previsao.rf
comparativo.rf <- data.frame('Real' = teste$credit.rating, 'Previsto' = previsao.rf)
comparativo.rf
summary(comparativo.rf)

#Matriz de confusão via RandomForest
confusionMatrix(comparativo.rf$Real, comparativo.rf$Previsto)


#Treinando o modelo via Regressão Logística
modelo.rl <- glm(credit.rating ~ account.balance + credit.duration.months+credit.amount +current.assets+previous.credit.payment.status+employment.duration+credit.purpose, data = treino, family = 'binomial')
summary(modelo.rl)

#Testando o modelo via Regressão Logística
## Separando o dataset de treino em variáveis preditoras e variável resposta
varx_teste <- teste[,-1]
vary_teste <- teste[,1]

previsao.rl <- predict(modelo.rl, teste, type="response")
previsao.rl <- round(previsao.rl)
confusionMatrix(table(data = previsao.rl, reference = vary_teste), positive = '0')


#Geração das curvas de aprendizagem

install.packages("ROCR")
library("ROCR")

# Gerando as classes de dados
class1 <- predict(modelo.rf, newdata = teste, type = 'prob')
class2 <- teste$credit.rating
class1
class2



# Gerando a curva ROC (RandomForest)
pred <- prediction(class1[,2], class2) 
pred
perf <- performance(pred, "tpr","fpr") 
plot(perf, col = rainbow(10), xlab = 'Taxa de falsos positivos', ylab = 'Taxa de verdadeiros positivos', title = "oi")



#Gerando a curva ROC (Regressão Logística)
class3 <- predict(modelo.rl, newdata = teste, type = 'response')
pred2 <- prediction(class3, class2) 
perf2 <- performance(pred2, "tpr","fpr") 
plot(perf2, col = rainbow(10), xlab = 'Taxa de falsos positivos', ylab = 'Taxa de verdadeiros positivos')

#Plotando as duas curvas lado a lado
par(mfrow = c(1,2))
plot(perf, col = rainbow(10), xlab = 'Taxa de falsos positivos', ylab = 'Taxa de verdadeiros positivos', main = "Curva de Aprendizagem(RForest)")
plot(perf2, col = rainbow(10), xlab = 'Taxa de falsos positivos', ylab = 'Taxa de verdadeiros positivos', main = "Curva de Aprendizagem(Regressão)")


