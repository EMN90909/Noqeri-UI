import test from 'node:test';
import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';
import { resolve, join } from 'node:path';
import { pathToFileURL } from 'node:url';
import { execFileSync } from 'node:child_process';
const root=resolve(new URL('..',import.meta.url).pathname);
const src=await readFile(join(root,'src','components.noqeri'),'utf8');
const css=await readFile(join(root,'styles.css'),'utf8');
const showcase=await readFile(join(root,'examples','showcase','main.noqeri'),'utf8');
const compilerRoot=resolve(process.env.NOQERI_REPO||'../Noqeri');
test('public component definitions are unique and meaningful',()=>{
 const names=[...src.matchAll(/^component\s+([A-Za-z][A-Za-z_0-9]*)\s*\(/gm)].map(m=>m[1]);
 assert.ok(names.length>=80,'expected comprehensive core');
 assert.equal(names.length,new Set(names).size,'duplicate exports');
 for(const name of ['Checkbox','Radio','Switch','EmailField','Disclosure','AccordionItem','TableRow2','PageHeader','Spinner']) assert.ok(names.includes(name),name);
});
test('component tokens and safe attributes',()=>{
 assert.ok(!src.includes('innerHTML'));
 assert.ok(!src.includes('<script'));
 for(const k of ['--nui-primary','--nui-border','.nui-root :where(a,button,input,select,textarea,summary):focus-visible','prefers-reduced-motion','.nui-theme-dark'])assert.ok(css.includes(k),'missing '+k);
 for(const cls of ['nui-card','nui-button','nui-field','nui-input','nui-tab','nui-accordion-item','nui-alert'])assert.ok(css.includes('.'+cls),cls);
 assert.match(showcase,/on\.click/);
});
test('real Noqeri browser compiler parses all components and showcase',async()=>{
 const {parseView,compileView}=await import(pathToFileURL(join(compilerRoot,'Runtime','web-view-compiler.mjs')).href);
 const parsed=parseView(src);
 assert.ok(parsed.components.length>=80);
 assert.doesNotThrow(()=>compileView(src));
 assert.doesNotThrow(()=>compileView(showcase));
});
test('Noqeri compiler builds a runnable example',()=>{
 const env={...process.env,NOQERI_REPO:compilerRoot};
 execFileSync(process.execPath,[join(root,'scripts','build-showcase.mjs')],{cwd:root,env,stdio:'pipe',timeout:60000});
});
