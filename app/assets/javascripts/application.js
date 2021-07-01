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
//= require jquery3
//= require moment
//= require bootstrap
//= require simplemde.min
//= require ckeditor/init
//= require ckeditor/config
//= require jstree.min
//= require_tree .

// Call the dataTables jQuery plugin
$(document).ready(function() {
  var simplemde = new SimpleMDE({ element: document.getElementById("markdown"), tabSize: 1 });
  $('.date-picker').change(function(){
  });
  if ($('textarea').length > 0) {
    CKEDITOR.config.height = 500;
    var data = $('.ckeditor');
    $.each(data, function(i) {
      CKEDITOR.replace(data[i].id)
    });
  }
  $('#dataTable').DataTable();
    /*!
      * Start Bootstrap - SB Admin v6.0.2 (https://startbootstrap.com/template/sb-admin)
      * Copyright 2013-2020 Start Bootstrap
      * Licensed under MIT (https://github.com/StartBootstrap/startbootstrap-sb-admin/blob/master/LICENSE)
      */
      (function($) {
      "use strict";

      // Add active state to sidbar nav links
      var path = window.location.href; // because the 'href' property of the DOM element is the absolute path
          $("#layoutSidenav_nav .sb-sidenav a.nav-link").each(function() {
              if (this.href === path) {
                  $(this).addClass("active");
              }
          });

      // Toggle the side navigation
      $("#sidebarToggle").on("click", function(e) {
          e.preventDefault();
          $("body").toggleClass("sb-sidenav-toggled");
      });
  })(jQuery);

});
