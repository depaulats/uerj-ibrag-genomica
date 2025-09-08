# Controle de qualidade NGS

## Atividade 1 - Verificando a qualidade do sequenciamento NGS

Para o controle de qualidade do seu conjunto de dados, você pode usar o software [***FastQC***](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/).

Baixe a versão correspondente para o seu sistema operacional (Windows 10, 64 bits), descomprima o arquivo para uma pasta chamada `FastQC` dentro da pasta `genomica` e execute o script `run_fastqc`. Isto abrirá um aplicativo gráfico para você acessar seus arquivos FASTQ para análise.

Avalie os parâmetros que considerar relevantes para leituras brutas e filtradas. Por exemplo, registre o número total de sequências e bases, faixa de comprimento, %GC, bem como a representação gráfica da qualidade e do conteúdo das sequências e do conteúdo do adaptador.

Você pode salvar todos os relatórios em arquivos HTML e TXT simultaneamente para cada análise, para usá-los novamente mais tarde.

## Filtrando leituras brutas

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
/mnt/c/MARRIO_genomics/SRR7464845/SRR7464845_1.fastq \
/mnt/c/MARRIO_genomics/SRR7464845/SRR7464845_2.fastq \
/mnt/c/MARRIO_genomics/SRR7464845/SRR7464845_1_paired.fastq \
/mnt/c/MARRIO_genomics/SRR7464845/SRR7464845_1_unpaired.fastq \
/mnt/c/MARRIO_genomics/SRR7464845/SRR7464845_2_paired.fastq \
/mnt/c/MARRIO_genomics/SRR7464845/SRR7464845_2_unpaired.fastq \
ILLUMINACLIP:/mnt/c/MARRIO_genomics/TruSeq3-PE-2.fa:2:30:10 \
LEADING:3 TRAILING:3 \
SLIDINGWINDOW:4:20 \
MINLEN:50
```

Após algum tempo, você obterá os arquivos de saída contendo leituras pareadas e não pareadas de R1 e R2. Você deve usar os pares `SRR7464845_1_paired.fastq` e `SRR7464845_2_paired.fastq`.

## Controle de qualidade

Para o controle de qualidade do seu conjunto de dados, você pode usar o software [***FastQC***](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/).

Baixe a versão correspondente para o seu sistema operacional e execute o script `run_fastqc`. Ele abrirá um aplicativo gráfico para você acessar seus arquivos FASTQ para análise.

Avalie todos os parâmetros que considerar relevantes para leituras brutas e filtradas. Por exemplo, compare sequências totais, bases, comprimento, %GC, bem como a representação gráfica da qualidade e do conteúdo da sequência e do conteúdo do adaptador.

Você pode salvar todos os relatórios em arquivos HTML e TXT simultaneamente para cada análise, para usá-los novamente mais tarde.

Agora que você tem dados filtrados com todos os parâmetros de controle de qualidade necessários, você pode [mapear essas leituras em relação a uma sequência de referência](https://github.com/depaulats/MARRIO_genomics/blob/main/map.md).

Ou você pode voltar aos [tutoriais](https://github.com/depaulats/MARRIO_genomics/blob/main/tutorials.md).
