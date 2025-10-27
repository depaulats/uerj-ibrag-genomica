# Análise Filogenética

## Atividade 1 - Alinhamento Múltiplo de Sequências

Se você não tiver o software MAFFT instalado, instale-o usando o Conda em seu próprio ambiente.

    conda create --name mafft
    conda activate mafft
    conda install bioconda::mafft

Execute o software MAFFT para alinhar as sequências de proteínas (globais) e rRNA (motif).

    mafft --globalpair --maxiterate 1000 VertCOX1.fas > VertCOX1.g.fas
    mafft --globalpair --maxiterate 1000 VertCYTB.fas > VertCYTB.g.fas


Para removendo posições alinhadas de forma ambígua do MSA, vamos utilizar o software Gblocks. Instale-o usando o Conda no mesmo ambiente.

    conda install bioconda::gblocks

Execute o software Gblocks para remover posições alinhadas de forma ambígua.

    Gblocks VertCOX1.g.fas -t=p -b5=a
    Gblocks VertCYTB.g.fas -t=p -b5=a

Para concatenação dos alinhamentos individuais em uma única matriz, corrija as sequências removendo espaços vazios e renomeando os cabeçalhos; os cabeçalhos devem ser ">ID gene" para concatenação posterior.

    sed -e 's/ //g; /^>/ s/@/ /g; /^>/ s/_$//g' VertCOX1.g.fas-gb > VertCOX1.gb.fas
    sed -e 's/ //g; /^>/ s/@/ /g; /^>/ s/_$//g' VertCYTB.g.fas-gb > VertCYTB.gb.fas

Desembrulhar sequências em arquivos FASTA em uma única linha:

    seqkit seq VertCOX1.gb.fas -w 0 > VertCOX1.gb.fas
    seqkit seq VertCYTB.gb.fas -w 0 > VertCYTB.gb.fas

Execute o software seqkit para concatenar as sequências por seus IDs.

        seqkit concat VertCOX1.gb.fas VertCYTB.gb.fas > VertALL.gb.fas

A matriz final será obtida após renomear os cabeçalhos, removendo a lista de genes.

        sed '/^>/ s/ .*$//g' VertALL.gb.fas > VertALL.fas


## Atividade 2 - Reconstrução Filogenética

Reconstruindo uma árvore filogenética usando o método da Máxima Verossimilhança

Se você não tiver o software RAxML-NG instalado, instale-o usando o Conda em seu próprio ambiente.

        conda create --name raxml
        conda activate raxml
        conda install bioconda::raxml-ng

Ou baixe o binário pré-compilado da página do GiHub.

IMPORTANTE: Verifique a versão do arquivo antes de executar o código.

    wget https://github.com/amkozlov/raxml-ng/releases/download/1.2.2/raxml-ng_v1.2.2_linux_x86_64.zip
    unzip raxml-ng_v1.2.2_linux_x86_64.zip -d /mnt/c/genomica/
    rm raxml-ng_v1.2.2_linux_x86_64.zip

Execute o RAxML-NG usando as configurações:

Análise completa, ou seja, um comando (--all) para recuperar a árvore com melhor pontuação a partir de 20 inferências independentes e valores de suporte de réplicas de bootstrap;
MSA, ou matriz, (--msa) está no arquivo gb_all_final.fas
O formato MSA (--msa-format) está definido como FASTA;
Modelo evolutivo e partições (--model) fornecidos no arquivo cat_partitions.txt;
Análise de bootstrap (--bs-trees) definida como Bootstopping automático (autoMRE) para até 500 réplicas;
Métrica de suporte de bootstrap (--bs-metric) calculada usando "Transfer Bootstrap Expectation" (TBE);
Seed definido como 12345.

IMPORTANTE: O código abaixo está executando o binário do arquivo baixado. Para executar o binário instalado via Conda, remova o caminho /mnt/c/Ubuntu/ do código.

Para as matrix concatenada:

    /mnt/c/genomica/raxml-ng/raxml-ng  --all --msa VertALL.fas --msa-format FASTA --seed 12345 --model mtZOA+G10+FO  --bs-trees autoMRE{500} --bs-metric TBE --prefix VertALL


E para cada matrix separadamente:

    raxml-ng  --all --msa VertCOX1.g.fas --msa-format FASTA --seed 12345 --model GTR+G10+FO  --bs-trees autoMRE{500} --bs-metric TBE --prefix VertCOX1
