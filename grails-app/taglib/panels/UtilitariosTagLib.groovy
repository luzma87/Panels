package panels

class UtilitariosTagLib {
//    static defaultEncodeAs = [taglib: 'html']
    //static encodeAsForTags = [tagName: [taglib:'html'], otherTagName: [taglib:'none']]

    static namespace = "util"

    def renderHTML = { attrs ->
        out << attrs.html
    }
}