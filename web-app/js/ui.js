bootbox.setDefaults({
    locale      : "es",
    closeButton : false,
    show        : true
});

/**
 * muestra notificaciones flotantes
 * @param msg: el mensaje a mostrar
 * @param type: tipo de mensaje: 'error' o 'success' (opcional, default a 'info')
 * @param title: el titulo del mensaje (opcional)
 * @param hide: si se oculta solo o no (opcional)
 */
function log(msg, type, title, hide) {
    if (hide === undefined) {
        hide = type != "error";
    }
    if (type === undefined) {
        type = "info";
    }
    var icon;
    if (!title) {
        switch (type) {
            case "error":
                title = "Ha ocurrido un error";
                icon = "fa fa-warning fa-2x";
                break;
            case "success":
                title = "Transacción exitosa";
                icon = "fa fa-check fa-2x";
                break;
        }
    }

    if (msg === undefined) {
        msg = "";
    }
    new PNotify({
        title   : title,
        icon    : icon,
        buttons : {
            closer_hover  : false,
            sticker_hover : false
        },
        styling : 'fontawesome',
        text    : msg,
        type    : type,
        hide    : hide
    });
}
function lzmOpenLoader(msg, title) {
    msg = $.trim(msg);
    title = $.trim(title);
    var $msg = $("<div/>");
    $msg.addClass("text-center");
    if (msg !== undefined && msg != "") {
        $msg.append("<p>" + msg + "</p>");
    }
    if (title === undefined || title == "") {
        title = "Por favor espere";
    }
    $msg.append(spinner64);

    bootbox.dialog({
        id          : 'dlgLoader',
        title       : title,
        message     : $msg,
        closeButton : false,
        class       : "modal-sm"
    });
    $("#dlgLoader").css({zIndex : 1061})
}
function lzmCloseLoader() {
    $("#dlgLoader").modal('hide');
}