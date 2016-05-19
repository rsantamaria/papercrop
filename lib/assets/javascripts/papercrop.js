(function ($) {

  var win = window;

  win.jcrop_api = null;

  win.init_papercrop = function() {
    $("div[id$=_cropbox]").each(function() {

      var attachment = $(this).attr("id").replace("_cropbox", "");
        preview    = !!$("#" + attachment + "_crop_preview").length,
        aspect     = $("input#" + attachment + "_aspect").val(),
        ratio = 1.0,
        width      = $(this).width(),
        boxWidth = $("input[id$='_" + attachment + "_box_w']").val();

      if (boxWidth > width) {
        boxWidth = width;
        $("input[id$='_" + attachment + "_box_w']").val(boxWidth);
        ratio = $('input[id$="_' + attachment + '_original_w"]').val() / width;
      }

      var update_crop = function(coords) {

        var preview_width, rx, ry;

        if (preview) {
          preview_width = $("#" + attachment + "_crop_preview_wrapper").width();

          rx = preview_width / coords.w;
          ry = preview_width / coords.h;

          $("img#" + attachment + "_crop_preview").css({
            width      : Math.round(rx * $("input[id$='_" + attachment + "_original_w']").val()) + "px",
            height     : Math.round((ry * $("input[id$='_" + attachment + "_original_h']").val()) / aspect) + "px",
            marginLeft : "-" + Math.round(rx * coords.x * ratio) + "px",
            marginTop  : "-" + Math.round((ry * coords.y * ratio) / aspect) + "px"
          });
        }

        $("#" + attachment + "_crop_x").val(Math.round(coords.x * ratio));
        $("#" + attachment + "_crop_y").val(Math.round(coords.y * ratio));
        $("#" + attachment + "_crop_w").val(Math.round(coords.w * ratio));
        $("#" + attachment + "_crop_h").val(Math.round(coords.h * ratio));
      };

      $(this).find("img").Jcrop({
        onChange    : update_crop,
        onSelect    : update_crop,
        setSelect   : [0, 0, 250, 250],
        aspectRatio : aspect,
        boxWidth    : boxWidth
      }, function() {
        jcrop_api = this;
      });
    });
  };

  $(document).ready(init_papercrop);

}(jQuery));