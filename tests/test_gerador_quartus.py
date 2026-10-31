"""Exercita Tcl real com API Quartus simulada; não realiza síntese."""
import os
from pathlib import Path
import re
import tkinter

ROOT = Path(__file__).resolve().parents[1]
TARGETS = ['guardiao', 'math-genius'] + [f'lab1-exp{i:02}' for i in range(1, 7)] + [f'lab2-exp{i:02}' for i in range(1, 6)]


def executar(alvo):
    tcl = tkinter.Tcl()
    tcl.eval('''
        package provide ::quartus::project 1.0
        set assignments {}
        proc project_new {args} {}
        proc export_assignments {} {}
        proc project_close {} {}
        proc set_global_assignment {args} {lappend ::assignments $args}
    ''')
    tcl.setvar('argc', 1)
    tcl.setvar('argv', (alvo,))
    try:
        tcl.call('source', str(ROOT / 'scripts/gerar_quartus.tcl'))
        return tcl, [tuple(str(v) for v in tcl.splitlist(a)) for a in tcl.splitlist(tcl.getvar('assignments'))]
    finally:
        os.chdir(ROOT)


def main():
    for alvo in TARGETS:
        _, assignments = executar(alvo)
        values = {a[1]: a[2] for a in assignments}
        files = [Path(a[2]) for a in assignments if a[1] == 'VERILOG_FILE']
        assert files and all(p.is_file() for p in files), alvo
        assert len(files) == len(set(files)), alvo
        top = values['TOP_LEVEL_ENTITY']
        tops = [p for p in files if re.search(r'\bmodule\s+' + re.escape(top) + r'\b', p.read_text())]
        assert len(tops) == 1, (alvo, top)
        assert re.search(r'\binput\b[^;]*\bclock\b', tops[0].read_text()), alvo
        assert values['DEVICE'] == '5CEBA4F23C7'
        assert '[get_ports {clock}]' in Path(values['SDC_FILE']).read_text()
        print(f'PASS gerador Tcl {alvo}: {len(files)} fontes, top e clock')
    try:
        executar('alvo-inexistente')
    except tkinter.TclError:
        print('PASS gerador rejeita alvo inexistente')
    else:
        raise AssertionError('Alvo inexistente aceito')


if __name__ == '__main__':
    main()
