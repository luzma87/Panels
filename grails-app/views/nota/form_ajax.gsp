<div class="row alert alert-success">
    <div class="col-md-9">
        ${nota.titulo}
    </div>

    <div class="col-md-3 text-right">
        ${nota.usuario.user} (${nota.fecha.format("dd-MM-yyyy HH:mm")})
    </div>
</div>

<div class="row">
    <div class="col-md-12 alert alert-info">
        <g:each in="${nota.keywords.split(' ')}" var="key">
            <span class="label label-primary">${key}</span>
        </g:each>
    </div>
</div>

<div class="row">
    <div class="col-md-12" id="divEditor">
        <textarea cols="5" rows="5" name="editor" id="editor" class="ckeditor  form-control input-sm">${nota.contenido}</textarea>
    </div>
</div>


<script type="text/javascript">
    CKEDITOR.appendTo("divEditor");
    //        CKEDITOR.replace('editor');
    //    $(function () {
    //        $("#editor").ckeditor();
    //    });
</script>