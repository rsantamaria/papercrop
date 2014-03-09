(function ($) {
  window.jcrop_api = null;

  window.init_papercrop = function() {
    $("div[id$=_cropbox]").each(function() {

      var attachment = $(this).attr("id").replace("_cropbox", "");
      var preview    = !!$("#" + attachment + "_crop_preview").length;
      var width      = $(this).width();
      var opts       = $(this).data();
      var aspect     = opts.aspectRatio;

      var original_width  = $("input[id$='_" + attachment + "_original_w']").val();
      var original_height = $("input[id$='_" + attachment + "_original_h']").val();
      var preview_width   = $("#" + attachment + "_crop_preview_wrapper").width();

      var update_crop = function(coords) {
        var rx, ry;

        if (preview && aspect) {
          rx = preview_width / coords.w;
          ry = preview_width / coords.h;

          $("img#" + attachment + "_crop_preview").css({
            width      : Math.round(rx * original_width) + "px",
            height     : Math.round((ry * original_height) / aspect) + "px",
            marginLeft : "-" + Math.round(rx * coords.x) + "px",
            marginTop  : "-" + Math.round((ry * coords.y) / aspect) + "px"
          });
        }

        $("#" + attachment + "_crop_x").val(Math.round(coords.x));
        $("#" + attachment + "_crop_y").val(Math.round(coords.y));
        $("#" + attachment + "_crop_w").val(Math.round(coords.w));
        $("#" + attachment + "_crop_h").val(Math.round(coords.h));
      };

      callbacks = {
        onChange : update_crop,
        onSelect : update_crop
      }

      $(this).find("img").Jcrop($.extend(opts, callbacks), function() {
        jcrop_api = this;
      });
    });
  };

  $(document).ready(function() {
    init_papercrop();
  });

}(jQuery));
