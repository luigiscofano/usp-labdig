# Projeto portátil criado nesta edição a partir dos fontes organizados.
# Uso: quartus_sh -t scripts/gerar_quartus.tcl guardiao
package require ::quartus::project
set raiz [file normalize [file join [file dirname [info script]] ..]]
if {$argc != 1} {error "Informe guardiao, math-genius, lab1-exp01..06 ou lab2-exp01..05"}
set alvo [lindex $argv 0]
array set pastas {
    guardiao projetos/guardiao-do-paredao/rtl
    math-genius projetos/math-genius/rtl
    lab1-exp01 labdig-1/experimentos/exp-01/rtl
    lab1-exp02 labdig-1/experimentos/exp-02/rtl
    lab1-exp03 labdig-1/experimentos/exp-03/rtl
    lab1-exp04 labdig-1/experimentos/exp-04/rtl
    lab1-exp05 labdig-1/experimentos/exp-05/rtl
    lab1-exp06 labdig-1/experimentos/exp-06/rtl
    lab2-exp01 labdig-2/experimentos/exp-01/rtl
    lab2-exp02 labdig-2/experimentos/exp-02/rtl
    lab2-exp03 labdig-2/experimentos/exp-03/rtl
    lab2-exp04 labdig-2/experimentos/exp-04/rtl
    lab2-exp05 labdig-2/experimentos/exp-05/rtl
}
array set tops {
    guardiao guardiao math-genius MathGenius
    lab1-exp01 contador_didatico lab1-exp02 circuito_exp2_ativ2
    lab1-exp03 circuito_exp3 lab1-exp04 circuito_exp4
    lab1-exp05 circuito_exp5 lab1-exp06 jogo_desafio_memoria
    lab2-exp01 controle_servo lab2-exp02 tx_serial_7E1
    lab2-exp03 interface_ultrassonica lab2-exp04 trena_serial lab2-exp05 sonar
}
if {![info exists pastas($alvo)]} {error "Alvo desconhecido: $alvo"}
proc fontes {pasta} {
    set saida {}
    foreach p [glob -nocomplain -directory $pasta *] {
        if {[file isdirectory $p]} {set saida [concat $saida [fontes $p]]
        } elseif {[file extension $p] eq ".v"} {lappend saida $p}
    }
    return $saida
}
set arquivos [fontes [file join $raiz $pastas($alvo)]]
if {$alvo in {lab2-exp03 lab2-exp04 lab2-exp05}} {
    set arquivos [concat $arquivos [fontes [file join $raiz projetos/guardiao-do-paredao/rtl]] [fontes [file join $raiz biblioteca/rtl]]]
}
set destino [file join $raiz build quartus $alvo]
file mkdir $destino
cd $destino
project_new $alvo -overwrite
set_global_assignment -name FAMILY "Cyclone V"
set_global_assignment -name DEVICE 5CEBA4F23C7
set_global_assignment -name TOP_LEVEL_ENTITY $tops($alvo)
foreach p $arquivos {set_global_assignment -name VERILOG_FILE $p}
set sdc [file join $destino clock.sdc]
set canal [open $sdc w]
puts $canal {create_clock -name clock -period 20.000 [get_ports {clock}]}
close $canal
set_global_assignment -name SDC_FILE $sdc
export_assignments
project_close
puts "Projeto criado em $destino. Confira a pinagem e as restrições de E/S antes da montagem."
