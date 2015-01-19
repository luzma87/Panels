package panels

class NotaController {

    def notasPanel() {
        def panel = Panel.get(params.id)
        def notas = Nota.findAllByPanel(panel)
        return [panel: panel, notas: notas]
    }

    def save_ajax() {
        session.usuario = Usuario.findByUser("luz")
        def nota = new Nota()
        if (params.id) {
            nota = Nota.get(params.id)
        }
        def panel = Panel.get(params.padre.toLong())
        nota.properties = params
        def keywords = params.keywords
        def padre = panel
        while (padre) {
            keywords = padre.nombre + " " + keywords
            padre = padre.padre
        }

        nota.keywords = keywords
        nota.panel = panel
        nota.usuario = session.usuario
        if (nota.save(flush: true)) {
            render "SUCCESS*Nota ${params.id ? 'modificada' : 'creada'} exitosamente"
        } else {
            render "ERROR*Ha ocurrido un error al guardar la nota: " + renderErrors(bean: nota)
        }
    }

    def form_ajax() {
        def nota = Nota.get(params.id)
        return [nota: nota]
    }

    def save_ajax_old() {

        session.usuario = Usuario.findByUser("luz")

        def nota = new Nota()
        if (params.accion == "n") {
            nota = Nota.get(params.id)
        }
        nota.titulo = params.titulo.trim()
        nota.keywords = params.keywords.trim()
        nota.contenido = params.contenido.trim()
        nota.panel = Panel.get(params.panel.toLong())
        nota.usuario = session.usuario
        nota.posx = params.x.toInteger()
        nota.posy = params.y.toInteger()
        nota.width = params.w.toInteger()
        nota.height = params.h.toInteger()
        nota.zIndex = params.z.toInteger()

        if (nota.save(flush: true)) {
            render "SUCCESS*Nota ${params.accion == 'c' ? 'creada' : 'modificada'} exitosamente*" + nota.id
        } else {
            render "ERROR*Ha ocurrido un error al guardar la nota: " + renderErrors(bean: nota)
        }
    }
}
