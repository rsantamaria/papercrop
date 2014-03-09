(function ($) {
  window.jcrop_api = null;

  window.init_papercrop = function() {
    $("div[id$=_cropbox]").each(function() {

      var attachment = $(this).attr("id").replace("_cropbox", "");
      var preview    = !!$("#" + attachment + "_crop_preview").length;
      var opts       = $(this).data();
      var aspect     = opts.aspectRatio;

      var original_width  = $("input[id$='_" + attachment + "_original_w']").val();
      var original_height = $("input[id$='_" + attachment + "_original_h']").val();
      var preview_width   = $("#" + attachment + "_crop_preview_wrapper").width();

      var crop_x_input = $("#" + attachment + "_crop_x");
      var crop_y_input = $("#" + attachment + "_crop_y");
      var crop_w_input = $("#" + attachment + "_crop_w");
      var crop_h_input = $("#" + attachment + "_crop_h");

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

        crop_x_input.val(Math.round(coords.x));
        crop_y_input.val(Math.round(coords.y));
        crop_w_input.val(Math.round(coords.w));
        crop_h_input.val(Math.round(coords.h));
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
