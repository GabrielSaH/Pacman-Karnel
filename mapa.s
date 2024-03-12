save_wall:
    movw $0x700, %bx
    
    call full_wall             # 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 #
    call middle_full_wall      # 1 0 0 0 0 0 0 1 1 0 0 0 0 0 0 1 #
    call populated_wall        # 1 0 1 1 0 1 0 1 1 0 1 0 1 1 0 1 #
    call empty_wall            # 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 #
    call populated_wall_open   # 0 0 1 1 0 1 0 1 1 0 1 0 1 1 0 0 #
    call populated_wall_open   # 0 0 1 1 0 1 0 1 1 0 1 0 1 1 0 0 #
    call empty_wall            # 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 #
    call populated_wall        # 1 0 1 1 0 1 0 1 1 0 1 0 1 1 0 1 #
    call middle_full_wall      # 1 0 0 0 0 0 0 1 1 0 0 0 0 0 0 1 #
    call full_wall             # 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 #

1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 #
1 0 0 0 0 0 0 1 1 0 0 0 0 0 0 1 #
1 0 1 1 0 1 0 1 1 0 1 0 1 1 0 1 #
1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 #
0 0 1 1 0 1 0 1 1 0 1 0 1 1 0 0 #
0 0 1 1 0 1 0 1 1 0 1 0 1 1 0 0 #
1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 #
1 0 1 1 0 1 0 1 1 0 1 0 1 1 0 1 #
1 0 0 0 0 0 0 1 1 0 0 0 0 0 0 1 #
1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 #

    inc %bx
    movb $2, (%bx)

    ret

full_wall:
    # 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 #
    push %ax

    movw $0, %ax
    loop:
        # Escreve 1 na posiçao de memoria %bx
        movw $1, (%bx)

        inc %ax

        # Aumenta para a proxima posicao de memoria
        inc %bx

        #Para quando chegar em 0x160
        #os primeiros 16 espaços da matrix 16x10 
        cmp $16, %ax
        jl loop

    pop %ax

    ret

populated_wall_open:
    # 0 0 1 1 0 1 0 1 1 0 1 0 1 1 0 0 #

    add $2, %bx
    movw $1, (%bx)
    inc %bx
    movw $1, (%bx)
    add $2, %bx
    movw $1, (%bx)
    add $2, %bx
    movw $1, (%bx)
    inc %bx
    movw $1, (%bx)
    add $2, %bx
    movw $1, (%bx)
    add $2, %bx
    movw $1, (%bx)
    inc %bx
    movw $1, (%bx)
    add $2, %bx
    inc %bx

    ret

populated_wall:
    # 1 0 1 1 0 1 0 1 1 0 1 0 1 1 0 1 #

    movw $1, (%bx)
    add $2, %bx
    movw $1, (%bx)
    inc %bx
    movw $1, (%bx)
    add $2, %bx
    movw $1, (%bx)
    add $2, %bx
    movw $1, (%bx)
    inc %bx
    movw $1, (%bx)
    add $2, %bx
    movw $1, (%bx)
    add $2, %bx
    movw $1, (%bx)
    inc %bx
    movw $1, (%bx)
    add $2, %bx
    movw $1, (%bx)
    inc %bx

    ret

empty_wall:
    # 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 #

    movw $1, (%bx)
    add $15, %bx
    movw $1, (%bx)
    inc %bx
    
    ret

middle_full_wall:
    # 1 0 0 0 0 0 0 1 1 0 0 0 0 0 0 1 #
    movw $1, (%bx)
    add $7, %bx
    movw $1, (%bx)
    inc %bl
    movw $1, (%bx)
    add $7, %bx
    movw $1, (%bx)
    inc %bx

    ret

draw_matrix:
    # Guarda o valor de registradores importantes para o progama
    push %ax
    push %cx
    push %dx

    movw $0, %dx
    movw $0, %ax
    # posiçao de memoria anterior a 0x700
    movw $0x6ff, %bx

    loop_matrix:
        # incrementa a posiçao de memoria
        inc %bx
        
        # Resgata o valor na posiçao %bx para %ah
        mov (%bx), %ah
           

        # Checa se é o codigo da parede
        cmp $1, %ah
        je draw_wall

        return_draw_wall:
        cmp $2, %ah
        je end_matrix_loop
        
        jmp loop_matrix

        
    end_matrix_loop:
        pop %dx
        pop %cx
        pop %ax

        ret

draw_wall:

    # movw %bx, %ax
    # sub $0x700, %ax

    movw $16, %ax
    xor %dx, %dx
    movb $16, %cl
    

    jmp pausa
    # resultado em eax, resto edx
    idiv %cl


    movb %ah, %cl
    movb $0, %ch
    
    movb %al, %dl
    movb $0, %dh


    # multiplica %ax por 10 e guarda o resultado em %cx
    # Como cada cubo tem 10 pixels de largura, isso define a posiçao do cubo
    # Ex: posiçao da matrix 3 começa em x = 60 e termina em x = 80
    imul $20, %cx
    imul $20, %dx


    #xchg %cx, %dx
    
    # function to write pixels
    movb $0x0c, %ah
    
    # Desenha o cubo
    movb $1, %al
    call draw_cube


    jmp return_draw_wall

. = _start + 510    
# MBR boot signature 
.byte 0x55		        
# MBR boot signature 
.byte 0xaa	