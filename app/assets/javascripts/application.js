// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require FusionCharts
//= require bootstrap.js
//= require bootstrap-tab.js

$(function() {
  
  $.setupUI = function() {
    $(".historical-graph-filter input.search-query").autocomplete({source: window.game_autocomplete_url});
    
    $(".historical-graph-filter input.search-query").bind("autocompletesearch", function(e, ui) {
      $(this).removeAttr("data-value");
    });
    
    $(".historical-graph-filter input.search-query").bind("autocompleteselect", function(e, ui) {
      $(this).attr("data-value", ui.item.value);
      $(this).val(ui.item.label);

      $(".historical-graph-chart #fusion-chart").historicalChart($(this).parents(".historical-graph-filter").uberFormData());

      return false;
    });
    
    $('.automagic-tabs li:not(.dropdown) a').attr('data-toggle', 'tab');
    $('.automagic-tabs li:first a').tab('show');
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
  
  $(".dropdown-menu li a").live("click", function() {
    $(this).parents(".dropdown").attr("data-value", $(this).attr("data-value"));
  })
  
  $.fn.historicalChart = function(params) {
    $.getScript(window.historical_url + "?" + $.param(params));
	}
  
  /**************************************************************************************************************
  
                                                  UI handler functions
  
  ***************************************************************************************************************/ 
  
  $(".historical-graph-filter .dropdown-menu li a").live("click", function() {
    $(".historical-graph-chart #fusion-chart").historicalChart($(".historical-graph-filter").uberFormData());
  })
  
	$(".chart-config .dropdown-menu li a").live("click", function() {
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
	});
	
	$.setupUI();
	
});
