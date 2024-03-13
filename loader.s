/*
* \author: Éder Augusto Penharbel
* \date: February, 2022
* \version: February, 2022
*/

# generate 16-bit code
.code16 			   


# executable code location
.text 				   

.globl _start

_start:

    # segmento do endereço
    xor %ax, %ax
    movw %ax, %ds
    movw %ax, %es
    # offset do endereço
    mov $0x8000, %bx
    movb $0x02, %ah
    # num de setores a ler
    movb $2, %al

    # num do cilindro
    movb $0, %ch

    # num do setor
    movb $3, %cl

    # num da cabeça
    movb $0, %dh

    # drive
    movb $0x00, %dl

    int $0x13
    # jmp pacman
    jmp 0x8000

    # movb $0x0e, %ah	

    # movb $'k' , %al		
    # int  $0x10	
   
# parar:    
#     hlt
#     jmp parar
#     
# final:
#     mov $'o', %al
#     mov $0xe, %ah
#     int $0x10
#     mov $'k', %al
#     mov $0xe, %ah
#     int $0x10

. = 0x100 
.data
array:
    .byte 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
    .byte 1, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1
    .byte 1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1
    .byte 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1
    .byte 0, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 0
    .byte 0, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 0
    .byte 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1
    .byte 1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1
    .byte 1, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1
    .byte 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
    .byte 2


# escrever a assinatura no local correto 
. = 0x100 - 2
bios_signature:
    .byte 0x55, 0xaa    # MBR boot signature 


#. = _start + 510    
# MBR boot signature 
#.byte 0x55		        
# MBR boot signature 
#.byte 0xaa	