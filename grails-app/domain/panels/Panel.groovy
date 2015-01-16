package panels

class Panel {

    String nombre
    String icon
    Panel padre

    static mapping = {
        table: 'panl'
        cache usage: 'read-write', include: 'non-lazy'
        version false
        id generator: 'identity'

        columns {
            id column: 'panl__id'
            nombre column: 'panlnmbr'
            icon column: 'panlicon'
            padre column: 'panlpadr'
        }
    }

    static constraints = {
        nombre minSize: 3, maxSize: 20
        icon nullable: true
        padre nullable: true
    }
}
