<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN">
<html>
    <head>
        <link type="text/css" rel="stylesheet" href="http://cptnahab.dataunity.com/cspace/images/cspace.css" />
        <link type="text/css" rel="stylesheet" href="http://cptnahab.dataunity.com/cspace/Styles/SyntaxHighlighter.css"></link>
        <script language="javascript" type="text/javascript" src="http://cptnahab.dataunity.com/cspace/Scripts/shCore.js"></script>
        <script language="javascript" type="text/javascript" src="http://cptnahab.dataunity.com/cspace/Scripts/shBrushPython.js"></script>
    </head>
    <body>
        <div id="page">
        
            <div id='header'>
                <img id='explogo' src='http://cptnahab.dataunity.com/cspace/images/experimental.png'/>
                <img id='logo' src='http://cptnahab.dataunity.com/cspace/images/cspacelogo.png'/>
                <br style="clear: both" /><br/>
                
                <img src="http://cptnahab.dataunity.com/cspace/images/headerline.png" height="4" />
                
            </div>
        
            <div id="pagecontent">
                <div class="index">
<!-- This is a (PRE) block.  Make sure it's left aligned or your toc title will be off. -->
%(toc)s
                </div>
                
                <h1>%(title)s</h1>

                <div class="summary">
                    %(summary)s
                </div>

                <div class="narrow">
                    %(wiki)s
                </div>
        
            </div>
        </div>
<script language="javascript">
dp.SyntaxHighlighter.ClipboardSwf = 'http://cptnahab.dataunity.com/cspace/Scripts/clipboard.swf';
dp.SyntaxHighlighter.HighlightAll('code');
</script>
    </body>
</html>
