(function ($) {
  window.jcrop_api = null;

  window.init_papercrop = function() {
    $("div[id$=_cropbox]").each(function() {

      var attachment = $(this).attr("id").replace("_cropbox", "");
      var preview    = !!$("#" + attachment + "_crop_preview").length;
      var aspect     = $("input#" + attachment + "_aspect").val();
      var width      = $(this).width();
      var original_w = $("input[id$='_" + attachment + "_original_w']").val();
      var original_h = $("input[id$='_" + attachment + "_original_h']").val();
      var preview_w  = $("#" + attachment + "_crop_preview_wrapper").width();
      var preview_h  = $("#" + attachment + "_crop_preview_wrapper").height();

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

        $("#" + attachment + "_crop_x").val(Math.round(coords.x));
        $("#" + attachment + "_crop_y").val(Math.round(coords.y));
        $("#" + attachment + "_crop_w").val(Math.round(coords.w));
        $("#" + attachment + "_crop_h").val(Math.round(coords.h));
      };

      $(this).find("img").Jcrop({
        onChange    : update_crop,
        onSelect    : update_crop,
        setSelect   : [0, 0, 250, 250],
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
