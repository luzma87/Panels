package panels

class Usuario {

    String user
    String pass

    static mapping = {
        table: 'usro'
        cache usage: 'read-write', include: 'non-lazy'
        version false
        id generator: 'identity'

        columns {
            id column: 'usro__id'
            user column: 'usrouser'
            pass column: 'usropass'
        }
    }

    static constraints = {
        user minSize: 3, maxSize: 9, unique: true
        pass nullable: true, password: true
    }
}
