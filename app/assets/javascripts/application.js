// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require FusionCharts
//= require jquery.autocomplete.min

$(function() {
  $("form .game-names input").autocomplete(window.game_autocomplete_game_url);

	$("form .game-names p a.plus").live("click", function() {
		var newField = $(this).parents("p").clone();
		newField.children("input").val("");
		newField.autocomplete(window.game_autocomplete_game_url);
		
		$(this).parents(".game-names").append( newField );
	});
	
	$("form .game-names p a.minus").live("click", function() {
		$(this).parents("p").remove();
	});
});
