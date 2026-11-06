import test from 'node:test';
import assert from 'node:assert/strict';
import {mkdtemp,mkdir,readFile,writeFile,rm} from 'node:fs/promises';
import {tmpdir} from 'node:os';
import {join,resolve} from 'node:path';
import {installFromPackage} from '../scripts/install.mjs';
const repo=resolve(new URL('..',import.meta.url).pathname);
test('registry package installer stages source, links CSS and remains idempotent',async()=>{
 const temp=await mkdtemp(join(tmpdir(),'noqeri-ui-install-'));
 try {
  const pkg=join(temp,'pkg'),app=join(temp,'app');
  await mkdir(join(pkg,'src'),{recursive:true});await mkdir(app);
  await writeFile(join(pkg,'src','components.noqeri'),await readFile(join(repo,'src','components.noqeri')));
  await writeFile(join(pkg,'styles.css'),await readFile(join(repo,'styles.css')));
  await writeFile(join(app,'styles.css'),'.app { color: red; }\n');
  const first=await installFromPackage(pkg,app);
  assert.equal(first.updated.length,2);
  assert.equal(await readFile(join(app,'noqeri','components.noqeri'),'utf8'),await readFile(join(repo,'src','components.noqeri'),'utf8'));
  const original=await readFile(join(app,'styles.css'),'utf8');
  assert.ok(original.startsWith('@import "./noqeri-ui.css";\n'));
  assert.ok(original.includes('.app { color: red; }'));
  const second=await installFromPackage(pkg,app);
  assert.equal(second.updated.length,0);
  assert.equal(await readFile(join(app,'styles.css'),'utf8'),original);
  await writeFile(join(app,'noqeri','components.noqeri'),'custom code');
  await assert.rejects(()=>installFromPackage(pkg,app),/refusing to overwrite/);
  await installFromPackage(pkg,app,{force:true});
  assert.equal(await readFile(join(app,'noqeri','components.noqeri'),'utf8'),await readFile(join(repo,'src','components.noqeri'),'utf8'));
 }finally{await rm(temp,{recursive:true,force:true});}
});
