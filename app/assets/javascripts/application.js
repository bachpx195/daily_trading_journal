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
//= require bootstrap
//= require ckeditor/init
//= require ckeditor/config
//= require dataTables/jquery.dataTables
//= require_tree .

$(document).on('turbolinks:load', function() {
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