<%--
  Created by IntelliJ IDEA.
  User: DELL
  Date: 15/01/2015
  Time: 21:18
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="main"/>
        <title>Paneles</title>

        <script src="${resource(dir: 'js/plugins/jQuery-xcolor', file: 'jquery.xcolor.min.js')}"></script>

        <script src="${resource(dir: 'js/plugins/ckeditor', file: 'ckeditor.js')}"></script>
        <script src="${resource(dir: 'js/plugins/ckeditor/adapters', file: 'jquery.js')}"></script>

        <script src="${resource(dir: 'js/plugins/jstree/dist', file: 'jstree.min.js')}"></script>
        <link href="${resource(dir: 'js/plugins/jstree/dist/themes/default', file: 'style.min.css')}" rel="stylesheet">
        %{--<link href="${resource(dir: 'js/plugins/jstree/dist/themes/default-dark', file: 'style.min.css')}" rel="stylesheet">--}%

        <style type="text/css">
        .sidePanel, .mainPanel {
            height : 550px;
            border : solid 2px #abcdef;
        }

        .sidePanel {
            /*background : red;*/
            overflow : auto;
        }

        .mainPanel {
            /*background : blue;*/
            overflow : hidden;
            position : relative;
            padding  : 5px;
        }
        </style>
    </head>

    <body>

        <div class="row">

            <div class="col-md-3 sidePanel text-center" id="loading">
                <p>Cargando</p>

                <p><img src="${resource(dir: 'images/spinners', file: 'spinner_64.GIF')}"/></p>
            </div>

            <div class="col-md-3 sidePanel hidden" id="tree">
                <util:renderHTML html="${arbol}"/>
            </div>

            <div class="col-md-9 mainPanel">
            </div>
        </div>

        <script type="text/javascript">
            var minW = 100, minH = 100, p = 0, editor = null;
            function createContextMenuTree(node) {
                var nodeStrId = node.id;
                var $node = $("#" + nodeStrId);
                var nodeId = nodeStrId.split("_")[1];

                var esRoot = $node.data("jstree").type == "root";
                var esNota = $node.data("jstree").type == "nota";

                var panelName = $node.find("a").html();

                var items = {};

                if (!esNota) {
                    items.crearPanel = {
                        label  : "Nuevo Panel",
                        icon   : "fa fa-clipboard text-info",
                        action : function () {
                            var msg = "";
                            msg += '<form class="form-horizontal">';
                            msg += '<div class="form-group">';
                            msg += '<label for="nombre" class="col-sm-3 control-label">Nombre</label>';
                            msg += '<div class="col-sm-5">';
                            msg += '<input type="text" class="form-control" id="nombre" />';
                            msg += '</div>';
                            msg += '</div>';
                            msg += '<div class="form-group">';
                            msg += '<label for="icon" class="col-sm-3 control-label">Clase del ícono</label>';
                            msg += '<div class="col-sm-5">';
                            msg += '<input type="text" class="form-control" id="icon" />';
                            msg += '</div>';
                            msg += '</div>';
                            msg += '</form>';

                            bootbox.dialog({
                                title   : "Crear panel",
                                message : msg,
                                buttons : {
                                    cancelar : {
                                        label     : "Cancelar",
                                        className : "btn-default",
                                        callback  : function () {
                                        }
                                    },
                                    success  : {
                                        label     : "<i class='fa fa-save'></i> Guardar",
                                        className : "btn-success",
                                        callback  : function () {
                                            lzmOpenLoader("Guardando panel");
                                            $.ajax({
                                                type    : "POST",
                                                url     : "${createLink(action:'save_ajax')}",
                                                data    : {
                                                    nombre : $("#nombre").val(),
                                                    icon   : $("#icon").val(),
                                                    padre  : nodeId
                                                },
                                                success : function (msg) {
                                                    var parts = msg.split("*");
                                                    log(parts[1], parts[0] == "SUCCESS" ? "success" : "error"); // log(msg, type, title, hide)
                                                    setTimeout(function () {
                                                        if (parts[0] == "SUCCESS") {
                                                            location.reload(true);
                                                        } else {
                                                            lzmCloseLoader();
                                                            return false;
                                                        }
                                                    }, 1000);
                                                }
                                            });
                                        }
                                    }
                                }
                            });
                        }
                    };

                    if (!esRoot) {
                        items.crearNota = {
                            label  : "Nueva Nota",
                            icon   : "fa fa-newspaper-o text-info",
                            action : function () {
                                var msg = "";
                                msg += '<form class="form-horizontal">';
                                msg += '<div class="form-group">';
                                msg += '<label for="titulo" class="col-sm-2 control-label">Título</label>';
                                msg += '<div class="col-sm-5">';
                                msg += '<input type="text" class="form-control" id="titulo" />';
                                msg += '</div>';
                                msg += '</div>';
                                msg += '<div class="form-group">';
                                msg += '<label for="keywords" class="col-sm-2 control-label">Keywords</label>';
                                msg += '<div class="col-sm-5">';
                                msg += '<input type="text" class="form-control" id="keywords" />';
                                msg += '</div>';
                                msg += '</div>';
                                msg += '</form>';

                                bootbox.dialog({
                                    title   : "Crear nota en " + panelName,
                                    message : msg,
                                    buttons : {
                                        cancelar : {
                                            label     : "Cancelar",
                                            className : "btn-default",
                                            callback  : function () {
                                            }
                                        },
                                        success  : {
                                            label     : "<i class='fa fa-save'></i> Guardar",
                                            className : "btn-success",
                                            callback  : function () {
                                                lzmOpenLoader("Guardando nota");
                                                $.ajax({
                                                    type    : "POST",
                                                    url     : "${createLink(controller: 'nota', action:'save_ajax')}",
                                                    data    : {
                                                        titulo   : $("#titulo").val(),
                                                        keywords : $("#keywords").val(),
                                                        padre    : nodeId
                                                    },
                                                    success : function (msg) {
                                                        var parts = msg.split("*");
                                                        log(parts[1], parts[0] == "SUCCESS" ? "success" : "error"); // log(msg, type, title, hide)
                                                        setTimeout(function () {
                                                            if (parts[0] == "SUCCESS") {
                                                                location.reload(true);
                                                            } else {
                                                                lzmCloseLoader();
                                                                return false;
                                                            }
                                                        }, 1000);
                                                    },
                                                    error   : function () {
                                                        log("Ha ocurrido un error interno", "error");
                                                    }
                                                });
                                            }
                                        }
                                    }
                                });
                            }
                        };
                    }
                }

                return items;
            }

            $(function () {
                $('#tree').on("loaded.jstree", function () {
                    $("#loading").addClass("hidden");
                    $("#tree").removeClass("hidden");
                }).on('select_node.jstree', function (event, data) {
                    var parts = data.node.id.split("_");
                    if (parts[0] == "nota") {
                        $(".mainPanel").html("");
                        $.ajax({
                            type    : "POST",
                            url     : "${createLink(controller: 'nota', action:'form_ajax')}",
                            data    : {
                                id : parts[1]
                            },
                            success : function (msg) {
                                $(".mainPanel").html(msg);
                            }
                        });
                    }
                }).jstree({
                    plugins     : ["types", "state", "contextmenu", "search"],
                    core        : {
                        multiple       : false,
                        check_callback : true,
                        themes         : {
                            variant : "small",
                            dots    : true,
                            stripes : true
                        }
                    },
                    contextmenu : {
                        show_at_node : false,
                        items        : createContextMenuTree
                    },
                    state       : {
                        key : "paneles"
                    },
                    types       : {
                        root    : {
                            icon : "fa fa-folder-open text-warning"
                        },
                        panel   : {
                            icon : "fa fa-clipboard text-success"
                        },
                        noNotes : {
                            icon : "icon-ghost text-info"
                        },
                        nota    : {
                            icon : "fa fa-newspaper-o text-info"
                        }
                    }
                });
            });
        </script>

    </body>
</html>