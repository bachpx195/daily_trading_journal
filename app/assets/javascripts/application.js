// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require jquery3
//= require jquery-ui
//= require jquery_ujs
//= require jquery.ui.nestedSortable
//= require sortable_tree/initializer
//= require moment
//= require bootstrap
//= require simplemde.min
//= require ckeditor/init
//= require ckeditor/config
//= require_tree .

$(document).ready(function() {
  var simplemde = new SimpleMDE({ element: document.getElementById("markdown"), tabSize: 1 });
});

$(document).on('turbolinks:load', function() {
  TheSortableTree.SortableUI.init();
  $('.date-picker').change(function(){
  });
  if (jQuery().datepicker) {
    $('.date-picker').datepicker({
      rtl: App.isRTL(),
      orientation: "left",
      autoclose: true
    });
  }
});

$(document).ready(function(){
  if ($('textarea').length > 0) {
  	CKEDITOR.config.height = 500;
    var data = $('.ckeditor');
    $.each(data, function(i) {
      CKEDITOR.replace(data[i].id)
    });
  }
});

$(document).ready(function($) {
  //Download Link Highlight
  if($("body").data("page")==="frontpage"){
    $(window).scroll(function(){
      var scrolled = $(window).scrollTop();
      var downloadLink = $("#top-nav").find(".download")
      if(scrolled >= 420){
        downloadLink.addClass("download-on");
      } else if (scrolled < 420){
        downloadLink.removeClass("download-on");
      }
    })
  }

  $('#myTab a').click(function (e) {
    e.preventDefault();
    $(this).tab('show');
  })
});
