<%--
  Created by IntelliJ IDEA.
  User: DELL
  Date: 15/01/2015
  Time: 21:20
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="main"/>
        <title>Usuarios</title>
    </head>

    <body>

        <div class="btn-toolbar" role="toolbar">
            <div class="btn-group" role="group">
                <a href="#" class="btn btn-success" id="btnNewUser">
                    <i class="fa fa-plus"></i> Nuevo usuario
                </a>
            </div>
        </div>

        <div class="row" style="margin-top: 10px;">
            <div class="col-md-5">
                <ul class="list-group">
                    <g:each in="${usuarios}" var="usuario">
                        <li class="list-group-item">${usuario.user}</li>
                    </g:each>
                </ul>
            </div>
        </div>

        <script type="text/javascript">
            $(function () {
                $("#btnNewUser").click(function () {
                    var msg = "";
                    msg += '<form class="form-horizontal">';
                    msg += '<div class="form-group">';
                    msg += '<label for="user" class="col-sm-2 control-label">Usuario</label>';
                    msg += '<div class="col-sm-5">';
                    msg += '<input type="text" class="form-control" id="user" />';
                    msg += '</div>';
                    msg += '</div>';
                    msg += '</form>';

                    bootbox.dialog({
                        title   : "Crear usuario",
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
                                    lzmOpenLoader("Guardando usuario");
                                    $.ajax({
                                        type    : "POST",
                                        url     : "${createLink(action:'save_ajax')}",
                                        data    : {
                                            user : $("#user").val()
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
                    return false;
                });
            });
        </script>

    </body>
</html>