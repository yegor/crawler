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
      $(this).autocomplete({source: $(this).data("autocomplete-url")});
    });
    
    $("input.search-query").bind("autocompletesearch", function(e, ui) {
      $(this).removeAttr("data-value");
    });
    
    $("input.search-query").bind("autocompleteselect", function(e, ui) {
      $(this).attr("data-value", ui.item.value);
      $(this).val(ui.item.label);
      $(this).trigger("search-query:changed");

      return false;
    });
    
    $("input.search-query").bind("blur", function() {
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
  
  $.fn.uberFormData = function() {
    var data = {};
    
    $.each($(this).children("*[data-name]"), function() {
      data[ $(this).attr("data-name") ] = $(this).attr("data-value");
    });
    
    return data;
  }
  
  $(".dropdown-menu li a").live("click", function(e) {
    var dropdown = $(this).parents(".dropdown");
    
    if (dropdown.hasClass("multiple-options")) {
      
      if (e.target.tagName != "INPUT") {
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
  
  $.fn.historicalChart = function(params) {
    $.getScript(window.historical_url + "?" + $.param(params));
	}
	
	$.fn.currentFeaturings = function(params) {
    $.getScript(window.featurings_url + "?" + $.param(params));
	}
  
  /**************************************************************************************************************
  
                                                  UI handler functions
  
  ***************************************************************************************************************/ 
  
  var updateFeaturings = function() {
    $(".featurings #current-featurings").currentFeaturings($(".featurings-filter").uberFormData());
  }
  
  var filterFeaturings = function() {
    var itunesId = $(this).data("value");
    
    $(".country-featuring .accordion .accordion-body").removeClass("in");
    $(".country-featuring .accordion .accordion-body:first").addClass("in");
    $(".country-featuring .accordion .featuring-type").show();
    $(".country-featuring .app-pill").css({"display": "inline-block"});
    
    if (itunesId + 0 != 0) {
      $(".country-featuring .app-pill").css({"display": "none"});
      $(".country-featuring .app-pill-" + itunesId).css({"display": "inline-block"});
      
      $(".country-featuring .accordion .featuring-type").hide();
      $(".country-featuring .accordion .featuring-type").has("app-pill-" + itunesId).show();
      $(".country-featuring .accordion .accordion-body").has("app-pill-" + itunesId).addClass("in").css("height", "");
    }
  }
  
  $(".featurings-filter .dropdown-menu li a").live("click", updateFeaturings);
  $(".featurings-filter .date-select").live("date-picker:changed", updateFeaturings);
  $(".featurings-filter .search-query").live("search-query:changed", filterFeaturings);
  $(".featurings-filter .search-query").live("search-query:cleared", filterFeaturings);
  
  // ************************************************************************************************************
  
  var updateHistoricalChart = function() {
    $(".historical-graph-chart #fusion-chart").historicalChart($(".historical-graph-filter").uberFormData());
  }
  
  $(".historical-graph-filter .dropdown-menu li a").live("click", updateHistoricalChart);
  $(".historical-graph-filter .date-select").live("date-picker:changed", updateHistoricalChart);
  $(".historical-graph-filter input.search-query").live("search-query:changed", updateHistoricalChart);
  
  // ************************************************************************************************************
  
  var updateCharts = function() {
    var data = $(this).parents(".chart-config").uberFormData();
	  var chartContainer = $(this).parents(".subnav");
	  
	  chartContainer.html(window.loading_span);
	  
	  $.ajax({
	    "url": window.show_chart_url + ".js", 
	    "data": data, 
	    "success": function(html) {
	      chartContainer.html(html);
      },
      "type": "get",
      "dataType": "html"
	  });
  }
  
	$(".chart-config .dropdown-menu li a").live("click", updateCharts);
	
	$.setupUI();
	
});
