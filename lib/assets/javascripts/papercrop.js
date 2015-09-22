(function ($) {
  window.jcrop_api = null;

  window.init_papercrop = function() {
    $("div[id$=_cropbox]").each(function() {

      var attachment = $(this).attr("id").replace("_cropbox", "");
      var preview    = !!$("#" + attachment + "_crop_preview").length;
      var aspect     = $("input#" + attachment + "_aspect").val();
      var original_w = $("input[id$='_" + attachment + "_original_w']").val();
      var original_h = $("input[id$='_" + attachment + "_original_h']").val();
      var preview_w  = $("#" + attachment + "_crop_preview_wrapper").width();
      var preview_h  = $("#" + attachment + "_crop_preview_wrapper").height();

      var crop_x_input = $("#" + attachment + "_crop_x");
      var crop_y_input = $("#" + attachment + "_crop_y");
      var crop_w_input = $("#" + attachment + "_crop_w");
      var crop_h_input = $("#" + attachment + "_crop_h");

      var update_crop = function(coords) {
        var rx, ry;

        if (preview) {
          rx = preview_w / coords.w;
          ry = preview_h / coords.h;

          $("img#" + attachment + "_crop_preview").css({
            width      : Math.round(rx * original_w) + "px",
            height     : Math.round(ry * original_h) + "px",
            marginLeft : "-" + Math.round(rx * coords.x) + "px",
            marginTop  : "-" + Math.round(ry * coords.y) + "px"
          });
        }

        crop_x_input.val(Math.round(coords.x));
        crop_y_input.val(Math.round(coords.y));
        crop_w_input.val(Math.round(coords.w));
        crop_h_input.val(Math.round(coords.h));
      };

      // Find the starting select box: as big as possible following the aspect
      // ratio, and centered in the image
      var select, maxWidth, maxHeight;
      if (original_w / original_h > aspect) {
        // Height is the constraining dimension
        maxWidth = original_h * aspect;
        select = [(original_w - maxWidth) / 2, 0, maxWidth, original_h];
      } else {
        // Width is the constraining demension
        maxHeight = original_w / aspect;
        select = [0, (original_h - maxHeight) / 2, original_w, maxHeight];
      }

      $(this).find("img").Jcrop({
        onChange    : update_crop,
        onSelect    : update_crop,
        setSelect   : select,
        aspectRatio : aspect,
        boxWidth    : $("input[id$='_" + attachment + "_box_w']").val()
      }, function() {
        jcrop_api = this;
      });
    });
  };

  $(document).ready(function() {
    init_papercrop();
  });

}(jQuery));
