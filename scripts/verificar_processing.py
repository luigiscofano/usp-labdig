"""Checagem Java do sketch sem abrir janela.

Recebe os JARs oficiais Processing Core, Serial e JSSC pelo argumento --classpath.
Aplica apenas adaptações usuais do modo Java do Processing e usa javac.
Não substitui o preprocessor oficial nem valida renderização/porta física.
"""
from pathlib import Path
import argparse,re,subprocess,sys
ROOT=Path(__file__).resolve().parents[1]
def main():
 p=argparse.ArgumentParser();p.add_argument('--classpath',required=True);p.add_argument('--javac',default='javac');p.add_argument('--java',default='java');args=p.parse_args()
 sketch=ROOT/'projetos/guardiao-do-paredao/processing/Guardiao/Guardiao.pde'
 text=sketch.read_text();imports='\n'.join(re.findall(r'(?m)^import .*;',text))
 text=re.sub(r'(?m)^import .*;\s*','',text)
 text=re.sub(r'(?m)^(void|int|float|boolean|String) (\w+)\(',r'public \1 \2(',text)
 # A conversão numérica preserva strings e comentários.
 token=re.compile(r'"(?:\\.|[^"\\])*"|\'(?:\\.|[^\'\\])*\'|//[^\n]*|/\*[\s\S]*?\*/|\b(?:int|float)\(|(?<![\w.])\d+\.\d+(?![\w.])')
 def adapt(m):
  s=m.group()
  if s=='int(':return 'PApplet.parseInt('
  if s=='float(':return 'PApplet.parseFloat('
  if re.fullmatch(r'\d+\.\d+',s):return s+'f'
  return s
 text=token.sub(adapt,text).replace('size(960, 600);','').replace('smooth();','')
 target=ROOT/'build/processing';target.mkdir(parents=True,exist_ok=True)
 (target/'Guardiao.java').write_text('import processing.core.*;\nimport java.io.*;\n'+imports+'\npublic class Guardiao extends PApplet {\npublic void settings(){size(960,600);smooth();}\n'+text+'\n}')
 result=subprocess.run([args.javac,'-cp',args.classpath,str(target/'Guardiao.java'),str(ROOT/'tests/GuardiaoLogicTest.java'),'-d',str(target)],capture_output=True,text=True)
 print(result.stdout+result.stderr)
 if result.returncode:return result.returncode
 run=subprocess.run([args.java,'-Djava.awt.headless=true','-cp',str(target)+__import__('os').pathsep+args.classpath,'GuardiaoLogicTest'],capture_output=True,text=True)
 print(run.stdout+run.stderr)
 if run.returncode:return run.returncode
 print('PASS compilacao Java da adaptacao do sketch. Janela e porta serial nao executadas.')
 return 0
if __name__=='__main__':sys.exit(main())
