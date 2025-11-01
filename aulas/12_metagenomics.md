# Análise de Metagenomas

## Atividade 1 - Montagem *de novo* de Metagenomas

Se você não tiver o software Megahit instalado, instale-o usando o Conda em seu próprio ambiente.

    conda create --name megahit
    conda activate megahit
    conda install bioconda::megahit

Execute o software Megahit para montar sequências contíguas (contigs) a partir de leituras curtas. 
Iremos usar os dados gerados na [Aula 3: Controle de Qualidade NGS](https://github.com/depaulats/uerj-ibrag-genomica/blob/main/aulas/03_quality.md).

    megahit -1 /mnt/c/genomica/SRR28641204/SRR28641204_1_paired.fastq \
            -2 /mnt/c/genomica/SRR28641204/SRR28641204_2_paired.fastq \
            --out-dir /mnt/c/genomica/SRR28641204/Megahit
    
Após algum tempo, os contigs serão montados. 

- Quantas contig foram recuperados?
- Quantas bases eles apresentam no total?
- Quais são maior e o menor contig?
- Qual o tamanho mediano dos contigs gerados?



## Atividade 2 - Visualização dos grafos de montagem

Vamos usar o Bandage para visualizar grafos de montagem *de novo*, e exibir conexões que não estão presentes no arquivo de contigs.

Mas antes precisamos converter o arquivo FASTA com os contigs intermediários para o formato FASTG, semelhante ao SPAdes. 
Vamos fazer isso para um determinado comprimento de k-mer, por exemplo os contigs de k-mer 99 estão salvos no arquivo `k99.contigs.fa`.

    cd /mnt/c/genomica/SRR28641204/Megahit/intermediate_contigs/
    megahit_toolkit contig2fastg 99 k99.contigs.fa > k99.fastg

Vamos baixar agora o programa [Bandage v0.8.1 para Windows](https://github.com/rrwick/Bandage/releases/download/v0.8.1/Bandage_Windows_v0_8_1.zip) clicando no link e descompatar o arquivo para uma pasta `Bandage` dentro da pasta de trabalho `genomica`.

Executando o arquivo `Bandage.exe`, vamos abrir o arquivo com os grafos `k99.fastg` navegando em em *File > Load graph*, e em seguida desenhamos os grafos clicamos em *Draw graph*.

Algumas vantagens em visualizar grafos:

- Avaliar e comparar a qualidade de montagens de forma rápida e visual;
- Identificar regiões problemáticas em uma montagem;
- Resolver ambiguidades no grafo para aprimorar ou completar montagens *de novo*;
- Determinar quais outros nós possuem sequências contíguas a um nó de interesse;
- Anotar imagens do grafo para ilustrar características da montagem; e
- Extrair sequências candidatas que se estendem por múltiplos nós.

Você pode apontar alguma delas?

## Atividade 3 - Anotação funcional de metagenomas

Para a anotação funcional vamos usar a plataforma [Galaxy](https://usegalaxy.org/). Não esqueça de fazer seu *login*.


