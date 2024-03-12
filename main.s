.code16 			   



.text 				   
.globl _start

pacman:
    movw $20, %cx
    movw $20, %dx


    # Entering video mode
    movb $0, %ah
    movb $0x0d, %al
    int $0x10
    
    call draw_matrix

    call move_cube

    
    movw $0x7d00, %bx
    add $0x11, %bx

    main:


        # Leitura do teclado
        movb $0, %al
        movb $0, %ah
        int $0x16
        

        # Compara para ser 'd'
        cmp $0x64, %al
        je move_right

        # Compara para ser 's'
        cmp $0x73, %al
        je move_down

        # Compara para ser 'a'
        cmp $0x61, %al
        je move_left

        # Compara para ser 'w'
        cmp $0x77, %al
        je move_up

        jmp main

move_up:        
    push %dx

    call sleep

    sub $16, %bx
    mov (%bx), %dl
    cmp $1, %dl
    je Dmove_up

    pop %dx

    call reset_screen
    
    sub $20, %dx

    call move_cube
    
    # Checa buffer
    movb $1, %ah
    int $0x16
    jz move_up    
    
    jmp main

    Dmove_up:
        add $16, %bx
        pop %dx
        jmp main

move_down:    
    push %dx

    call sleep

    add $16, %bx
    mov (%bx), %dl
    cmp $1, %dl
    je Dmove_down

    pop %dx
    
    call reset_screen

    add $20, %dx

    call move_cube
    
    # Checa buffer
    movb $1, %ah
    int $0x16
    jz move_down   
    
    jmp main
    
    Dmove_down:
        sub $16, %bx
        pop %dx
        jmp main

move_right:
    push %dx

    call sleep

    add $1, %bx
    mov (%bx), %dl
    cmp $1, %dl
    je Dmove_right

    pop %dx
    
    call reset_screen

    cmp $300, %cx
    jg teleport_left


    add $20, %cx
    
    call move_cube

    # Checa buffer
    movb $1, %ah
    int $0x16
    jz move_right    
    

    jmp main
    Dmove_right:
        sub $1, %bx
        pop %dx
        jmp main

move_left:
    push %dx

    call sleep

    cmp $19, %cx
    jl teleport_right

    sub $1, %bx
    mov (%bx), %dl
    cmp $1, %dl
    je Dmove_left

    pop %dx

    call reset_screen


    cmp $19, %cx
    jl teleport_right
    
    sub $20, %cx
    
    call move_cube

    # Checa buffer
    movb $1, %ah
    int $0x16
    jz move_left 
    
    jmp main
    Dmove_left:
        add $1, %bx
        pop %dx
        jmp main

draw_cube:

    # cx = posicao x do cubo
    # dx = posicao y do cubo
    # bh = contador X
    # bl = contador y 

    pusha

    movw $0, %bx

    draw:
        int $0x10

    cmp $20, %bh
    jl increment_x
    je increment_y

    increment_x:
        # incrementa o X e seu contador
        inc %cx
        inc %bh
        jmp draw

    increment_y:
        # reseta o X e seu contador
        sub $20, %cx
        sub $20, %bh

        # incrementa o Y e seu contador
        inc %dx
        inc %bl
    
    cmp $20, %bl
    jl draw

    popa

    ret

reset_screen:
    # Salva os registradores
    pusha

    # configura para apagar, mudando cor e resetando os contadores
    movb $0, %al
    movb $0xc, %ah
    movb $0, %bh
    movb $0, %bl

    # pinta na tela
    draw_reset:
        int $0x10

    # Caso tenha apagado 10 pixels no eixo x
    cmp $20, %bh
    jl increment_x_reset
    je increment_y_reset

    # Aumenta o X e seu contador
    increment_x_reset:
        inc %cx
        inc %bh
        jmp draw_reset

    # Aumenta o Y e seu contador e reseta o X
    increment_y_reset:
        sub $20, %cx
        sub $20, %bh

        inc %dx
        inc %bl
        
        cmp $20, %bl
        jl draw_reset

    popa
    ret

teleport_left:
    call reset_screen
    movw $20, %cx
    add $15, %bx
    call move_cube
    jmp move_right

teleport_right:
    call reset_screen
    movw $300, %cx
    sub $15, %bx
    call move_cube
    jmp move_left

move_cube:
    # function to write pixels
    movb $0x0c, %ah
    
    # Desenha o cubo
    movb $0xe, %al
    call draw_cube
    
    ret

sleep:
    push %cx
    push %dx

    movb $0x86, %ah

    movw $0x09, %cx
    movw $0, %dx
    int $0x15

    pop %dx
    pop %cx

    ret


draw_matrix:
    # Guarda o valor de registradores importantes para o progama
    push %ax
    push %cx
    push %dx

    movw $0, %dx
    movw $0, %ax
    # posiçao de memoria 0x700
    movw $0x7d00, %bx
    dec %bx

    loop_matrix:
        # incrementa a posiçao de memoria
        inc %bx
        
        # Resgata o valor na posiçao %bx para %ah
        movb (%bx), %ah

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

    movw %bx, %ax
    sub $0x7d00, %ax

    xor %dx, %dx
    movb $16, %cl
    

    # jmp pausa
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


    
    # function to write pixels
    movb $0x0c, %ah
    
    # Desenha o cubo
    movb $1, %al
    call draw_cube


    jmp return_draw_wall

pausa:
    hlt
    jmp pausa




