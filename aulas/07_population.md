# Análise populacional genômica 

Este tutorial foi traduzido e adaptado do [Manual do Stacks](https://catchenlab.life.illinois.edu/stacks/manual/).

# Atividade 1 - Obtenção e limpeza de dados de RADseq

Faço o download dos dados de RADseq disponíveis no NCBI-SRA (SRR20082702) usando o programa fastq-dump, disponível como parte do [***SRA Tools***](https://github.com/ncbi/sra-tools).

```
conda deactivate  # If you are not at (base) environment
conda activate sratools
mkdir /home/c/genomica/stacks && cd $_
fastq-dump --accession SRR20082702 --gzip --split-files --defline-seq '@$ac.$si/$ri' --defline-qual '+$ac.$si/$ri' --outdir ./raw
```

. Os dados são de um único indivíduo de peixe-gelo-cavala, sequenciado em pares em uma biblioteca RADseq de digestão única usando a enzima SbfI (Rivera-Colón et al., 2023).
