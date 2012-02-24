// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui.min
//= require FusionCharts
//= require bootstrap.js
//= require bootstrap-tab.js

$(function() {
  
  $.setupUI = function() {
    $("input.search-query[data-autocomplete-url]").each(function() {
      $(this).autocomplete({source: $(this).attr("data-autocomplete-url")});
    });
    
    $("input.search-query").bind("autocompletesearch", function(e, ui) {
      $(this).removeAttr("data-value");
    });
    
    $("input.search-query").bind("autocompleteopen", function(e, ui) {
      $("ul.ui-autocomplete").css("margin-top", "3px");
    });
    
    $( "input.search-query" ).bind( "autocompletefocus", function(event, ui) {
      $(this).val(ui.item.label);
      // alert(ui.item.label);
      
      return false;
    });
    
    $("input.search-query").bind("autocompleteselect", function(e, ui) {
      $(this).attr("data-value", ui.item.value);
      $(this).val(ui.item.label);
      $(this).trigger("search-query:changed");

      return false;
    });
    
    $("input.search-query").bind("change", function() {
      if ($(this).val() == "") {
        $(this).attr("data-value", 0);
        $(this).trigger("search-query:cleared");
      }
    });
    
    $('.automagic-tabs li').removeClass('active');
    $('.automagic-tabs li:not(.dropdown) a').attr('data-toggle', 'tab');
    $('.automagic-tabs li:first a').tab('show');
    
    $('.date-select input').datepicker({
      "dateFormat": "yy-mm-dd",
      
      onClose: function(dateText, inst) {
         $(this).parents(".date-select").attr("data-value", dateText);
         $(this).parents(".date-select").trigger("date-picker:changed");
       }
    });
  }
  
  /**************************************************************************************************************
  
                                                  Common functions
  
  ***************************************************************************************************************/
  
  $.fn.identify = function() {
    $.fn.__identify_id_counter = $.fn.__identify_id_counter || 0;
    if (!$(this).attr("id")) {
      $(this).attr("id", "id-" + $.fn.__identify_id_counter++)
    }
    
    return $(this).attr("id");
  }
  
  $.fn.uberFormData = function() {
    var data = {"uberform_container_id": $(this).identify()};
    
    $(this).find("*[data-name]").each(function() {
      data[ $(this).attr("data-name") ] = $(this).attr("data-value");
    });
    
    return data;
  }
  
  $(".dropdown-menu li a input").live("click", function(e) {
    var checkbox = $(this).find("input");
    
    $(this).parents("a").click();
    
    return false;
  });
  
  $(".dropdown-menu li a").live("click", function(e) {
    var dropdown = $(this).parents(".dropdown");
    
    if (dropdown.hasClass("multiple-options")) {
      
      if (e.target.tagName == "A") {
        var checkbox = $(this).find("input");
      
        if (checkbox.attr("checked")) {
          checkbox.removeAttr("checked");
        } else {
          checkbox.attr("checked", "");
        }
      }
      
      var currentOptions = [];
      $.each(dropdown.find("input[checked]"), function(i) {
        currentOptions.push( $(this).val() );
      });
      
      dropdown.attr("data-value", currentOptions);
    } else {
      dropdown.attr("data-value", $(this).attr("data-value"));
    }
  })
  
  $.fn.uberForm = function() {
    var form = $(this).parents("[data-uberform-url]");
    $.getScript(form.data("uberform-url") + "?" + $.param( form.uberFormData() ));
  }
  
  /**************************************************************************************************************
  
                                                  UI handler functions
  
  ***************************************************************************************************************/ 
  
  var filterFeaturings = function() {
    var itunesId = $(this).attr("data-value");
    
    $(".country-featuring .accordion .accordion-body").removeClass("in");
    $(".country-featuring .accordion .accordion-body:first").addClass("in");
    $(".country-featuring .accordion .featuring-type").show();
    $(".country-featuring .app-pill").css({"display": "inline-block"});
    
    if (parseInt(itunesId + '') > 0) {
      $(".country-featuring .app-pill").css({"display": "none"});
      $(".country-featuring .app-pill-" + itunesId).css({"display": "inline-block"});
      
      $(".country-featuring .accordion .accordion-body .featuring-type").hide();
      $(".country-featuring .accordion .accordion-body .featuring-type").has(".app-pill-" + itunesId).show();
      $(".country-featuring .accordion .accordion-body").has(".app-pill-" + itunesId).addClass("in").css("height", "");
    }
  }
  
  $(".featurings-filter .dropdown-menu li a").live("click",          $.fn.uberForm);
  $(".featurings-filter .date-select").live("date-picker:changed",   $.fn.uberForm);
  $(".featurings-filter .search-query").live("search-query:changed", filterFeaturings);
  $(".featurings-filter .search-query").live("search-query:cleared", filterFeaturings);
  
  // ************************************************************************************************************
  
  $(".historical-graph-filter .dropdown-menu li a").live("click",               $.fn.uberForm);
  $(".historical-graph-filter .date-select").live("date-picker:changed",        $.fn.uberForm);
  $(".historical-graph-filter input.search-query").live("search-query:changed", $.fn.uberForm);
  
  // ************************************************************************************************************
  
	$(".chart-config .dropdown-menu li a").live("click", $.fn.uberForm);
	
	$.setupUI();
	
});
