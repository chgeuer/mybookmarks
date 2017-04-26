

# Using Typescript in a non-web project in Visual Studio 2013

When adding a TypeScript project to a non-web project (Self-hosted OWIN with static files), it might be necessary to manually tweak the CSPROJ file and add a ``<TypeScriptToolsVersion>`` element and import the ``Microsoft.TypeScript.targets``:

```XML
<Project ToolsVersion="12.0" DefaultTargets="Build" xmlns="http://schemas.microsoft.com/developer/msbuild/2003">
  <Import ... />
  <PropertyGroup>
  	...
    <OutputType>Library</OutputType>
    ...
    <TypeScriptToolsVersion>1.0</TypeScriptToolsVersion>
  </PropertyGroup>
  ...
  <ItemGroup>
    <TypeScriptCompile Include="site\app\app.module.ts" />
    <TypeScriptCompile Include="site\app\testcontroller.ts" />
  </ItemGroup>
 <Import Project="$(MSBuildExtensionsPath32)\Microsoft\VisualStudio\v$(VisualStudioVersion)\TypeScript\Microsoft.TypeScript.targets" Condition="Exists('$(MSBuildExtensionsPath32)\Microsoft\VisualStudio\v$(VisualStudioVersion)\TypeScript\Microsoft.TypeScript.targets')" />
  <Import Project="$(SolutionDir)\.nuget\NuGet.targets" Condition="Exists('$(SolutionDir)\.nuget\NuGet.targets')" />
...
```
