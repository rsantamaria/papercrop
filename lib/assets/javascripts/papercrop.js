(function ($) {
  window.jcrop_api = null;

  window.init_papercrop = function() {
    $("div[id$=_cropbox]").each(function() {

      var attachment = $(this).attr("id").replace("_cropbox", "");
      var preview    = !!$("#" + attachment + "_crop_preview").length;
      var aspect     = $("input#" + attachment + "_aspect").val();
      var width      = $(this).width();
      var min_size   = $("input#" + attachment + "_min_size").val().split('x');
      var max_size   = $("input#" + attachment + "_max_size").val().split('x');
      var original_w = $("input[id$='_" + attachment + "_original_w']").val();
      var original_h = $("input[id$='_" + attachment + "_original_h']").val();

      update_crop = function(coords) {
        var preview_width, rx, ry;

        if (preview) {
          preview_width = $("#" + attachment + "_crop_preview_wrapper").width();

          rx = preview_width / coords.w;
          ry = preview_width / coords.h;

          $("img#" + attachment + "_crop_preview").css({
            width      : Math.round(rx * original_w) + "px",
            height     : Math.round((ry * original_h) / aspect) + "px",
            marginLeft : "-" + Math.round(rx * coords.x) + "px",
            marginTop  : "-" + Math.round((ry * coords.y) / aspect) + "px"
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
        setSelect   : [0, 0, original_w, 250],
        aspectRatio : aspect,
        minSize     : min_size,
        maxSize     : max_size,
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
