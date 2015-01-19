package panels

class Nota {

    Usuario usuario
    Panel panel

    String titulo
    String keywords
    String contenido

    int posx = 0
    int posy = 0
    int width = 0
    int height = 0
    int zIndex = 0

    Date fecha = new Date()

    static mapping = {
        table: 'nota'
        cache usage: 'read-write', include: 'non-lazy'
        version false
        id generator: 'identity'

        columns {
            id column: 'nota__id'
            usuario column: 'usro__id'
            panel column: 'panl__id'

            titulo column: 'notatitl'
            keywords column: 'notakwrd'
            contenido column: 'notacntn'
            contenido type: 'text'

            posx column: 'notaposx'
            posy column: 'notaposy'
            width column: 'notawdth'
            height column: 'notahght'
            zIndex column: "notazind"

            fecha column: 'notafcha'
        }
    }

    static constraints = {
        titulo minSize: 3, maxSize: 20
        contenido nullable: true
    }

}
