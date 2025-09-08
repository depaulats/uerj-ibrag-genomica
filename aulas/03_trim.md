# Controle de qualidade NGS

## Atividade 1 - Verificando a qualidade dos dados brutos

Para o controle de qualidade do seu conjunto de dados, você pode usar o software [***FastQC***](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/).

Baixe a versão correspondente para o seu sistema operacional (Windows 10, 64 bits), descomprima o arquivo para uma pasta chamada `FastQC` dentro da pasta `genomica` e execute o script `run_fastqc`. Isto abrirá um aplicativo gráfico para você acessar seus arquivos `.FASTQ` para análise.

Avalie os parâmetros que considerar relevantes para leituras brutas e filtradas. Por exemplo, registre o número total de sequências e bases, faixa de comprimento, %GC, bem como a representação gráfica da qualidade e do conteúdo das sequências e do conteúdo do adaptador.

Você pode salvar todos os relatórios em arquivos HTML e TXT simultaneamente para cada análise, para usá-los novamente mais tarde.

## Atividade 2 - Filtrando leituras brutas

Para filtrar arquivos `.FASTQ`, ou seja, aparar sequências adaptadoras, remover sequências de baixa qualidade e comparar leituras correspondentes (R1 e R2), você pode usar o software [***Trimmomatic***](https://github.com/usadellab/Trimmomatic).

```
conda deactivate # Se você não estiver no ambiente (base)
conda create --name trimmomatic
conda activate trimmomatic
conda install bioconda::trimmomatic
```

Antes de aparar sequências adaptadoras, você precisará das sequências adaptadoras Illumina usadas no experimento em um arquivo FASTA. Neste caso, o experimento [SRR28641204](https://www.ncbi.nlm.nih.gov/sra/?term=SRR28641204), baixado na aula anterior, foi conduzido em um instrumento Illumina NovaSeq 6000, utilizando os adaptadores **NexteraPE**.

Baixe o arquivo `.FASTA` contendo a sequência dos adaptadores para a pasta de trabalho:

```
wget https://raw.githubusercontent.com/depaulats/uerj-ibrag-genomica/main/dados/NexteraPE-PE.fa -P /mnt/c/genomica/
```

Agora execute o comando:

```
trimmomatic PE -threads 8 -phred33 \
/mnt/c/genomica/SRR28641204/SSRR28641204_1.fastq \
/mnt/c/genomica/SRR28641204/SSRR28641204_2.fastq \
/mnt/c/genomica/SRR28641204/SSRR28641204_1_paired.fastq \
/mnt/c/genomica/SRR28641204/SSRR28641204_1_unpaired.fastq \
/mnt/c/genomica/SRR28641204/SSRR28641204_2_paired.fastq \
/mnt/c/genomica/SRR28641204/SSRR28641204_2_unpaired.fastq \
ILLUMINACLIP:/mnt/c/genomica/NexteraPE-PE.fa:2:30:10 \
LEADING:3 TRAILING:3 \
SLIDINGWINDOW:4:20 \
MINLEN:50
```

Após algum tempo, você obterá os arquivos de saída contendo leituras pareadas e não pareadas de R1 e R2. Para suas análises, você deve usar os pares `SSRR28641204_1_paired.fastq` e `SSRR28641204_2_paired.fastq`, que contêm as leituras filtradas e com os pares combinados.

## Atividade 3 - Verificando a qualidade dos dados filtrados

Execute o script `run_fastqc` novamente para abrir o aplicativo [***FastQC***](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/) e analisar os arquivos `.FASTQ` obtidos após a filtragem das leituras.

Avalie os mesmos parâmetros anteriores, comparando os valores obtidos nos dados brutos e depois dos filtros aplicados.

A filtragem dos dados melhorou a qualidade dos dados NGS? Quais foram as mudanças mais notáveis?
