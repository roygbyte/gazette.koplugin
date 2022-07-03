local ExampleContent = {

}

ExampleContent.XHTML_EXAMPLE_CONTENT = [[
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:epub="http://www.idpf.org/2007/ops" xml:lang="en">
<head>
<title>Minimal EPUB 3.2</title>
<link rel="stylesheet" href="css/style.css"/>
<link href="https://fonts.googleapis.com/css?family=Charmonman" rel="stylesheet"/>
</head>
<body>
<!-- uses WOFF2 font
     uses remote font
     uses non-SSV epub type attribute value
     includes foreign resource without fallback
     -->
<section epub:type="foo">
<p class="remote">This text should be in Charoman</p>
<p class="woff2">This text should be in Open Sans.</p>
</section>
</body>
</html>
]]

return ExampleContent
