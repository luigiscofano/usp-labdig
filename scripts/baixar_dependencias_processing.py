"""Baixa versões fixas das bibliotecas de teste e confere SHA-256."""
from pathlib import Path
import hashlib,json,os,urllib.request
ROOT=Path(__file__).resolve().parents[1]
def main():
 destination=ROOT/'build/deps';destination.mkdir(parents=True,exist_ok=True)
 files=[]
 for item in json.loads((ROOT/'tests/processing-deps.json').read_text()):
  p=destination/item['arquivo']
  if not p.exists() or hashlib.sha256(p.read_bytes()).hexdigest()!=item['sha256']:
   with urllib.request.urlopen(item['url'],timeout=60) as response:data=response.read()
   if hashlib.sha256(data).hexdigest()!=item['sha256']:raise RuntimeError('Hash inesperado: '+item['arquivo'])
   p.write_bytes(data)
  files.append(str(p))
 print(os.pathsep.join(files))
if __name__=='__main__':main()
