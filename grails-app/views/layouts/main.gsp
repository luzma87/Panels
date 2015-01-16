<!DOCTYPE html>
<!--[if lt IE 7 ]> <html lang="en" class="no-js ie6"> <![endif]-->
<!--[if IE 7 ]>    <html lang="en" class="no-js ie7"> <![endif]-->
<!--[if IE 8 ]>    <html lang="en" class="no-js ie8"> <![endif]-->
<!--[if IE 9 ]>    <html lang="en" class="no-js ie9"> <![endif]-->
<!--[if (gt IE 9)|!(IE)]><!--> <html lang="en" class="no-js"><!--<![endif]-->
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
        <title><g:layoutTitle default="Grails"/></title>

        <link href="${resource(dir: 'bootstrap-3.3.1/css', file: 'bootstrap.min.css')}" rel="stylesheet">
        <link href="${resource(dir: 'bootstrap-3.3.1/css', file: 'bootstrap-theme.min.css')}" rel="stylesheet">

        <link href="${resource(dir: 'js/jquery-ui-1.11.2', file: 'jquery-ui.min.css')}" rel="stylesheet">
        <link href="${resource(dir: 'js/jquery-ui-1.11.2', file: 'jquery-ui.structure.min.css')}" rel="stylesheet">
        <link href="${resource(dir: 'js/jquery-ui-1.11.2', file: 'jquery-ui.theme.min.css')}" rel="stylesheet">

        <link href="${resource(dir: 'fonts/font-awesome-4.2.0/css', file: 'font-awesome.min.css')}" rel="stylesheet">
        <link href="${resource(dir: 'fonts/font-mfizz-1.2', file: 'font-mfizz.css')}" rel="stylesheet">

        <script src="${resource(dir: 'js/jquery-ui-1.11.2/external/jquery', file: 'jquery.js')}"></script>
        <script src="${resource(dir: 'js/jquery-ui-1.11.2', file: 'jquery-ui.min.js')}"></script>

        <script src="${resource(dir: 'bootstrap-3.3.1/js', file: 'bootstrap.min.js')}"></script>

        <script src="${resource(dir: 'js/plugins/bootbox', file: 'bootbox.js')}"></script>

        <script src="${resource(dir: 'js/plugins/pnotify', file: 'pnotify.custom.min.js')}"></script>
        <link href="${resource(dir: 'js/plugins/pnotify', file: 'pnotify.custom.min.css')}" rel="stylesheet">

        <script src="${resource(dir: 'js/plugins/lzm.context/js', file: 'lzm.context-0.5.js')}"></script>
        <link href="${resource(dir: 'js/plugins/lzm.context/css', file: 'lzm.context-0.5.css')}" rel="stylesheet">

        <script src="${resource(dir: 'js', file: 'ui.js')}"></script>

        <script type="text/javascript">
            var spinner64Url = "${resource(dir: 'images/spinners', file: 'spinner_64.GIF')}";

            var spinner64 = $("<img src='" + spinner64Url + "' alt='Cargando...'/>");
        </script>

        <g:layoutHead/>

        <style type="text/css">
        /* Move down content because we have a fixed navbar that is 50px tall */
        body {
            padding-top    : 60px;
            padding-bottom : 20px;
        }
        </style>

    </head>

    <body>

        <nav class="navbar navbar-inverse navbar-fixed-top">
            <div class="container">
                <div class="navbar-header">
                    <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
                        <span class="sr-only">Toggle navigation</span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                    </button>
                    <a class="navbar-brand" href="#">Panels</a>
                </div>

                <div id="navbar" class="navbar-collapse collapse">
                    <form class="navbar-form navbar-right">
                        <div class="form-group">
                            <input type="text" placeholder="Email" class="form-control">
                        </div>

                        <div class="form-group">
                            <input type="password" placeholder="Password" class="form-control">
                        </div>
                        <button type="submit" class="btn btn-success">Sign in</button>
                    </form>
                </div><!--/.navbar-collapse -->
            </div>
        </nav>

        <div class="container">
            <g:layoutBody/>
        </div> <!-- /container -->

    </body>
</html>
