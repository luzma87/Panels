package panels

class UsuarioController {

    def index() {
        redirect(action: 'list')
    }

    def list() {
        def usuarios = Usuario.list()
        return [usuarios: usuarios]
    }

    def save_ajax() {
        def usuario = new Usuario()
        if (params.id) {
            usuario = Usuario.get(params.id)
        }
        usuario.user = params.user
        usuario.pass = "123".encodeAsMD5()
        if (usuario.save(flush: true)) {
            render "SUCCESS*Usuario creado, por favor cambie su contraseña."
        } else {
            render "ERROR*" + renderErrors(bean: usuario)
        }
    }
}
