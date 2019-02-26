# Análise de Risco de Crédito

O seguinte projeto visa oferecer uma solução para a construção de um modelo preditivo que realize a análise de crédito de um cliente com o objetivo de prever com base em dados passados se o mesmo tem condições de receber um empréstimo de um banco. O dataset contém informações de 1000 clientes de um banco aleatório e faz parte de um dos projetos da formação Cientista de Dados da Data Science Academy (DSA).

### **Descrição dos Arquivos**

credit_dataset.csv - arquivo contendo os dados necessários para a execução do projeto

### **Descrição dos Campos**

- account.balance: Saldo por mês na conta do cliente (US$)
- credit.duration.months: Tempo para pagamento do empréstimo
- previous.credit.payment.status: Histórico de crédito do cliente
- credit.purpose: Qual o motivo da solicitação do empréstimo
- credit.amount: Valor do empréstimo (US$)
- savings: Saldo na poupança
- employment.duration: Tempo empregado atualmente (ou se está desempregado)
- installment.rate: Porcentagem do salário na qual o empréstimo corresponde
- marital.status: situação conjugal
- guarantor: se existe alguém que se compromete em assumir a dívida no caso do não pagamento do empréstimo
- residence.duration: Tempo morando na mesma residência
- current.assets: Se o cliente possui ativos
- age: Idade do cliente
- other.credits: Se o cliente obteve outras linhas de crédito
- apartment.type: Tipo da moradia
- bank.credits: Número de créditos obtidos neste banco
- ocupation: Qual o tipo de profissão do cliente
- dependents: Se o cliente possui dependentes
- telephone: Se o cliente possui telefone
- foreign.worker: Se o cliente é ou não estrangeiro
- credit.rating: variável a ser prevista (0 = Bom pagador, 1 = Mau pagador)


