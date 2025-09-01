# Recuperação de dados NGS

## Atividade 1 -- SRA Tools

Para obtermos dados NGS de repositórios na internet, é necessário utilizar ferramentas apropriadas, desenvolvidas para tal.

O acesso ao Sequence Read Archive ([SRA](https://www.ncbi.nlm.nih.gov/sra)) do National Center for Biotechnology Information ([NCBI](https://www.ncbi.nlm.nih.gov/)) pode ser feito diretamente pelo site, ou, a depender dos dados a serem obtidos, via terminal.

Para tal, precisamos do [***SRA Tools***](https://github.com/ncbi/sra-tools).

    conda deactivate  # If you are not at (base) environment
    conda create --name sratools
    conda activate sratools
    conda install bioconda::sra-tools

Após a instalação, você precisará configurar o pacote para poder acessar dados públicos e de acesso controlado na nuvem, executando:

    vdb-config -i

Em seguida, habilite o acesso remoto (e) na aba Principal (m) e navegue até Cache (c) para habilitar o compartilhamento local de arquivos (i), saia (x), salve as alterações (y) e confirme (o). Outras configurações podem ser alteradas posteriormente executando o mesmo comando acima.

Navegue até a pasta criada para armazenar seus dados durante a disciplina:

    cd /mnt/c/genomica

Para baixar os dados gerados por De Paula et al. ([2024](https://doi.org/10.7717/peerj.18255)) da esponja carnívora *Lycopodina hypogea* (SRR28641204), execute o comando:

    fasterq-dump SRR28641204 -O /mnt/c/genomica/SRR28641204 --split-files --threads 8 --progress

Após algum tempo, você obterá os arquivos de saída SRR28641204_1.fastq e SRR28641204_2.fastq, cada um com ca. 1 Gb.
