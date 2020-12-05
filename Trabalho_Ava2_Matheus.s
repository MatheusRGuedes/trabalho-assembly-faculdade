# Programa Arquitetura Computadores AVA2

# ======== Índice ========
# $f1 -> valor produto flutuante	$t9 -> valor produto inteiro
# $f3 -> valor pago flutuante		$t8 -> valor pago inteiro
# $f5 -> valor 100 a ser trabalhado
# $f7 -> valor do troco

# ======== Atenção ========
# O valor do produto a ser alterado se encontra na definição dos dados em .data;
# Os registradores de quantidade de cédulas e moedas inseridas se encontram logo no início do programa;



.data
	vlrProduto: .float  62.10				# Insira o valor do produto aqui
	cem:	    .float  100.00				# Valor 100 armazenado na memória, pois será muito usado
	msgProduto: .asciiz "\nValor produto selecionado: "
	msgPago:    .asciiz "\nValor a ser pago: "
	msgTroco:   .asciiz "\nValor troco: "

	msgErro:    .asciiz "\nValor insuficiente para a compra.\n"
	msgErro2:   .asciiz "\nValor produto não é multiplo de 0,10.\n"

.text
	.globl main
	main:
		j inicio		# copia o PC para RA, desvia para a label inicio, pulando o exit;

		EXIT: 
			li $v0, 10
			syscall		# executa o exit(10) e finaliza o programa;		
		
		RecuperaValorProduto:	# usado para deixar o valor do produto em $t9
			move $t9, $t5
			j EXIT

		inicio:

		li $s0, 4	# qtdd de cédulas de 20,00
		li $s1, 3	# qtdd de cédulas de 10,00
		li $s2, 0	# qtdd de cédulas de 5,00
		li $s3, 3	# qtdd de cédulas de 2,00
		li $s4, 3	# qtdd de cédulas de 1,00
		li $s5, 1	# qtdd de cédulas de 0,50	
		li $s6, 2	# qtdd de cédulas de 0,25
		li $s7, 5	# qtdd de cédulas de 0,10

		#=== calculo das cédulas ===

		#calculo quantidade cedulas 20
		li $t1, 20		
		mul $t2, $s0, $t1
		add $t3, $t2, $t3	
				
		#calculo quantidade cedulas 10
		li $t1, 10
		mul $t2, $s1, $t1
		add $t3, $t2, $t3

		#calculo quantidade cedulas 5
		li $t1, 5
		mul $t2, $s2, $t1
		add $t3, $t2, $t3

		#calculo quantidade cedulas 2
		li $t1, 2
		mul $t2, $s3, $t1
		add $t3, $t2, $t3
		
		#calculo quantidade cedulas 1
		li $t1, 1
		mul $t2, $s4, $t1
		add $t3, $t2, $t3

		mtc1 $t3, $f0		# move para o coprocessador o valor de $t3 para $f0 (apenas recebe o resultado d uma funcao)
		cvt.s.w $f3, $f0	# converte valor total de cédulas($f3) em float (simples);

		#=== cálculo dos centavos ===
		
		#calculo quantidade moedas 0,50			
		li $t1, 5
		li $t3, 0
		mul $t2, $t1, $s5
		add $t3, $t2, $t3

		mtc1 $t3, $f0
		cvt.s.w $f1, $f0

		li.s $f5, 10.0
		div.s $f1, $f1, $f5

		add.s $f3, $f3, $f1	# soma ao valor total pago($f3) as moedas de 0,50

		#=== cálculo quantidade moedas 0,25
		li $t1, 25
		li $t3, 0
		mul $t2, $t1, $s6
		add $t3, $t2, $t3
		
		mtc1 $t3, $f0
		cvt.s.w $f1, $f0
		
		lwc1 $f5, cem
		div.s $f1, $f1, $f5

		add.s $f3, $f3, $f1	# soma ao valor total pago($f3) as moedas de 0,25

		#=== cálculo quantidade moedas 0,10
		li $t1, 10
		li $t3, 0
		mul $t2, $t1, $s7
		add $t3, $t2, $t3
		
		mtc1 $t3, $f0
		cvt.s.w $f1, $f0
		
		lwc1 $f5, cem
		div.s $f1, $f1, $f5

		add.s $f3, $f3, $f1	# soma ao valor total pago($f3) as moedas de 0,10

		# Fim cálculo de cédulas e moedas.


		# Início dos cálculos produto selecionado e troco.

		lwc1 $f5, cem		# $f5 = 100

		li $v0, 4
		la $a0, msgProduto
		syscall			# printa a mensagem do rótulo vlrProduto;

		li $v0, 2
		lwc1 $f12, vlrProduto	# carrega valor de vlrProduto na memória no registrador $f12
		syscall			# printa o valor de $f12 e armazena em $f0;

		mov.s $f1, $f12		# carrega o valor d precisão simples de $f12(suporta double) pr $f1(q n suporta);

		mul.s $f1, $f1, $f5	# $f1 = $f1 * 100 - multiplica precisão simples
		cvt.w.s $f0, $f1	# $f0 = (int) $f1 - converte float simples para inteiro e armazena em $f0
		mfc1 $t9, $f0		# $t9 = (int) (valor prod * 100.0) - ou copy to, copia do coprocessador para o processador

		# verifica valor produto multiplo de 10 (0.10)
		li $t1, 10
		div $t9, $t1
		mfhi $t2
		beq $t2, $zero, continua
			li $v0, 4
			la $a0, msgErro2
			syscall

			j EXIT

		continua:


		li $v0, 4
		la $a0, msgPago
		syscall			# imprime a mensagem do rótulo msgPago;

		li $v0, 2
		mov.s $f12, $f3		# copia o valor total pago calculado($f3) para $f12
		syscall			# printa o valor total pago calculado

		mul.s $f3, $f3, $f5	# $f3 = $f3 * 100;
		cvt.w.s $f0, $f3	# $f0 = (int) $f3;
		mfc1 $t8, $f0		# $t8 = (int) (valor pago($f3) * 100.00). Feito pr fazer a comparação justa abaixo;


		bge $t8, $t9, suficiente	# verifica se $t8(valor pago inteiro) > $t9(valor produto inteiro);
		
			li $t0, 1
		
			li $v0, 4
			la $a0, msgErro
			syscall

			j EXIT

		suficiente:

			li $t0, 0

			sub.s $f7, $f3, $f1 	# subtrai precisão simples, $f7(troco) = $f3(valor pago) - $f1(valor produto)
			div.s $f12, $f7, $f5	# divide precisão simples a ser mostrado, $f12 = $f7(troco) / 100

			li $v0, 4
			la $a0, msgTroco
			syscall			# printa a mensagem "Valor troco: ";

			li $v0, 2
			syscall			# print o valor do troco do $f12;
		

		# Antes de zerar os registradores, recupero o valor de $t9 (valor produto * 100)
		move $t5, $t9

		# Zero os registradores $s0-$t9 para o cálculo da qntdd de cada cédula do troco;

		li $s0, 0		# qtdd de cédulas de 20,00
		li $s1, 0		# qtdd de cédulas de 10,00
		li $s2, 0		# qtdd de cédulas de 5,00
		li $s3, 0		# qtdd de cédulas de 2,00
		li $s4, 0		# qtdd de cédulas de 1,00
		li $s5, 0		# qtdd de moedas de 0,50
		li $s6, 0		# qtdd de moedas de 0,25
		li $s7, 0		# qtdd de moedas de 0,10
		li $t9, 0		# qtdd de moedas de 0,05

		cvt.w.s $f0, $f7	# $f0 = (int) $f7
		mfc1 $t1, $f0		# $t1 = (int) ($f7 * 100), será usado para cálculo;

		li $t2, 5		# $t2 = 5, afim de usar na condição do while
		li $t4, 1		# $t4 = 1, usado para incremento dos registradores
		# $t3 será os valores a serem comparados para incremento e subtração, caso true;


		# Começo do while
	
		LOOP:
			blt $t1, $t2, RecuperaValorProduto	# verifica $t1 < 5 (0.05), caso true sai do loop, se não, continua
			
			li $t3, 2000
			bge $t1, $t3, maiorIgualDoisMil		# $t1 >= 2000 (20 reais)

			li $t3, 1000
			bge $t1, $t3, maiorIgualMil		# $t1 >= 1000 (10 reais)

			li $t3, 500
			bge $t1, $t3, maiorIgualQuinhentos	# $t1 >= 500 (5 reais)

			li $t3, 200
			bge $t1, $t3, maiorIgualDozentos	# $t1 >= 200 (2 reais)

			li $t3, 100
			bge $t1, $t3, maiorIgualCem		# $t1 >= 100 (1 real)

			li $t3, 50
			bge $t1, $t3, maiorIgualCinquenta	# $t1 >= 50 (0.50 centavos)

			li $t3, 25
			bge $t1, $t3, maiorIgualVinteECinco	# $t1 >= 25 (0.25 centavos)

			li $t3, 10
			bge $t1, $t3, maiorIgualDez		# $t1 >= 10 (0.10 centavos)

			li $t3, 5
			bge $t1, $t3, maiorIgualCinco		# $t1 >= 5 (0.05 centavos)


			maiorIgualDoisMil:
				sub $t1, $t1, $t3	# $t1 -= 2000
				add $s0, $s0, $t4	# $s0 += 1
				j LOOP
			maiorIgualMil:
				sub $t1, $t1, $t3	# $t1 -= 1000
				add $s1, $s1, $t4	# $s1 += 1
				j LOOP
			maiorIgualQuinhentos:
				sub $t1, $t1, $t3	# $t1 -= 500
				add $s2, $s2, $t4	# $s2 += 1
				j LOOP
			maiorIgualDozentos:
				sub $t1, $t1, $t3	# $t1 -= 200
				add $s3, $s3, $t4	# $s3 += 1
				j LOOP
			maiorIgualCem:
				sub $t1, $t1, $t3	# $t1 -= 100
				add $s4, $s4, $t4	# $s4 += 1
				j LOOP
			maiorIgualCinquenta:
				sub $t1, $t1, $t3	# $t1 -= 50
				add $s5, $s5, $t4	# $s5 += 1
				j LOOP
			maiorIgualVinteECinco:
				sub $t1, $t1, $t3	# $t1 -= 25
				add $s6, $s6, $t4	# $s6 += 1
				j LOOP
			maiorIgualDez:
				sub $t1, $t1, $t3	# $t1 -= 10
				add $s7, $s7, $t4	# $s7 += 1
				j LOOP
			maiorIgualCinco:
				sub $t1, $t1, $t3	# $t1 -= 5
				add $t9, $t9, $t4	# $t9 += 1
				j LOOP

			j LOOP

		j EXIT