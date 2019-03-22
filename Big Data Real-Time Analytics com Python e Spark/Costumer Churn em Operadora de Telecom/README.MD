# Prevendo Customer Churn em Operadoras de Telecom

Customer Churn (ou Rotatividade de Clientes, em uma tradução livre) refere-se a uma decisão tomada pelo cliente sobre o término do relacionamento
comercial. Refere-se também à perda de clientes. A fidelidade do cliente e a rotatividade de clientes sempre somam 100%. Se uma empresa tem uma taxa de
fidelidade de 60%, então a taxa de perda de clientes é de 40%. De acordo com a regra de lucratividade do cliente 80/20, 20% dos clientes estão gerando 80% da
receita. Portanto, é muito importante prever os usuários que provavelmente abandonarão o relacionamento comercial e os fatores que afetam as decisões do
cliente.

### **Descrição dos Arquivos**

dataset_treino - arquivos contendo os dados para o treino do algoritmo

dataset_teste -  arquivos contendo os dados para o teste do algoritmo

### **Descrição dos Campos**

- Unnamed: 0: ID do cliente
- state: Estado do cliente (O estudo foi feito nos Estados Unidos)
- area_code: Código de área do cliente
- international_plan: Se o cliente possui plano internacional ou não
- voice_mail_plan: Se o cliente possui plano com voicemail ou não
- number_vmail_messages: Número de mensagens por voicemail feitas pelo cliente
- total_day_minutes: Minutos usados durante o dia
- total_day_calls: Número de ligações feitas no dia
- total_day_charge
- total_eve_minutes: Minutos usados durante a tarde
- total_eve_calls: Número de ligações feitas na tarde
- total_eve_charge
- total_night_minutes: Minutos usados durante a noite
- total_night_calls: Número de ligações feitas na noite
- total_night_charge
- total_intl_minutes: Minutos internacionais
- total_intl_calls: Número de ligações internacionais
- total_intl_charge
- number_customer_service_calls: Número de ligações para o Atendimento ao Cliente
- churn: Variável resposta - se o cliente irá continuar ou cancelar o plano telefônica ('0' = não, '1' = sim)

## **Análise explorátoria**

#### **Variáveis numéricas**
No início do projeto uma análise das variáveis numéricas foi realizada com o objetivo de verificar a distribuição dos dados.

![image](https://user-images.githubusercontent.com/45671820/54853765-82541300-4ccf-11e9-9d9d-35a860c8c177.png)

### **Variáveis categóricas**
Uma análise sobre as variáveis categóricas também foi feita para verificar a distribuição das classes.

![image](https://user-images.githubusercontent.com/45671820/54853822-b7606580-4ccf-11e9-8f68-64836b57931c.png)

![image](https://user-images.githubusercontent.com/45671820/54853836-c0e9cd80-4ccf-11e9-9e18-a2ce7e22e897.png)

![image](https://user-images.githubusercontent.com/45671820/54853856-cba46280-4ccf-11e9-9813-3deb04c4f98a.png)


## **Tratamento dos dados**
Neste projeto as práticas de limpeza dos dados foram:

- Verificação de valores NA, 0 e nulos: Nenhuma anomalia foi encontrada.
- Conversão da variável resposta em fator.
- Exclusão da variáveis Unnamed: 0 referente aos índices dos clientes.
- Remoção de variáveis colineares para evitar queda de desempenho no modelo preditivo.


## **Pré-processamento dos dados**

Na etapa de pré-processamento, as ações tomadas foram:

- Normalização dos dados numéricos.
- Tratamento da variável 'state' através da técnica Label Encoder (recomendado para variáveis com muitas labels).
- Tratamento das demais variáveis categóricas via One-Hot Encoding (OHE).
- Balanceamento da variável resposta ('churn') através da técnica SMOTE. O balanceamento é utilizando quando existe uma classe da variável resposta com um número maior de ocorrências. Essa anomalia pode deixar o modelo preditivo tendencioso e portanto a técnica de balanceamento é utilizada.

## **Criação e avaliação do Modelo Preditivo**
Com os dados tratados, o modelo preditivo de classificação pode ser criado e avaliado. Sendo assim, um boxplot foi criado com o objetivo de apresentar de forma visual uma comparação do desempenho de alguns algoritmos de classificação nos dados de treino, sendo eles:

- LR = LogisticRegression
- LDA = LinearDiscriminantAnalysis
- NB = GaussianNB
- KNN = KNeighborsClassifier
- CART =  DecisionTreeClassifier
- SVM = SVC (Support Vector Classifier)

![image](https://user-images.githubusercontent.com/45671820/54854778-d6acc200-4cd2-11e9-97aa-f5ed2cd83f89.png)

Utilizando como métrica a linha laranja no meio do boxplot, podemos concluir que o melhor modelo que foi criado a partir dos dados de treino foi o algoritmo CART (Decision Tree) com uma acurácia de 83,98%.

Para os dados de teste o algoritmo conseguiu prever as classificações de churn do cliente com uma acurácia ainda maior (85,18%), que pode ser visto através da Confusion Matrix abaixo:

![image](https://user-images.githubusercontent.com/45671820/54855288-88002780-4cd4-11e9-8b15-2216c7b77401.png)


## **Considerações**

O modelo preditivo alcançou um bom nível de acurácia, sendo capaz de acertar se um determinado cliente irá ou não cancelar o plano de telecom com 85% de certeza.
Sendo assim, o projeto buscou apresentar a importância da criação de modelagens preditivas através de Data Science para a alavancagem competitiva das empresas. 
Utilizando o projeto como exemplo, a equipe de Marketing da empresa pode utilizar das previsões do algoritmo para analisar o perfil dos clientes que provavelmente irão se desligar da empresa para criar campanhas personalizadas de retenção, melhora no atendimento, descontos etc...

Como todo modelo preditivo, métodos e ferramentas podem ser usadas ao longo do tempo para aumentar o desempenho do mesmo. Neste caso, podemos citar algumas possíveis como:

- Uso de métodos mais complexos de predição com Deep Learning e Redes Neurais Artificiais.
- Criação de novas variáveis no dataset (uma variável com a soma de minutos e ligações feitas no dia todo, por exemplo.)
- Feature Selection (Seleção de variáveis): Neste projeto todas as variáveis foram utilizadas para a criação do modelo. No entanto, técnicas de feature selection podem ser utilizadas para selecionar as variáveis de maior importância e assim aumentar o desempenho do projeto.


