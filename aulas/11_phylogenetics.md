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
    

## Atividade 2 - Reconstrução Filogenética


