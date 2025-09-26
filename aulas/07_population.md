# Análise populacional genômica 

Este tutorial foi traduzido e adaptado do [Manual do Stacks](https://catchenlab.life.illinois.edu/stacks/manual/).

# Atividade 1 - Obtenção e limpeza de dados de RADseq

Faço o download dos dados de RADseq disponíveis no NCBI-SRA usando o programa `fastq-dump`, disponível como parte do [***SRA Tools***](https://github.com/ncbi/sra-tools).

```
conda deactivate  # If you are not at (base) environment
conda activate sratools
mkdir -p /mnt/c/genomica/stacks/raw && cd /mnt/c/genomica/stacks/
fasterq-dump SRR20082728 -O ./raw --split-files --threads 8 --progress
fasterq-dump SRR20082764 -O ./raw --split-files --threads 8 --progress
fasterq-dump SRR20082787 -O ./raw --split-files --threads 8 --progress
```

Os dados são de três indivídus de peixe-gelo-cavala (*Champsocephalus* sp.), sequenciado em pares em uma biblioteca RADseq de digestão única usando a enzima de restrição SbfI ([Rivera-Colón et al., 2023](https://doi.org/10.1093/molbev/msad029)).

SRR20082728	C.gunnari S Georgia 25
SRR20082764	C.gunnari W Antarctic Peninsula 11
SRR20082787	C.esox Strait Magellan 12

Após baixar os arquivos pareados, denominados pelo némero de acesso e os sufixos `_1.fastq.gz` e `_2.fastq.gz`, iremos prosseguir com o [***Stacks***](https://catchenlab.life.illinois.edu/stacks).

Para tal, precisaremos instalá-lo via Bioconda.

```
conda deactivate  # If you are not at (base) environment
conda create -n stacks
conda activate stacks
conda install bioconda::stacks
```

Agora podemos prosseguir com a limpeza dos dados, aplicando filtros de qualidade (--clean e --quality), especificando e recuperando o local de corte do SbfI (--renz-1 sbfI e --rescue) e habilitando manualmente a filtragem de execuções poly-G (--force-poly-g-check). Além disso, queremos aplicar um nome mais informativo aos arquivos resultantes, que podemos especificar usando a opção --basename.

```
mkdir -p /mnt/c/genomica/stacks/processed
process_radtags -1 ./raw/SRR20082728_1.fastq.gz -2 ./raw/SRR20082728_2.fastq.gz  --out-path ./processed --clean --quality --rescue --renz-1 sbfI --force-poly-g-check --basename Cgu_SG25
process_radtags -1 ./raw/SRR20082764_1.fastq.gz -2 ./raw/SRR20082764_2.fastq.gz  --out-path ./processed --clean --quality --rescue --renz-1 sbfI --force-poly-g-check --basename Cgu_AP11
process_radtags -1 ./raw/SRR20082787_1.fastq.gz -2 ./raw/SRR20082787_2.fastq.gz  --out-path ./processed --clean --quality --rescue --renz-1 sbfI --force-poly-g-check --basename Ces_SM12
```


```
cat > popmap << EOF
Cgu_SG25  SG
Cgu_AP11  AP
Ces_SM12  SM
EOF
```

