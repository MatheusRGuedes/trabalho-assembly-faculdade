# trabalho-assembly-faculdade
### Trabalho de arquitetura e organização de computadores, para execução de instruções de um programa feito pelo processador MIPS, usando Assembly.

## Aspéctos gerais do programa

1. Este programa, se baseia em uma simulação de uma máquina automática de vendas;
2. O programa foi feito, baseado no hardware da arquitetura MIPS 32 bits;
3. Conta com equipamento que aceita cédulas de 20, 10, 5 e 2 reais, assim como moedas de 1 real e de 50, 25 e 10 centavos.

## Funcionalidades

- Informa no visor a quantidade de dinheiro inserida.
- Informa no visor o preço do produto selecionado.
- Informa no visor o valor do troco.
- Calcular a quantidade de cada cédula e moeda que devem ser fornecidas como troco, otimizando para que a quantidade de cédula/moeda seja a mínima possível (sempre fornecer como troco a maior quantidade possível de cédulas e moedas de maior valor).

## Especificações

1. O programa recebe e faz contagem de cédulas e moedas, e armazena o resultado da contagem nos registradores do processador MIPS;
2. Quando o programa terminar sua execução o hardware que separa o troco verifica a quantidade de cédulas e moedas que deve fornecer como troco investigando o estado dos registradores;

## Registradores:

- Registradores para calculo da quantidade de moedas/cédulas inseridas para o valor do produto:

Registrador | Descrição
----------- | ---------
$s0         | Quantidade de cédulas de R$20,00 inseridas.
$s1         | Quantidade de cédulas de R$10,00 inseridas.
$s2         | Quantidade de cédulas de R$5,00 inseridas.
$s3         | Quantidade de cédulas de R$2,00 inseridas.
$s4         | Quantidade de moedas de R$1,00 inseridas.
$s5         | Quantidade de moedas de R$0,50 inseridas.
$s6         | Quantidade de moedas de R$0,25 inseridas.
$s7         | Quantidade de moedas de R$0,10 inseridas.
$t9         | Valor do produto selecionado × 100.

- Registradores para calculo da quantidade de moedas/cédulas para o valor do troco:

Registrador | Descrição
----------- | ---------
$s0         | Quantidade de cédulas de R$20,00 para o troco.
$s1         | Quantidade de cédulas de R$10,00 para o troco.
$s2         | Quantidade de cédulas de R$5,00 para o troco.
$s3         | Quantidade de cédulas de R$2,00 para o troco.
$s4         | Quantidade de moedas de R$1,00 para o troco.
$s5         | Quantidade de moedas de R$0,50 para o troco.
$s6         | Quantidade de moedas de R$0,25 para o troco.
$s7         | Quantidade de moedas de R$0,10 para o troco.
$t9         | Quantidade de moedas de R$0,05 para o troco.

## Ferramenta utilizada

- Para o desenvolvimento, foi necessário uma ferramenta de simulação do processador MIPS e foi usado o simulador QtSpim (simulador da arquitetura MIPS 32 bits). Trata-se de um software livre multiplataforma.
