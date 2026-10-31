"""Compila os alvos independentes e executa testes com resultado verificável."""
from pathlib import Path
import argparse,json,os,shutil,subprocess,sys,time
ROOT=Path(__file__).resolve().parents[1]
def main():
 parser=argparse.ArgumentParser();parser.add_argument('--somente-compilar',action='store_true');args=parser.parse_args()
 iv=os.environ.get('IVERILOG',shutil.which('iverilog') or 'iverilog');vvp=os.environ.get('VVP',shutil.which('vvp') or 'vvp')
 base=os.environ.get('IVERILOG_BASE');prefix=[iv]+(['-B',base] if base else [])
 build=ROOT/'build';build.mkdir(exist_ok=True);results=[]
 targets=[('guardiao','projetos/guardiao-do-paredao/rtl','guardiao'),('math-genius','projetos/math-genius/rtl','MathGenius'),('lab1-exp03','labdig-1/experimentos/exp-03/rtl','circuito_exp3'),('lab1-exp04','labdig-1/experimentos/exp-04/rtl','circuito_exp4'),('lab1-exp05','labdig-1/experimentos/exp-05/rtl','circuito_exp5'),('lab1-exp06','labdig-1/experimentos/exp-06/rtl','jogo_desafio_memoria'),('lab2-servo','labdig-2/experimentos/exp-01/rtl','controle_servo'),('lab2-uart','labdig-2/experimentos/exp-02/rtl','tx_serial_7E1')]
 targets += [('lab1-exp01','labdig-1/experimentos/exp-01/rtl','contador_didatico'),('lab1-exp02','labdig-1/experimentos/exp-02/rtl','circuito_exp2_ativ2'),('lab2-exp03','labdig-2/experimentos/exp-03/rtl','interface_ultrassonica'),('lab2-exp04','labdig-2/experimentos/exp-04/rtl','trena_serial'),('lab2-exp05','labdig-2/experimentos/exp-05/rtl','sonar')]
 for name,folder,top in targets:
  files=[str(p.relative_to(ROOT)) for p in sorted((ROOT/folder).rglob('*.v'))]
  if name in ['lab2-exp03','lab2-exp04','lab2-exp05']:
   files += [str(p.relative_to(ROOT)) for p in sorted((ROOT/'projetos/guardiao-do-paredao/rtl').rglob('*.v'))]
   files += [str(p.relative_to(ROOT)) for p in sorted((ROOT/'biblioteca/rtl').glob('*.v'))]
  result=subprocess.run(prefix+['-g2005','-s',top,'-o',str(build/(name+'.vvp'))]+files,cwd=ROOT,capture_output=True,text=True)
  results.append({'nome':name,'tipo':'compilacao','passou':result.returncode==0,'log':result.stdout+result.stderr})
 if not args.somente_compilar:
  rtl=[str(p.relative_to(ROOT)) for p in sorted((ROOT/'projetos/guardiao-do-paredao/rtl').rglob('*.v'))]
  rtl += [str(p.relative_to(ROOT)) for p in sorted((ROOT/'labdig-2/experimentos/exp-05/rtl').glob('*.v'))]
  rtl += [str(p.relative_to(ROOT)) for p in sorted((ROOT/'labdig-1/experimentos/exp-01/rtl').glob('*.v'))]
  for name in ['componentes','uart','controle_guardiao','pacote','aquisicao','telemetria','sonar_integrado','pwm_contador']:
   top='tb_'+name;binary=build/(top+'.vvp')
   c=subprocess.run(prefix+['-g2012','-s',top,'-o',str(binary),'tests/'+top+'.sv']+rtl+[str(p.relative_to(ROOT)) for p in sorted((ROOT/'biblioteca/rtl').glob('*.v'))],cwd=ROOT,capture_output=True,text=True)
   log=c.stdout+c.stderr;ok=False
   if c.returncode==0:
    try:
     r=subprocess.run([vvp,str(binary)],cwd=ROOT,capture_output=True,text=True,timeout=20);log+=r.stdout+r.stderr;ok=r.returncode==0 and 'PASS ' in r.stdout
    except subprocess.TimeoutExpired:log+='Tempo limite excedido.'
   results.append({'nome':top,'tipo':'simulacao','passou':ok,'log':log})
 report={'ferramenta':'Icarus Verilog','resultados':results,'limite':'Compilacao e simulacao digital. Sintese Quartus, temporizacao e hardware nao executados.'}
 (build/'resultados.json').write_text(json.dumps(report,ensure_ascii=False,indent=2))
 for x in results:
  print(('PASS' if x['passou'] else 'FAIL')+' '+x['nome']);print(x['log'].strip())
 return 0 if all(x['passou'] for x in results) else 1
if __name__=='__main__':sys.exit(main())
