#!/usr/bin/env node
// Install the signed-by-digest Noqeri Registry component sources into a browser-view project.
// No third-party runtime dependencies. No force-overwrite without explicit --force.
import { lstat, mkdir, readFile, writeFile, copyFile } from 'node:fs/promises';
import { join, resolve, dirname } from 'node:path';
import { pathToFileURL, fileURLToPath } from 'node:url';

const TOKEN='@import "./noqeri-ui.css";';
async function safeStat(path){
  try { const stat=await lstat(path); if(stat.isSymbolicLink())throw Error('refusing symlink: '+path);return stat }
  catch(err){if(err.code==='ENOENT')return null;throw err}
}
export async function installFromPackage(packagePath, targetDir, {force=false}={}) {
  const root=resolve(targetDir);
  const rootStat=await safeStat(root);
  if(!rootStat?.isDirectory())throw Error('target application directory does not exist: '+root);
  const uiDirectory=join(root,'noqeri');
  const existingDir=await safeStat(uiDirectory);
  if(existingDir&&!existingDir.isDirectory())throw Error('noqeri/ must be a directory');
  const targets=[
    {source:join(packagePath,'src','components.noqeri'),destination:join(uiDirectory,'components.noqeri')},
    {source:join(packagePath,'styles.css'),destination:join(root,'noqeri-ui.css')}
  ];
  // Check all destinations before changing any of them.
  const pending=[];
  for(const pair of targets) {
    const expected=await readFile(pair.source);
    const current=await safeStat(pair.destination);
    if(current&&!current.isFile())throw Error('destination is not a regular file: '+pair.destination);
    if(current) {
      const old=await readFile(pair.destination);
      if(old.equals(expected))continue;
      if(!force)throw Error('refusing to overwrite existing '+pair.destination+' (pass --force to replace)');
    }
    pending.push(pair);
  }
  const mainStyles=join(root,'styles.css');
  const styleStat=await safeStat(mainStyles);
  if(styleStat&&!styleStat.isFile())throw Error('styles.css must be a regular file');
  const currentStyles=styleStat?await readFile(mainStyles,'utf8'):'';
  await mkdir(uiDirectory,{recursive:true});
  for(const pair of pending)await copyFile(pair.source,pair.destination);
  if(!currentStyles.includes(TOKEN))await writeFile(mainStyles,TOKEN+'\n'+currentStyles,'utf8');
  return {target:root,updated:pending.map(p=>p.destination),stylesLinked:true};
}
export async function installFromRegistry(projectDir,{compilerRepo,force=false}={}) {
  const compilerRoot=resolve(compilerRepo||process.env.NOQERI_REPO||'../Noqeri');
  const managerURL=pathToFileURL(join(compilerRoot,'Runtime','package-manager.mjs')).href;
  const {createPackageManager}=await import(managerURL);
  const pkg=await createPackageManager().fetchPackage('noqeri/components','0.1.0');
  return installFromPackage(pkg.path,projectDir,{force});
}
const invoked=process.argv[1]&&fileURLToPath(import.meta.url)===resolve(process.argv[1]);
if(invoked) {
  const args=process.argv.slice(2).filter(x=>x!=='--force');
  if(args.length<1||args.length>2) {
    console.error('Usage: NOQERI_REPO=/path/to/Noqeri node scripts/install.mjs <app-directory> [noqeri-repo] [--force]');
    process.exitCode=2;
  }else{
    try{
      const result=await installFromRegistry(args[0],{compilerRepo:args[1],force:process.argv.includes('--force')});
      console.log('Noqeri UI 0.1.0 installed:',result);
    }catch(err){console.error(err.message);process.exitCode=1}
  }
}