![image](https://user-images.githubusercontent.com/45671820/53039408-ed56c380-345d-11e9-8f3c-a2a80b884c66.png)


## **Tratamento dos dados**
### **Pré-Processamento e Limpeza**

O dataset já havia passado por um processo preliminar de limpeza porém algumas técnicas foram aplicadas com o objetivo de completar etapa, sendo elas:

- Verificação de valores missing (nenhum encontrado).
- Normalização das colunas numéricas através do método dos máximos-mínimos ('age', 'credit.duration.months' e 'credit.amount').
- Conversão para fator das colunas restantes (variáveis categóricas).

### **Balanceamento dos dados**
O gráfico abaixo nos mostra que a amostra de 1000 clientes está desbalanceada com uma predominância significa de mau pagadores de crédito ('1'), podendo gerar tendências durante o treinamento do modelo preditivo.

![image](https://user-images.githubusercontent.com/45671820/53051829-ea6acb80-347b-11e9-9aee-a2c5d2188a43.png)

Dessa forma, a técnica de oversampling SMOTE foi utilizada para balancear o dataset. Essa amostra consiste em criar observações da classe minoritária (no caso, bons pagadores '0').

![image](https://user-images.githubusercontent.com/45671820/53042748-bedce680-3465-11e9-95f7-b8164c3cda4d.png)

Graças ao SMOTE o dataset agora conta com 1200 observações.

## **Análise explorátoria**

Nesta seção serão apresentados alguns dos insights obtidos durante a realização da análise exploratória. Todos os gráficos e análises a respeito das variáveis podem ser encontrados no script R que está disponível neste repositório.

### **Variáveis categóricas x Risco de Crédito**
Os números '0' e '1' acima do gráfico indicam a situação do crédito do cliente (0 = Bons pagadores, 1 = Maus Pagadores)

![image](https://user-images.githubusercontent.com/45671820/53042706-acfb4380-3465-11e9-90b6-59b5a76af1f9.png)

A proporção de trabalhadores estrangeiros ('0') ou não ('1') é a mesma tanto para a classe dos bons pagadores quanto para a dos maus pagadores. O mesmo vale a para a variável 'dependents', por exemplo.

![image](https://user-images.githubusercontent.com/45671820/53042849-f186df00-3465-11e9-8066-147aa9ab85a2.png)

No entanto a análise exploratória foi capaz de apontar algumas variáveis que possuem diferenças significativas de distribuição entre bons e maus pagadores, como o fato do cliente possuir saldo em conta (account.balance), sua situação de emprego (employment.duration), e se o cliente solicitante já quitou os outros empréstimos no qual estava envolvido (previous.credit.payment.status). 


![image](https://user-images.githubusercontent.com/45671820/53043242-cfda2780-3466-11e9-89eb-113ad86cc968.png)

![image](https://user-images.githubusercontent.com/45671820/53043269-dbc5e980-3466-11e9-8aad-d67b646d56bf.png)

![image](https://user-images.githubusercontent.com/45671820/53043349-057f1080-3467-11e9-9f52-11fc6d02675c.png)

### **Variáveis Numéricas**

![image](https://user-images.githubusercontent.com/45671820/53092202-e7f78880-34f2-11e9-8f3c-810406c2902e.png)

Os clientes são em sua maioria jovens de 20 a 40 anos.

![image](https://user-images.githubusercontent.com/45671820/53092262-11181900-34f3-11e9-9a3b-c077b3c23087.png)

A maioria dos empréstimos solicitados possuem prazo de pagamento de até 24 meses.

![image](https://user-images.githubusercontent.com/45671820/53092366-62280d00-34f3-11e9-90d0-6378f0ac6e2d.png)

As solicitações de empréstimo geralmente possuem valores pequenos (Até US$ 5000).

## **Feature Selection (Seleção de variáveis importantes)**

Para definir quais variáveis serão usadas na construção do modelo, o pacote 'caret' foi usado por meios das funções 'trainControl', 'train' e 'varImp'. Sendo assim, as variáveis de maior score serão selecionadas a partir dos seguintes requisitos:

- Variáveis iguais ou maiores que 60% correlação: Serão incluídas no modelo.
- Variáveis entre 55 e 60% de correlação: Serão adicionadas uma a uma no treinamento do modelo. Caso a variável apresente aumento na precisão a variável será incluída.
- Demais Variáveis: Descartar do modelo.

![image](https://user-images.githubusercontent.com/45671820/53052577-da53eb80-347d-11e9-9178-768221f2c54e.png)

Tomando como referência as informações das imagens acima, as variáveis escolhidas para a construção do modelo foram:

- account.balance
- credit.duration.months
- credit.amount 
- current.assets
- previous.credit.payment.status
- employment.duration
- credit.purpose

## **Criação do Modelo Preditivo (RandomForest x Regressão Logística)**

O dataset foi divido entre dados de treino/teste na proporção 80/20 e o modelo de machine learning foi feito a partir de dois algoritmos:

**RandomForest**: Esse método consiste na criação de árvores de decisão que irão direcionar a classificação de um determinado objeto de acordo com o que foi aprendido pelo modelo durante a fase de treino por meio dos nós de decisão (confira a figura abaixo):

![image](https://user-images.githubusercontent.com/45671820/53093389-0e6af300-34f6-11e9-87a0-fe43bbe590f7.png)

**Regressão Logística**: Assim como o modelo linear, a regressão logística também verifica a relação das variáveis para realizar previsões. No entanto, esse método é usado em tarefas de classificação binária (bom ou mau pagador).

Sendo assim os dois modelos foram construídos utilizando as sete variáveis escolhidas na etapa de Feature Selection, e os 240 clientes de teste (20% do dataset balanceado) foram usados para verificar a acurácia das previsões. O resultado pode ser visto no comparativo abaixo:

![image](https://user-images.githubusercontent.com/45671820/53095171-e16d0f00-34fa-11e9-89a7-eb91243e6cdc.png)

Através dos níveis de precisão é possível verificar que o algoritmo RandomForest obteve um melhor desempenho do que o modelo de regressão logística apresentando uma precisão de 83,75%.

A diferença de desempenho também pode ser vista através da curva ROC, evidenciando ainda mais a eficácia do método RandomForest. A curva ROC mostra o quão bom o modelo é capaz de diferenciar as classes (no caso, bons e maus pagadores) por meio da Área sobre a Curva (AUC). Quanto maior a AUC, melhor é o modelo preditivo.

![image](https://user-images.githubusercontent.com/45671820/53095733-568d1400-34fc-11e9-882b-00ca2d44a35a.png)

## **Considerações**

Pelo fato do projeto ter sido realizado em uma massa de dados relativamente limpa, o trabalho nesta apresentação foi mais direcionado em evidenciar a parte de análise exploratória e construção do modelo preditivo. Mesmo assim, técnicas adicionais de tratamento dos dados podem sempre ser utilizadas com o intuito de aumentar a precisão como por exemplo a remoção de valores outliers.

O processo de Machine Learning é essencialmente iterativo, ou seja, é uma atividade que é otimizada por meio de constantes testes e revisões dentro do mesmo projeto. Dessa forma, utilizar diferentes algoritmos é uma alternativa interessante para o cientista de dados que busca maior acurácia em seu modelo. Existem dezenas de metodologias diferentes e cada uma delas pode ser a melhor opção dependendo do problema de negócio.















