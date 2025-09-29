# Este script é uma adaptação do tutorial 
# "Calculating genetic differentiation and clustering methods from SNP data"
# Disponível em https://popgen.nescent.org/DifferentiationSNP.html
# Acessado em 29/09/2025

# Configurando a pasta de trabalho

dir.create("C:/genomica/R/")
path <- "C:/genomica/R/"
setwd("C:/genomica/R/")
sink("console_output.log", split = TRUE)


# Carregando bibliotecas

if(!require("adegenet")) install.packages("adegenet")
if(!require("hierfstat")) install.packages("hierfstat")


# Baixando os dados

download.file("https://raw.githubusercontent.com/depaulats/uerj-ibrag-genomica/main/dados/Master_Pinus_data_genotype.txt", 
              "Master_Pinus_data_genotype.txt")


# Configurando os arquivos para análise


# Lendo a tabela e criando a lista de nomes

Mydata <- read.table("Master_Pinus_data_genotype.txt", header = TRUE, check.names = FALSE)   
dim(Mydata) # 550 indivpiduos x 3086 SNPs
ind <- as.character(Mydata$tree_id) # Nomes dos indivíduos
population <- as.character(Mydata$state) # Nomes das populações
county <- Mydata$county 


# Convertendo a tabela

locus   <- Mydata[, 5:24] # Delimitando os dados a somente 20 SNPs para afilizar os cálculos
Mydata1 <- df2genind(locus, ploidy = 2, ind.names = ind, pop = population, sep = "")
Mydata1
Mydata2 <- genind2hierfstat(Mydata1) 


# Calculando estatísticas básicas


# Fst sensu Nei (1987; https://doi.org/10.7312/nei-92038)

basic.stats(Mydata1) 


# Estimativas de Weir & Cockerham (1984; https://doi.org/10.2307/2408641)

wc(Mydata1) 


# Análise hierárquica de Fst (=AMOVA para SNPs ou marcadores bialélicos)


# Removendo a coluna das populações
loci <- Mydata2[, -1]


# Na análise hierárquica de Fst indivíduos são permutados aleatoriamente entre os estados

varcomp.glob(levels = data.frame(population, county), loci, diploid = TRUE)


# Testando o efeito da população na diferenciação genética

test.g(loci, level = population) 


# Permutando os condados entre os estados para estimar a significância dos estados na estruturação genética.

test.between(loci, test.lev = population, rand.unit = county, nperm = 100) 


# Fst pareado

genet.dist(Mydata1, method = "WC84")


# Agrupamento não-supervisionado


# Estabelecendo uma semente para um resultado consistente

set.seed(20160308) # 


# Usando Kmeans e DAPC no pacote 'adegenet'

grp <- find.clusters(Mydata1, max.n.clust = 10, n.pca = 20, choose.n.clust = FALSE) 
names(grp)


# Como ainda não conhecemos as poipulações (estamos procurando por elas)...
# ... usamos o número máximo possível de eixos PCA, que é SNP = 20 aqui.
# Para mais informações veja para mais informações https://github.com/thibautjombart/adegenet/raw/master/tutorials/tutorial-basics.pdf


# Quanto grupos o procedimento K-means detectou? 

grp$grp 


# Conduzindo análise discriminante com 6 grupos

dapc1 <- dapc(Mydata1, grp$grp, n.pca = 20, n.da = 6) 


# Viasualizando os resultados 

scatter(dapc1)


# Salvando a imagem

png("scatter_dapc.png", 
    width = 800, 
    height = 600, 
    units = "px", 
    res = 150)
scatter(dapc1)
dev.off()


# Finalizando as analises

sink()


# Conclusões

# O que aprendemos hoje neste script?

# Calcular Fst em populações existentes, e

# Investigar o efeito da estrutura populacional na diferenciação genética por meio da análise hierárquica de Fst,

# Realizamos uma análise multivariada para investigar a estrutura genética dos dados em nível individual.
