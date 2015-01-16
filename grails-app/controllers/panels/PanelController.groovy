package panels

class PanelController {

    def creaArbol(Panel panel) {
        def arbol = ""

        def paneles = panel ? Panel.findAllByPadre(panel, [sort: "nombre"]) : Panel.findAllByPadreIsNull([sort: "nombre"])

        paneles.each { p ->
            def notas = Nota.countByPanel(p)
            def hijos = Panel.findAllByPadre(p, [sort: "nombre"])
            def clase = hijos.size() > 0 ? "jstree-open" : ""
            def type = "panel"
            if (notas == 0) {
                type = "noNotes"
            }
            def data = "\"type\":\"${type}\""
            if (p.icon && p.icon != "") {
                data += ", \"icon\":\"${p.icon}\""
            }
            arbol += "<li id='panel_${p.id}' class='${clase}' data-jstree='{${data}}'" +
                    "data-notas='${notas}'>"
            arbol += p.nombre + " (${notas})"
            if (hijos.size() > 0) {
                arbol += "<ul>"
                arbol += creaArbol(p)
                arbol += "</ul>"
            }
            arbol += "</li>"
        }


        return arbol
    }

    def index() {
        def arbol = "<ul>"
        arbol += "<li id='root_0' data-jstree='{\"type\": \"root\"}'>Paneles"
        arbol += "<ul>"
        arbol += creaArbol(null)
        arbol += "</ul>"
        arbol += "</li>"
        arbol += "</ul>"

        return [arbol: arbol]
    }


    def save_ajax() {
        params.padre = params.padre.toLong()
        def panel = new Panel()
        panel.nombre = params.nombre.trim()
        panel.icon = params.icon.trim()
        if (params.padre != 0) {
            panel.padre = Panel.get(params.padre)
        }
        if (panel.save(flush: true)) {
            render "SUCCESS*Panel creado"
        } else {
            render "ERROR*" + renderErrors(bean: panel)
        }
    }
}
