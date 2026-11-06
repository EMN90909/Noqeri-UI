#!/usr/bin/env node
import { mkdtemp, mkdir, readFile, writeFile, copyFile, rm } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import { join, resolve } from 'node:path';
import { pathToFileURL } from 'node:url';
const root=resolve(new URL('..',import.meta.url).pathname);
const compilerRoot=resolve(process.env.NOQERI_REPO || process.argv[2] || '../Noqeri');
const { buildWebProject }=await import(pathToFileURL(join(compilerRoot,'Runtime','web-project.mjs')).href);
const temp=await mkdtemp(join(tmpdir(),'noqeri-ui-'));
try {
    const app=join(temp,'app'),out=join(temp,'dist');
    await mkdir(join(app,'noqeri'),{recursive:true});
    await copyFile(join(root,'src','components.noqeri'),join(app,'noqeri','components.noqeri'));
    await copyFile(join(root,'examples','showcase','main.noqeri'),join(app,'main.noqeri'));
    await copyFile(join(root,'styles.css'),join(app,'styles.css'));
    const built=await buildWebProject({source:app,out});
    const page=await readFile(join(out,'components','index.html'),'utf8');
    if(!page.includes('Noqeri'))throw Error('generated showcase missing content');
    const module=await import(pathToFileURL(join(out,'main.mjs')).href);
    const tree=JSON.stringify(module.render());
    if(!tree.includes('nui-card')||!tree.includes('nui-accordion-item')||!tree.includes('nui-button'))throw Error('components missing in compiled render tree');
    console.log('Noqeri UI showcase build OK',built,'output:',out);
    if(process.env.NOQERI_KEEP_DEMO){const fs=await import('node:fs/promises');await fs.cp(out,resolve(process.env.NOQERI_KEEP_DEMO),{recursive:true});}
}finally{await rm(temp,{recursive:true,force:true});}
