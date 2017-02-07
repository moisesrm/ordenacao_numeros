.data 
array: .space 200 #Declara que a lista terá 50 posições
prompt1: .asciiz "Informe o numero de elementos: "
prompt2: .asciiz "Informe os numeros: "
prompt3: .asciiz "\nNumeros da lista ordenada: "
prompt4: .asciiz "Informe como ordenar, (c)rescente - (d)ecrescente: "
prompt5: .asciiz "O numero tem que ser menor que 50\n"
prompt6: .asciiz "Codigo invalido\n"
espaco: .asciiz " "
.globl main
.text 

main:
la $t1, array #Carrega a lista para o registrador

li $v0,4 #Sistema chama codigo para exibir string
la $a0,prompt1 #Carrega a mensagem 
syscall #Chama o prompt1

li $v0,5 #Sistema chama codigo para ler inteiro
syscall #Chama o codigo para ler o valor
bgt $v0,50,teste_numero #Se v0 for maior que 50 vai para teste

move $t0,$v0 #Move o valor de v0 para t0
move $t2,$t0 #Move o valor de t0 para o contador t2

li $v0,4 #Sistema chama codigo para exibir string
la $a0,prompt2 #Carrega a mensagem 
syscall #Chama o prompt2

numeros: #Entra no loop para ler os numeros
	li $v0,5 #Sistema chama codigo para ler inteiro
	syscall #Chama o codigo para ler o valor
	sw $v0, ($t1) #Salva o valor na lista
	add $t1,$t1,4 #Seleciona a proxima posição da lista
	sub $t2,$t2,1 #Diminui 1 do contador
	bgtz  $t2,numeros #Se o contador for zero ele executa a proxima ação, senão retorna para o loop

la $t1,array #Retorna para o inicio da lista
la $t3,array #Copia o endereço da lista para t3
move $t2,$t0 #Copia o numero de elementos para t2
move $t6,$t2 #Copia o numero de elementos para t6
sub $t2,$t2,1 #Diminui 1 do contador

escolha:	
	li $v0,4 #Sistema chama codigo para exibir string
	la $a0,prompt4 #Carrega a mensagem 
	syscall #Chama o prompt4
	
	li $v0,12 #Sistema chama codigo para ler caracter
	syscall #Chama o codigo para ler o valor
	
	beq $v0,'c',ordenacao_crescente #Se v0 for c vai para ordenação crescente
	beq $v0,'C',ordenacao_crescente #Se v0 for C vai para ordenação crescente	
	beq $v0,'d',ordenacao_decrescente #Se v0 for d vai para ordenação decrescente
	beq $v0,'D',ordenacao_decrescente #Se v0 for D vai para ordenação decrescente	
	
	li $v0,4 #Sistema chama codigo para exibir string
	la $a0,prompt6 #Carrega a mensagem 
	syscall #Chama o prompt6
	bne $v0,'d',escolha #Se v0 for diferente de c ou d vai para o loop escolha

fim:
    la $t1,array #Coloca a lista no inicio
    li $v0,4 #Sistema chama codigo para exibir string
    la $a0,prompt3 #Carrega a mensagem
    syscall	#Chama prompt3
    imprimir:
	     li $v0,1 #Sistema chama codigo para exibir string
	     lw $a0,($t1) #Carrega em a0 o valor que esta na posição da lista
	     syscall #Imprimi o valor
	     add $t1,$t1,4 #Soma t1 para a proxima posição
	     sub $t6,$t6,1 #Subtrai 1 do contador
	     li $v0,4 #Sistema chama codigo para exibir string
	     la $a0,espaco #Carrega a mensagem
	     syscall #Chama a mensagem
	     bnez $t6,imprimir #Se contador for 0 sai do loop, senão volta para o loop

li $v0,10 #Chama codigo para finalizar
syscall #Finaliza

# Teste #################################################################################
teste_numero:
	     li $v0,4 #Sistema chama codigo para exibir string
	     la $a0,prompt5 #Carrega a mensagem 
	     syscall #Chama o prompt5
	     j main #Volta para o inicio

# Função crescente ######################################################################
ordenacao_crescente:	  
	  lw $t4, ($t1) #Carrega t4 com o valor que esta na posição da lista
	  lw $t5, 4($t3)#Carrega t5 com o valor que esta na posição da lista
	  blt $t5,$t4,troca_crescente #Se t5 for menor que t4 então faz a troca
	  add $t3,$t3,4 #Senão t3 vai para o proximo elemento da lista
    	  sub $t2,$t2,1 #Diminui 1 do contador
    	  bnez $t2,ordenacao_crescente #Se contador for 0 sai da ordenação	  
	  teste_c:
	  	sub $t0,$t0,1 #Diminui 1 do contador 
	  	move $t2,$t0 #Carrega t2 com o numero de quantos restam fazer a troca
	  	move $t3,$t1 #Carrega t3 com a posição do ultimo numero ordenado
	  	add $t1,$t1,4 #Carrega t3 com a posição do proximo numero a ser ordenado
	  	bnez $t0,ordenacao_crescente #Se contador for 0 sai da ordenação
	  	j fim #Pula para exibição dos numeros

troca_crescente:
      sw $t5,($t1) #Salva o numero de t5 na posição de t4
      sw $t4,4($t3) #Salva o numero de t5 na posição de t5
      add $t3,$t3,4 #Carrega t3 com a proxima posição
      sub $t2,$t2,1 #Diminui 1 do contador 
      bnez $t2,ordenacao_crescente #Se contador for 0 sai da ordenação
      j teste_c #Pula para o teste_c
      
# Função decrescente ####################################################################

ordenacao_decrescente:	  
	  lw $t4, ($t1) #Carrega t4 com o valor que esta na posição da lista
	  lw $t5, 4($t3)#Carrega t5 com o valor que esta na posição da lista
	  bgt $t5,$t4,troca_decrescente #Se t5 for maior que t4 então faz a troca
	  add $t3,$t3,4 #Senão t3 vai para o proximo elemento da lista
    	  sub $t2,$t2,1 #Diminui 1 do contador
    	  bnez $t2,ordenacao_decrescente #Se contador for 0 sai da ordenação	  
	  teste_d:
	  	sub $t0,$t0,1 #Diminui 1 do contador 
	  	move $t2,$t0 #Carrega t2 com o numero de quantos restam fazer a troca
	  	move $t3,$t1 #Carrega t3 com a posição do ultimo numero ordenado
	  	add $t1,$t1,4 #Carrega t3 com a posição do proximo numero a ser ordenado
	  	bnez $t0,ordenacao_decrescente #Se contador for 0 sai da ordenação
	  	j fim #Pula para exibição dos numeros

troca_decrescente:
      sw $t5,($t1) #Salva o numero de t5 na posição de t4
      sw $t4,4($t3) #Salva o numero de t5 na posição de t5
      add $t3,$t3,4 #Carrega t3 com a proxima posição
      sub $t2,$t2,1 #Diminui 1 do contador 
      bnez $t2,ordenacao_decrescente #Se contador for 0 sai da ordenação
      j teste_d #Pula para o teste_c
