CKEDITOR.editorConfig=function(e){e.language="vi",e.filebrowserBrowseUrl="/ckeditor/attachment_files",e.filebrowserFlashBrowseUrl="/ckeditor/attachment_files",e.filebrowserFlashUploadUrl="/ckeditor/attachment_files",e.filebrowserImageBrowseLinkUrl="/ckeditor/pictures",e.filebrowserImageBrowseUrl="/ckeditor/pictures",e.filebrowserImageUploadUrl="/ckeditor/pictures",e.filebrowserUploadUrl="/ckeditor/attachment_files",e.allowedContent=!0,e.toolbar=[{name:"document",items:["Source"]},{name:"clipboard",groups:["clipboard","undo"],items:["Cut","Copy","Paste","PasteText","PasteFromWord","-","Undo","Redo"]},{name:"links",items:["Link","Unlink","Anchor"]},{name:"insert",items:["Image","Html5video","Flash","Table","HorizontalRule","SpecialChar"]},{name:"paragraph",groups:["list","indent","blocks","align","bidi"],items:["NumberedList","BulletedList","-","Outdent","Indent","-","Blockquote","CreateDiv","-","JustifyLeft","JustifyCenter","JustifyRight","JustifyBlock"]},"/",{name:"styles",items:["Styles","Format","Font","FontSize"]},{name:"colors",items:["TextColor","BGColor"]},{name:"basicstyles",groups:["basicstyles","cleanup"],items:["Bold","Italic","Underline","Strike","Subscript","Superscript","-","RemoveFormat"]}],e.toolbar_mini=[{name:"paragraph",groups:["list","indent","blocks","align","bidi"],items:["NumberedList","BulletedList","-","Outdent","Indent","-","Blockquote","CreateDiv","-","JustifyLeft","JustifyCenter","JustifyRight","JustifyBlock"]},{name:"styles",items:["Font","FontSize"]},{name:"colors",items:["TextColor","BGColor"]},{name:"basicstyles",groups:["basicstyles","cleanup"],items:["Bold","Italic","Underline","Strike","Subscript","Superscript","-","RemoveFormat"]},{name:"insert",items:["Image","Table","HorizontalRule","SpecialChar"]}]},CKEDITOR.config.image_previewText="Image Preview",CKEDITOR.on("dialogDefinition",function(e){var t=e.data.name,i=e.data.definition;"link"==t&&(i.removeContents("advanced"),i.removeContents("target")),"image"==t&&(i.removeContents("advanced"),i.removeContents("Link"),i.removeContents("Upload")),"flash"==t&&i.removeContents("advanced");var o=i.getContents("info");o.remove("txtBorder"),o.remove("txtHSpace"),o.remove("txtVSpace"),o.remove("txtWidth"),o.remove("txtHSpace"),o.remove("txtVSpace")});