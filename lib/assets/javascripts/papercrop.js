var jcrop_api;

var init_papercrop = function() {
  $(document).ready(function() {
    $('div[id$=_cropbox]').each(function() {
      var aspect, attachment, preview, update_crop;

      attachment = $(this).attr('id').replace('_cropbox', '');
      preview    = !!$("#" + attachment + "_crop_preview").length;
      aspect     = $("input#" + attachment + "_aspect").val();
      
      update_crop = function(coords) {
        var preview_width, rx, ry;

        if (preview) {
          preview_width = $("#" + attachment + "_crop_preview_wrapper").width();
          rx            = preview_width / coords.w;
          ry            = preview_width / coords.h;
          
          $("img#" + attachment + "_crop_preview").css({
            width      : Math.round(rx * $("input[id$='_" + attachment + "_original_w']").val()) + "px",
            height     : Math.round((ry * $("input[id$='_" + attachment + "_original_h']").val()) / aspect) + "px",
            marginLeft : "-" + Math.round(rx * coords.x) + "px",
            marginTop  : "-" + Math.round((ry * coords.y) / aspect) + "px"
          });
        }

        $("#" + attachment + "_crop_x").val(Math.round(coords.x));
        $("#" + attachment + "_crop_y").val(Math.round(coords.y));
        $("#" + attachment + "_crop_w").val(Math.round(coords.w));
        $("#" + attachment + "_crop_h").val(Math.round(coords.h));
      };

      $(this).find('img').Jcrop({
        onChange    : update_crop,
        onSelect    : update_crop,
        setSelect   : [0, 0, 500, 500],
        aspectRatio : aspect,
        boxWidth    : $("input[id$='_" + attachment + "_box_w']").val()
      }, function(){ jcrop_api = this; });
    });
  });
}

$(document).ready(function() {
  init_papercrop();
});