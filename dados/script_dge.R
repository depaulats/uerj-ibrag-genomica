# Este script é uma adaptação do tutorial 
# "Analyzing RNA-seq data with DESeq2 (https://doi.org/10.1186/s13059-014-0550-8)"
# Disponível em https://introtogenomics.readthedocs.io/en/latest/2021.11.11.DeseqTutorial.html
# Acessado em 11/10/2025

# Configurando a pasta de trabalho

if (!dir.exists("C:/genomica/R/")) {dir.create("C:/genomica/R/", recursive = TRUE)}
path <- "C:/genomica/R/"
setwd("C:/genomica/R/")
sink("DGE_script_console_output.log", split = TRUE)


# Instalando e carregando bibliotecas

if(!require("htmltools")) { install.packages("htmltools"); library("htmltools") }
if(!require("ggplot2")) { install.packages("ggplot2"); library("ggplot2") }
if(!require("BiocManager")) { install.packages("BiocManager"); library("BiocManager") }
if(!require("DESeq2")) { BiocManager::install("DESeq2"); library("DESeq2") }
if(!require("pheatmap")) { install.packages("pheatmap"); library("pheatmap") }
if(!require("dplyr")) { install.packages("dplyr"); library("dplyr") }
if(!require("pasilla")) { BiocManager::install("pasilla"); library("pasilla") }
if(!require("apeglm")) { BiocManager::install("apeglm"); library("apeglm") }
if(!require("DEGreport")) { BiocManager::install("DEGreport"); library("DEGreport") }
if(!require("tidyverse")) { install.packages("tidyverse"); library("tidyverse") }


# Importando os dados de contagem do pacote 'pasilla'
# https://bioconductor.org/packages/release/data/experiment/html/pasilla.html
# O experimento estudou o efeito da redução de RNAi do gene Pasilla no transcriptoma de Drosophila melanogaster
# O gene passilla é dos genes NOVA1 e NOVA2 genes codificam proteínas de ligação ao RNA neuronal ...
# ... que regulam o splicing alternativo, um processo crítico para o desenvolvimento e função neural.

pasCts <- system.file("extdata",
                      "pasilla_gene_counts.tsv",
                      package="pasilla", mustWork=TRUE)
pasAnno <- system.file("extdata",
                       "pasilla_sample_annotation.csv",
                       package="pasilla", mustWork=TRUE)
cts <- as.matrix(read.csv(pasCts,sep="\t",row.names="gene_id"))
coldata <- read.csv(pasAnno, row.names=1)
coldata <- coldata[,c("condition","type")]
coldata$condition <- factor(coldata$condition)
coldata$type <- factor(coldata$type)


# Contagens brutas de genes

as_tibble(cts)


# Metadados

coldata


# Observe que elas não estão na mesma ordem em relação às amostras!

rownames(coldata)
colnames(cts)
all(rownames(coldata) %in% colnames(cts))


#Precisamos remover o "fb" dos nomes das linhas do coldata para que a nomenclatura fique consistente

rownames(coldata) <- sub("fb", "", rownames(coldata))
all(rownames(coldata) %in% colnames(cts))


# Verifique se a ordem é a mesma

all(rownames(coldata) == colnames(cts))


# Reordenar as colunas de cts com base na ordem das linhas de metadados (coldata)

cts <- cts[, rownames(coldata)]
all(rownames(coldata) == colnames(cts))


# Com a matriz de contagem, cts, e as informações da amostra, coldata, podemos construir um DESeqDataSet:

dds <- DESeqDataSetFromMatrix(countData = cts,
                              colData = coldata,
                              design = ~ condition)
dds


# Dados de recursos adicionais podem ser adicionados ao DESeqDataSet 
# Vamos adicionar dados redundantes apenas para demonstração

featureData <- data.frame(gene=rownames(cts))
mcols(dds) <- DataFrame(mcols(dds), featureData)
mcols(dds)


# Pré-filtragem no DESeq2
# Não necessário mas útil ao reduzir o uso de memória e acelerar funções
# Manteremos genes com ≥10 leituras totais

keep <- rowSums(counts(dds)) >= 10
dds <- dds[keep,]


# Definindo níveis de referência
# Por padrão, a ordem alfabética será usada para escolher um nível de referência
# Podemos definir explicitamente os níveis dos fatores usando o argumento relevel

dds$condition <- factor(dds$condition, levels = c("untreated","treated"))
dds$condition <- relevel(dds$condition, ref = "untreated")


# Análise de expressão diferencial 
# Testa diferenças na contagem de genes entre dois ou mais grupos 

dds <- DESeq(dds)
res <- results(dds)
res


# A tabela de resultados contém informações importantes

mcols(res)$description

# As mais impostantes são:
# Nome da linha [rownames]: indicando o ID do gene
# baseMean             [1]: nível de expressão médio em todas as amostras normalizadas pela profundidade do sequenciamento
# log2FoldChange       [2]: mudança na expressão genética entre controle e tratamento
# padj                 [6]: valor p ajustado para múltiplos testes



# Se os níveis de referência não tivessem sido explicitados com relevel...
# ... poderíamos ter especificado o contraste para construir uma tabela de resultados com ...
# ... qualquer um dos seguintes comandos abaixo (após remover os comentários '#')

# res <- results(dds, name="condition_treated_vs_untreated")
# res <- results(dds, contrast=c("condition","treated","untreated"))


