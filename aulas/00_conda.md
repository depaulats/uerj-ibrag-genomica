# Instalando o Miniconda

"[Miniconda](https://www.anaconda.com/docs/getting-started/miniconda/main) é uma instalação gratuita em miniatura da distribuição Anaconda que inclui apenas o Conda, o Python, os pacotes dos quais ambos dependem e um pequeno número de outros pacotes úteis."

A instalação é simples. Basta executar os comandos abaixo para baixar a versão mais recente e executar a instalação (que será excluída posteriormente).

```
mkdir -p ~/miniconda3
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh
bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
rm ~/miniconda3/miniconda.sh
```

Depois disso, você precisa fechar e reabrir seu aplicativo de terminal para inicializar o Conda em todos os shells disponíveis, executando:

```
conda init --all
```

Agora seu shell será configurado no ambiente `(base)`, que você não deve usar para instalar pacotes para evitar conflitos com softwares padrão (por exemplo, Python).

## Gerenciando ambientes

"Com o [conda](https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html), você pode criar, exportar, listar, remover e atualizar ambientes que possuem diferentes versões do Python e/ou pacotes instalados."

### Criando um ambiente

```
conda create --name your-environment
```

Quando o conda solicitar que você prossiga, digite `y`.

### Ativando um ambiente

Para ativar `(seu-ambiente)`:

```
conda activate your-environment
```

### Desativando um ambiente

Para retornar à `(base)`:

```
conda deactivate
```

### Removendo um ambiente

Para remover `seu-ambiente` do seu computador e todos os pacotes nele contidos:

```
conda remove --name seu-ambiente --all
```

Para verificar se `seu-ambiente` foi removido e todos os outros ainda presentes no seu sistema, execute:

```
conda info --envs
```

Para instalar pacotes em um ambiente, você pode fazê-lo durante sua criação ou após ativar um existente.

O Conda sugere que você instale todos os programas ao mesmo tempo para evitar conflitos de dependência. No entanto, não instalaremos individualmente os programas necessários, mas sim pacotes de software selecionados e depositados em um repositório, como o [Bioconda](https://bioconda.github.io/).

Para instalar pacotes com o Bioconda, primeiro você precisa realizar uma configuração única:

```
conda config --add channels bioconda
conda config --add channels conda-forge
conda config --set channel_priority strict
```

Então você pode ativar `seu-ambiente` e instalar `seu-pacote`:

```
conda activate your-environment
conda install bioconda::seu-pacote
```

Depois de saber qual pacote está procurando, basta pesquisar seus nomes em qualquer mecanismo de busca para encontrar o que precisa, incluindo os termos "github" ou "bioconda".
