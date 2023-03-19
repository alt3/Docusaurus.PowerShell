BeforeDiscovery {
    if (-not(Get-Module Alt3.Docusaurus.Powershell)) {
        throw "Required module 'Alt3.Docusaurus.Powershell' is not loaded."
    }
}

BeforeAll {
    . "$((Get-Item -Path $PSCommandPath).Directory.Parent.FullName)/Bootstrap.ps1" -TestFolder (Get-Item -Path $PSCommandPath)
    Import-Module $test.Module -Force -DisableNameChecking -Verbose:$False -Scope Global

    # generate and read Docusaurus files in $env:Temp
    InModuleScope Alt3.Docusaurus.Powershell -Parameters @{testModule = $test.Module; tempFolder = $test.TempFolder } {
        New-DocusaurusHelp -Module $testModule -DocsFolder $tempFolder
    }

    $generatedMdx = Get-Content -Path $test.MdxFile
    $expectedMdx = Get-Content (Join-Path -Path $test.Folder -ChildPath "Expected.mdx")
}

Describe "Integration test to ensure ensure proper unescaping of angle brackets inside inline code" {
    It "Mdx file generated for test should exist" {
        $test.MdxFile | Should -Exist
    }

    It "Mdx file generated for test should have content" {
        $generatedMdx | Should -Not -BeNullOrEmpty
    }

    It "Content of generated mdx file is identical to that of expected fixture" {
        $generatedMdx | Should -BeExactly $expectedMdx
    }
}
