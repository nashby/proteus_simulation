#include <p16f84.inc>

vpause    equ 0x0C
led_mask  equ 0x0D

ORG 0x00
    goto Main

ORG 0x04
    retfie

ORG 0x05

Wait1s
    movlw d'249' ;1 + 1 + 248 * (2 + 2) + 2 + 2 + 2 = 1000
    movwf vpause
Loop:
    decfsz vpause
    goto Loop
    nop
    nop
    return

SwitchLEDs
    clrf    PORTA
    clrf    PORTB
    btfss   led_mask, 0x06 ;MSB - 1
    goto    $+2
    bsf     PORTA, RA1
    btfss   led_mask, 0x05
    goto    $+2
    bsf     PORTA, RA2
    btfss   led_mask, 0x04
    goto    $+2
    bsf     PORTA, RA3
    btfss   led_mask, 0x03
    goto    $+2
    bsf     PORTB, RB2
    btfss   led_mask, 0x02
    goto    $+2
    bsf     PORTB, RB3
    btfss   led_mask, 0x01
    goto    $+2
    bsf     PORTB, RB4
    btfss   led_mask, 0x00 ;LSB
    goto    $+2
    bsf     PORTB, RB5
    return

SwitchPair macro reg
    movlw   reg
    movwf   led_mask
    call    SwitchLEDs
    call    Wait1s
endm

Main:
    bsf     STATUS, RP0
    clrf    TRISA
    clrf    TRISB
    bcf     STATUS, RP0

LedLoop
    SwitchPair 0x41
    SwitchPair 0x22
    SwitchPair 0x14
    SwitchPair 0x8
    SwitchPair 0x14
    SwitchPair 0x22
    SwitchPair 0x41
    goto LedLoop
end
