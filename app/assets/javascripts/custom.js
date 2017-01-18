// Overrides and adds customized javascripts in this file
// Read more on documentation: 
// * English: https://github.com/consul/consul/blob/master/CUSTOMIZE_EN.md#javascript
// * Spanish: https://github.com/consul/consul/blob/master/CUSTOMIZE_ES.md#javascript
//
//
//= require custom_management_utils

var initialize_custom_components = function() {

    $('.tabs').on('toggled', function (event, tab) {
        console.log(tab);
    });

    App.CustomManangementUtils.initialize();
}

$(function(){

    $(document).ready(initialize_custom_components);
    $(document).on('page:load', initialize_custom_components);
    $(document).on('ajax:complete', initialize_custom_components);
});
