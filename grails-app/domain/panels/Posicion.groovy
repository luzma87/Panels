package panels

class Posicion {

    Usuario usuario
    Nota nota

    int posx
    int posy
    int width
    int height
    int zIndex

    static mapping = {
        table: 'posc'
        cache usage: 'read-write', include: 'non-lazy'
        version false
        id generator: 'identity'

        columns {
            id column: 'posc__id'
            usuario column: 'usro__id'
            nota column: 'nota__id'

            posx column: 'poscposx'
            posy column: 'poscposy'
            width column: 'poscwdth'
            height column: 'poschght'
            zIndex column: "posczind"
        }
    }

    static constraints = {
    }
}
