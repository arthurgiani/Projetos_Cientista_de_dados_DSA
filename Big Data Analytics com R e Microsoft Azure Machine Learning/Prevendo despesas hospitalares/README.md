# Prevendo Despesas Hospitalares

Projeto realizado na formação Cientista de Dados da Data Science Academy (DSA)

Para esta análise, vamos usar um conjunto de dados simulando despesas médicas hipotéticas para um conjunto de pacientes espalhados por 4 regiões do Brasil. Esse dataset possui 1.338 observações e 7 variáveis.

### **Descrição dos Arquivos**

dataset.csv - arquivo contendo os dados necessários para a execução do projeto

### **Descrição dos Campos**

- idade - Idade do paciente.
- sexo - Sexo do paciente (masculino ou feminino).
- bmi - Índice de massa corporal medido em peso em kg / (altura em m) ^ 2.
- filhos - Se o paciente tem filhos ou não.
- fumante - Se o paciente fuma ou não.
- região - Região na qual o paciente vive.
- gastos - Total de despesas hospitalares.

![image](https://user-images.githubusercontent.com/45671820/52855326-35957f00-3108-11e9-9790-8d69c4a52fd6.png)

Realizando uma limpeza preliminar dos dados não foram detectados valores missing. Dessa forma, é possível obter algumas informações preciosas iniciando uma análise exploratória.

### **Análise das variáveis numéricas**

![image](https://user-images.githubusercontent.com/45671820/52855360-4ba33f80-3108-11e9-8b99-933276ea2a63.png)

A maioria das despesas hospitalares são de até R$ 10000,00.

![image](https://user-images.githubusercontent.com/45671820/52855390-6b3a6800-3108-11e9-96eb-b2dfb89c4533.png)

O grupo mais representativo da amostra está na faixa dos 20 anos de idade, porém todas as faixas etárias (até aproximadamente 70 anos) estão bem representadas.

![image](https://user-images.githubusercontent.com/45671820/52855445-8efdae00-3108-11e9-9dac-238758071a5c.png)

Considerando que a grande parte da amostra possui BMI igual ou maior que 25, pode-se afirmar que parte de significativa dos pacientes estão ou passaram da marca do sobrepeso (bmi > 30).

![image](https://user-images.githubusercontent.com/45671820/52855527-cec49580-3108-11e9-95ed-c2f04390b026.png)

Na amostra do projeto, pacientes com 4 ou 5 filhos são raros. Em contramão, a maioria possui até 1 filho. Quanto maior a quantidade de filhos, menor o número de pacientes do estudo.

### **Análise das variáveis categóricas isoladas**

![image](https://user-images.githubusercontent.com/45671820/52861514-d6406a80-3119-11e9-89cb-c6cbcf27f405.png)


### **Análise das variáveis categóricas em relação a variável preditora**

![image](https://user-images.githubusercontent.com/45671820/52861837-d4c37200-311a-11e9-94e7-2fbb1d8d2eff.png)

Podemos perceber através destes gráficos que um fumante possui propensão para maiores despesas hospitalares do que pacientes que não fumam. No caso da amostra em estudo, o sexo e a região do paciente não foram fatores de diferenciação.


### **Análise das variáveis numéricas em relação a variável preditora**

![image](https://user-images.githubusercontent.com/45671820/52862549-a8a8f080-311c-11e9-9b2c-c48cd5b544dc.png)

Não existe uma relação linear bem estabelecida entre o BMI e as despesas hospitalares, porém podemos observar um alto número de pacientes com sobrepeso (BMI entre 30 e 40) com gastos hospitalares acima da maioria (entre R$ 35000,00 e R$ 50000,00)

![image](https://user-images.githubusercontent.com/45671820/52862651-e0179d00-311c-11e9-9138-87f0271994b6.png)

Existe uma leve tendencia de linearidade estabelecida entre idade e gastos, ou seja, as despesas hospitalares tendem a aumentar conforme o envelhecimento do paciente.

![image](https://user-images.githubusercontent.com/45671820/52862739-1b19d080-311d-11e9-9fe2-925fe606001e.png)

## **Tratamento dos dados**

Depois de realizar uma análise prévia na massa de dados, é necessário tratá-los para a construção do modelo preditivo. No caso deste estudo, duas ações foram tomadas:

### **1. Manipulação das variáveis categóricas**

As informações referentes ao sexo do paciente, se ele fuma ou não e de sua região são consideradas variáveis categóricas, ou seja, não são numéricas. Partindo da premissa de que os algoritmos de Machine Learning entendem apenas números, é necessários tratar estas informações para que as mesmas possam ser usadas para ajudar na previsão das despesas hospitalares.

Na linguagem Python um método interessante que pode ser usado para esse objetivo é o One-Hot Encoding. Essa função é responsável por transformar essas variáveis em números binários, permitindo assim o uso desses dados no algoritmo. Sendo assim, ocorrem os seguintes procedimentos que podem ser vistos na imagem abaixo (utilizando como exemplo a variável "fumante"):

- A variável antes ocupava uma coluna do dataframe. Agora, cada opção dentro dessa variável assume uma coluna (existirá uma coluna 'fumantes_sim' e outra 'fumantes_nao'.
- Se o paciente for fumante, a coluna 'fumante_sim' receberá o valor 1 e as restantes receberão valor 0.
- O processo ocorre de forma similar para as variáveis "sexo" e "região".

![image](https://user-images.githubusercontent.com/45671820/52879774-30a3f000-3147-11e9-8f13-a81d5be5d8c7.png)

### **2. Normalização das colunas numéricas**

De forma geral, cada variável numérica traz uma informação diferente como altura, tamanho, peso, velocidade e outras dezenas de opções. Cada uma dessas informações é medida em uma escala diferente (metros, km/h, kg etc), sendo assim muitas vezes é necessário aplicar práticas de normalização destes dados, que nada mais é do que uma forma de "alinhar" todos esses diferentes dados em uma mesma escala.

Portanto, a normalização das colunas "idade", "bmi" e "filhos" foi feita utilizando o método máximo-mínimo, onde todas as observações de cada uma dessas variáveis foram ajustadas utilizando a fórmula abaixo:

![image](https://user-images.githubusercontent.com/45671820/52880156-58e01e80-3148-11e9-8948-d0956b65b9cd.png)

Onde:

- Zi = Observação a ser normalizada.
- Zmin = Valor mínimo da variável.
- Zmax = Valor máximo da variável.

Feito a etapa de tratamento dos dados, podemos finalmente iniciar a construção do modelo de Machine Learning.

## **Construção do Modelo Preditivo**

### **1. Definição das variáveis importantes para a previsão das despesas hospitalares**

Para determinarmos quais variáveis serão usadas para a construção do modelo, foi utilizado a matriz de correlação qual a força da relação das variáveis preditoras com a variável "gastos".

![image](https://user-images.githubusercontent.com/45671820/52881693-6dbeb100-314c-11e9-8a73-b656c7355531.png)

Os quadrados circulados em vermelho indicam as variáveis que possuem algum grau significativo de relação com os gastos hospitalares, sendo que a única a apresentar correlação forte (> |70%|) foi a referente ao fato do paciente fumar ou não .

A presença de filhos na família, diferença de sexo ou região não apresentam impacto significativo na quantia média gasta em hospitais de acordo com a análise dos dados. Porém, é sensato deduzir que um paciente que possua mais filhos tenha uma tendência a ter mais despesas hospitalares pelo fato da probabilidade de uma ocorrência médica aumentar.

Como possível causa desse "desencontro" entre a análise de dados e as conclusões obtidas a partir da observação do mundo real, pode-se apontar o alto número pacientes no dataset que possuem 0 filhos (mostrado na seção de histogramas). Sendo assim, o tamanho da amostra do estudo em questão pode não ter sido suficiente para que essa relação fosse aprendida pelo modelo de correlação. Porém é de responsabilidade do cientista de dados analisar o mundo a sua volta e, se necessário, considerar importantes algumas variáveis que por alguma razão o modelo não considere. 

Sendo assim, as colunas que serão utilizadas para a modelagem serão:
- idade
- bmi
- fumante_sim
- fumante_nao
- filhos

### **2. Criação e teste do modelo preditivo**

O dataset original foi divido na proporção de 75% para treino e 25% para teste. Sendo assim, o algoritmo da Regressão Linear foi utilizado para verificar a precisão na qual podemos prever a despesa hospitalar dos pacientes da amostra.

![image](https://user-images.githubusercontent.com/45671820/52881877-0d7c3f00-314d-11e9-929d-0e130d9f5b87.png)

Como pode ser visto na imagem acima, o modelo treinado teve um resultado de 73,2% de precisão. Resta então verificar o desempenho do modelo nos dados de teste.

![image](https://user-images.githubusercontent.com/45671820/52882196-115c9100-314e-11e9-9c17-abb4346d485a.png)

Pode-se concluir então que o modelo preditivo criado a partir da regressão linear foi capaz de prever as despesas hospitalares com 79,5% de precisão.

### **3. Análise dos resíduos**

Uma boa prática de análise consiste também em verificar o compartamento dos resíduos do modelo, ou seja, a diferença entre a despesa prevista e a despesa real. Um bom modelo preditivo apresentará os resíduos em formato de distribuição normal com a maioria dos valores próximos a média da amostra, indicando que a maioria das previsões foram certeiras ou com um baixo grau de distorção em relação aos valores originais.

![image](https://user-images.githubusercontent.com/45671820/52882451-dc047300-314e-11e9-836b-4af8bdacde8a.png)

Por mais que a maioria dos valores tenham se concentrado ao redor da média é possível perceber distorções dessa distribuição em valores outliers (para +- R$ 10000,00 - R$ 15000,00). Sendo assim, outro algoritmo será testado para verificar a possibilidade de um modelo preditivo que realize as previsões de forma mais acertiva, de forma a reduzir a ocorrência destes valores extremos.

## **Construção do Modelo Preditivo pelo algoritmo RandomForest**

O algoritmo RandomForest nada é mais é do que um conjunto de arvores de regressão que aprendem a relação entre os dados da amostra criando nós de decisão. Para cada nó há dois caminhos possíveis para se percorrer e essa sucessão de decisões indicam, no final da árvore, qual a melhor decisão a ser tomada (no nosso caso, a despesa que tem a maior probabilidade de ocorrer de acordo com os padrões de entrada).

![image](https://user-images.githubusercontent.com/45671820/52883120-01927c00-3151-11e9-9b00-155e4ebecf37.png)

No conjunto de teste o algoritmo foi capaz de prever as despesas hospitalares com 85,2% de precisão

### **Análise dos resíduos**

![image](https://user-images.githubusercontent.com/45671820/52883308-a2813700-3151-11e9-84f3-ea4f9e3577c4.png)

A comparação gráfica reforça a precisão elevada do algoritmo RandomForest em relação ao modelo de regressão linear, apresentando uma maior concentração de resíduos em torno da medida central e a rara ocorrência de eventos outliers.




