# Redução do tamanho do efeito (log2FoldChange, LFC) para visualização e classificação
# Para reduzir LFC, passamos o objeto 'dds' pela função 'lfcShrink'. 
# Abaixo, usamos um método que aprimora o estimador anterior, 'apeglm' (Zhu, Ibrahim e Love 2018)

resultsNames(dds)
resLFC <- lfcShrink(dds, coef="condition_treated_vs_untreated", type="apeglm")


# Notou alguma diferença nos valores em lfcSE comparado a res?

resLFC


# valores de p ajustados
# Podemos ordenar nossa tabela de resultados pelo menor valor de p...

resOrdered <- res[order(res$pvalue),]


# ... e resumir algumas contagens básicas usando a função 'summary'

summary(res)


# Por padrão, o o nível de significância é definido como alfa = 0,1.
# O valor de alfa pode ser redefinido como o comando:  

res05 <- results(dds, alpha=0.05)
summary(res05)
sum(res05$padj < 0.05, na.rm=TRUE)


# MA-plot
# Essa função mostra o tamanho do efeito de uma determinada variável ...
# ... sobre a média das contagens normalizadas para todas as amostras
# Os pontos em vermelho tem valor de p significativo.
# Os triângulos abertos para cima ou para baixo indicam valors fora da área do gráfico.

plotMA(res, ylim=c(-2,2))


# É mais útil visualizar os resultados do tamanho do efeito reduzido ...
# ... pois removem o ruído associado às mudanças promovidas por genes de baixa contagem 

plotMA(resLFC, ylim=c(-2,2))


# Plotagem de leituras
# Normalizamos as contagens por profundidade de sequenciamento e agrupamos as variáveis 
# Aqui, especificamos o gene que apresentou o menor valor de p da tabela de resultados 
# Podemos selecionar o gebne a ser usado pelo nome da linha ou por índice numérico.

plotCounts(dds, gene=which.min(res$padj), intgroup="condition")


# Podemos personalizar o gráfico com os comandos 

d <- plotCounts(dds, gene=which.min(res$padj), intgroup="condition", 
                returnData=TRUE)

ggplot(d, aes(x=condition, y=count)) + 
  geom_point(position=position_jitter(w=0.1,h=0)) + 
  scale_y_log10(breaks=c(25,100,400)) +
  labs(
  x = "Condition",
  y = "Count (log10)",
  title = "Count Plot"
  )


# Gráficos de genes principais

degPlot(dds = dds, res = res, n = 9, xs = "condition")

top_genes <- rownames(res[order(res$padj, na.last = NA), ][1:9, ])
top_genes_res <- res[top_genes, ]


# Gráfico de vulcão

ggplot(res, aes(x = log2FoldChange, y = -log10(padj))) +
  geom_point(aes(color = case_when(
    -log10(padj) <= 2 ~ "Not significant",
    log2FoldChange > 0 ~ "Upregulated",
    log2FoldChange < 0 ~ "Downregulated"
  ))) +
  scale_color_manual(
    name = "Expression",  
    values = c("Not significant" = "gray", "Upregulated" = "red", "Downregulated" = "green")
  ) +
  labs(
    x = "log2 Fold Change",
    y = "-log10 Adjusted p-value",
    title = "Volcano Plot"
  ) +
  geom_text(
    data = top_genes_res,
    aes(label = rownames(top_genes_res)),
    vjust = -0.5,
    size = 3
  )


# Exportando resultados para arquivos CSV

write.csv(as.data.frame(resOrdered), 
          file="condition_treated_results.csv")


# Exportando somente os resultados significativos

resSig <- subset(resOrdered, padj < 0.1)
resSig
write.csv(as.data.frame(resSig), 
          file="signif_condition_treated_results.csv")


# Transformações de dados de contagem
# Os testes anteriores operam com contagens brutas e distribuições discretas
# Para outras análises pode ser necessário transformar dos dados de contagem


# Transformação estabilizadora de variância

vsd <- vst(dds)
head(assay(vsd), 3)


# Avaliação da qualidade dos dados por meio de agrupamento e visualização de amostras
# Perfis de expressão de múltiplos genes pode ser analisados simultaneamente com mapas de calor (heatmaps)

select <- order(rowMeans(counts(dds,normalized=TRUE)),
                decreasing=TRUE)[1:20]
df <- as.data.frame(colData(dds)[,c("condition","type")])
pheatmap(assay(vsd)[select,], cluster_rows=FALSE, show_rownames=FALSE,
         cluster_cols=FALSE, annotation_col=df)


# Mapa de calor das distâncias entre amostras
# Visão geral das similaridades e dissimilaridades entre as amostras
# Precisamos primeiro criar uma matrix de distância ...

sampleDists <- dist(t(assay(vsd)))


# ... e fornecer um agrupamento hierárquico para a função de mapa de calor 

sampleDistMatrix <- as.matrix(sampleDists)
rownames(sampleDistMatrix) <- paste(vsd$condition, vsd$type, sep="-")
colnames(sampleDistMatrix) <- NULL
colors <- colorRampPalette( rev(brewer.pal(9, "Blues")) )(255)
pheatmap(sampleDistMatrix,
         clustering_distance_rows=sampleDists,
         clustering_distance_cols=sampleDists,
         col=colors)


# Análise de componentes principais das amostras

plotPCA(vsd, intgroup=c("condition", "type"))


# Finalizando as analises

sink()
