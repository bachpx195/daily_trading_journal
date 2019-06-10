CKEDITOR.editorConfig = function( config )
{
    // Define changes to default configuration here. For example:
    // config.language = "fr";
    // config.uiColor = "#AADC6E";

    /* Filebrowser routes */
    // The location of an external file browser, that should be launched when "Browse Server" button is pressed.
    config.filebrowserBrowseUrl = "/ckeditor/attachment_files";

    // The location of an external file browser, that should be launched when "Browse Server" button is pressed in the Flash dialog.
    config.filebrowserFlashBrowseUrl = "/ckeditor/attachment_files";

    // The location of a script that handles file uploads in the Flash dialog.
    config.filebrowserFlashUploadUrl = "/ckeditor/attachment_files";

    // The location of an external file browser, that should be launched when "Browse Server" button is pressed in the Link tab of Image dialog.
    config.filebrowserImageBrowseLinkUrl = "/ckeditor/pictures";

    // The location of an external file browser, that should be launched when "Browse Server" button is pressed in the Image dialog.
    config.filebrowserImageBrowseUrl = "/ckeditor/pictures";

    // The location of a script that handles file uploads in the Image dialog.
    config.filebrowserImageUploadUrl = "/ckeditor/pictures";

    // The location of a script that handles file uploads.
    config.filebrowserUploadUrl = "/ckeditor/attachment_files";

    config.allowedContent = true;

    // Toolbar groups configuration.
    config.toolbar = [
        { name: 'document', items: [ 'Source', "Bold", "Italic"] },
        { name: "links", items: [ "Link", "Unlink", "Anchor" ] },
        { name: "insert", items: [ "Image", "Html5video", "Table", "HorizontalRule", "SpecialChar" ] },
        { name: "paragraph", groups: [ "list", "indent", "blocks", "align", "bidi" ], items: [ "NumberedList", "BulletedList", "-", "Outdent", "Indent", "-", "Blockquote", "CreateDiv", "-", ] },
        "/"
    ];

    config.toolbar_mini = [
        { name: "styles", items: [ "Font", "FontSize" ] },
        { name: "colors", items: [ "TextColor", "BGColor" ] },
        { name: "basicstyles", groups: [ "basicstyles", "cleanup" ], items: [ "Bold", "Italic", "Underline", "Strike", "Subscript", "Superscript", "-", "RemoveFormat" ] },
        { name: "insert", items: [ "Image", "Table", "HorizontalRule", "SpecialChar" ] }
    ];
};

CKEDITOR.config.image_previewText = "Image Preview";

CKEDITOR.on( "dialogDefinition", function(ev){
    var dialogName = ev.data.name;
    var dialogDefinition = ev.data.definition;

    if (dialogName == "link")
    {
        dialogDefinition.removeContents("advanced");
        dialogDefinition.removeContents("target");
    }

    if (dialogName == "image")
    {
        dialogDefinition.removeContents("advanced");
        dialogDefinition.removeContents("Link");
        dialogDefinition.removeContents("Upload");
        // dialogDefinition.height = 800;
        // dialogDefinition.width = 1700;
    }
    if (dialogName == "flash")
    {
        dialogDefinition.removeContents("advanced");
    }
    var infoTab = dialogDefinition.getContents("info");
    //infoTab.remove("txtAlt");
    //infoTab.remove("cmbAlign");
    //infoTab.remove( "previewImage");
    infoTab.remove( "txtBorder" ); //Remove Element Border From Tab Info
    infoTab.remove( "txtHSpace" ); //Remove Element Horizontal Space From Tab Info
    infoTab.remove( "txtVSpace" ); //Remove Element Vertical Space From Tab Info
    infoTab.remove( "txtWidth" ); //Remove Element Width From Tab Info
    infoTab.remove( "txtHSpace");
    infoTab.remove( "txtVSpace");
});