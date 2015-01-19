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
        %{--<script src="${resource(dir: 'js/plugins/ckeditor/adapters', file: 'jquery.js')}"></script>--}%

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
            padding  : 0;
        }

        .creatingNote {
            cursor : crosshair;
        }

        .nota {
        }

        .divTitle, .divKeywords {
            width   : 100%;
            padding : 4px;
        }

        .divTitle {
            font-size   : 12pt;
            font-weight : bold;
        }

        .divKeywords {
            font-size : 9pt;
        }

        .divContenido {
            width : 100%;
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

//                console.log(node, nodeStrId, $node, nodeId);

                var items = {};

                items.crear = {
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

                return items;
            }

            function createContextMenu(node) {
                var $node = $(node);

                var items = {
                    header : {
                        label  : "Acciones",
                        header : true
                    }
                };

                items.crear = {
                    label  : "Nueva nota",
                    icon   : "fa fa-file text-info",
                    action : function ($element) {
                        $node.addClass("creatingNote");
                    }
                };

                return items;
            }

            function reloadNotas(panelId) {
                lzmOpenLoader("Buscando notas");
                $.ajax({
                    type    : "POST",
                    url     : "${createLink(controller: 'nota', action:'notasPanel')}",
                    data    : {
                        id : panelId
                    },
                    success : function (msg) {
                        $(".mainPanel").html(msg);
                        lzmCloseLoader();
                    }
                });
            }

            function saveNota(notaId) {
                var data = {};
                var parts = notaId.split("_");
                var $nota = $("#" + notaId);
                var action = parts[0];

                data.id = parts[1];
                data.title = "";
                data.keywords = "";
                data.contenido = "";
                data.panel = "";

                $.ajax({
                    type    : "POST",
                    url     : "${createLink(controller: 'nota', action:'notasPanel')}",
                    data    : data,
                    success : function (msg) {
                        var parts = msg.split("*");
                        log(parts[1], parts[0] == "SUCCESS" ? "success" : "error"); // log(msg, type, title, hide)
                    }
                });
            }

            function stopEditing() {
                var contenido = editor.getData();
                var name = editor.name;

                // Destroy the editor.
                editor.destroy();
                editor = null;
            }

            $(function () {
                var $mainPanel = $(".mainPanel");
                var $pos = $mainPanel.position();

                $mainPanel.on("mousedown", function (ev) {
                    if ($mainPanel.hasClass("creatingNote")) {
                        var $div = $("<div>");
                        $div.attr("id", "c_" + p);
                        $div.addClass("creating");

                        var click_y = ev.pageY - $pos.top;
                        var click_x = ev.pageX - $pos.left;

                        $div.css({
                            backgroundColor : "rand",
                            position        : "absolute",
                            border          : "dotted 1px #000",
                            top             : click_y,
                            left            : click_x,
                            width           : 0,
                            height          : 0,
                            textAlign       : "center"
                        });
                        $div.appendTo($mainPanel);

                        $mainPanel.on("mousemove", function (ev) {
                            var move_x = ev.pageX - $pos.left,
                                    move_y = ev.pageY - $pos.top,
                                    width = Math.abs(move_x - click_x),
                                    height = Math.abs(move_y - click_y);

                            $div.css({
                                width  : width,
                                height : height
                            });
                            $div.text(width + "x" + height);
                            if (width < minW || height < minH) {
                                $div.css({
                                    border : "dotted 1px #000"
                                });
                            } else {
                                $div.css({
                                    border : "dotted 2px #000"
                                });
                            }
                            if (move_x < click_x) { //mouse moving left instead of right
                                $div.css({
                                    left : click_x - width
                                });
                            }
                            if (move_y < click_y) { //mouse moving up instead of down
                                $div.css({
                                    top : click_y - height
                                });
                            }
                        }).on('mouseup', function (e) {
                            $mainPanel.off('mousemove').removeClass("creatingNote");
                            if (!$mainPanel.hasClass("creatingNote") && $(".creating").length > 0) {
                                if ($div.width() < minW || $div.height() < minH) {
                                    $div.remove();
                                } else {
                                    var $note = $("#c_" + p);
                                    $note.text("");
                                    $note.addClass("nota").css({
                                        border : "solid 2px #000"
                                    });
                                    $note.click(function () {
                                        if (!$mainPanel.hasClass("creatingNote")) {
                                            var topZ = 0;
                                            $('.nota').each(function () {
                                                var thisZ = parseInt($(this).css('zIndex'), 10);
                                                if (thisZ > topZ) {
                                                    topZ = thisZ;
                                                }
                                            });
                                            $(this).css('zIndex', (topZ + 1));
                                        }
                                        return false;
                                    }).draggable({
                                        handle      : ".divTitle",
                                        containment : ".mainPanel",
                                        scroll      : false
                                    }).resizable({
                                        handles : "all"
                                    });
                                    var noteBg = $note.css("backgroundColor");
                                    var keywBg = $.xcolor.darken(noteBg);
                                    var titleBg = $.xcolor.darken(keywBg);

                                    var $divTitle = $("<div>");
                                    var $inputTitle = $("<input type='text' class='form-control input-sm inputTitle' " +
                                                        "placeholder='Título'/>");
                                    $divTitle.addClass("divTitle").append($inputTitle);
                                    $inputTitle.focus();
                                    $note.append($divTitle);
                                    $divTitle.css("backgroundColor", titleBg);

                                    var $divKeywords = $("<div>");
                                    var $inputKeywords = $("<input type='text' class='form-control input-sm inputKeywords' " +
                                                           "placeholder='Keywords'/>");
                                    $divKeywords.addClass("divKeywords").append($inputKeywords);
                                    $note.append($divKeywords);
                                    $divKeywords.css("backgroundColor", keywBg);

                                    var $divContenido = $("<div>");
                                    $divContenido.attr("id", "divContenido_" + p);
                                    $divContenido.attr("name", "divContenido_" + p);
                                    $divContenido.addClass("divContenido");
                                    $divContenido.css("color", $.xcolor.complementary(noteBg));
                                    $note.append($divContenido);

                                    var config = {};
                                    config.toolbar = [
                                        ['Source', '-', 'NewPage', 'Preview', '-', 'Templates'],
                                        ['Cut', 'Copy', 'Paste', 'PasteText', 'PasteFromWord', '-', 'Undo', 'Redo'],
                                        '/',
                                        ['Bold', 'Italic']
                                    ];
                                    var html = "";
                                    editor = CKEDITOR.appendTo('divContenido_' + p, config, html);

//                                    console.log($divContenido);
//                                    $inputContenido.ckeditor({
//                                        uiColor : '#9AB8F3'
//                                    });

                                    $note.removeClass("creating");
                                    p++;
                                }
                            }
                        });
                    }
                });

                $mainPanel.lzmContextMenu({
                    items : createContextMenu
                });

                $('#tree').on("loaded.jstree", function () {
                    $("#loading").addClass("hidden");
                    $("#tree").removeClass("hidden");
                }).on('select_node.jstree', function (event, data) {
                    var parts = data.node.id.split("_");
                    reloadNotas(parts[1]);
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
                        }
                    }
                });
            });
        </script>

    </body>
</html>