---
id: usage
title: Usage
---

Adding Docusaurus to a Powershell Module project requires three steps:

1. Adding the Docusaurus website skeleton
2. Generating Module documentation
3. Starting the Website

## Adding Docusaurus

Open a Powershell (Core).

Cd into your project's root folder.

Add the Docusaurus website skeleton by running:

```powershell
npx @docusaurus/init@next init docusaurus classic
```

Modify newly created file `docusaurus/sidebars.js`so it looks like this:

```js
const cmdlets = require('./docs/CmdLets/docusaurus.sidebar.js');

module.exports = {
  docs: {
    Docusaurus: ['doc1', 'doc2', 'doc3'],
    Features: ['mdx'],
    CmdLets: cmdlets
  },
};
```

## Generating Module Documentation

To generate Get-Help pages for any Powershell module run the following command.

```powershell
New-DocusaurusHelp -Module "ModuleName" -EditUrl "http://github.com/your/repo/sources"
```

> For demo data, replace `ModuleName` with e.g. `Microsoft.PowerShell.Management`

> After the command has completed, the `docusaurus/docs/CmdLets` folder
> should contain one `.mdx` file for each command exported by the Powershell module.

## Starting the Website

To start your website, cd into the `docusaurus` folder and run:

```powershell
yarn start
```
