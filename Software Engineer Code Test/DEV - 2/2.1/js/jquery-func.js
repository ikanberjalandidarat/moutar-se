function mycarousel_initCallback(carousel) {
	    $('.slider-navigation a').bind('click', function() {
	        carousel.scroll($.jcarousel.intval($(this).text()));
	        return false;
	    });	        
};
	
function mycarousel_itemFirstInCallback(carousel, item, idx, state) {
	$('.slider-navigation a').removeClass('active');
	$('.slider-navigation a').eq(idx-1).addClass('active');
};

// Carousel
$(document).ready (function(){
	
	$(".slider-carousel ul").jcarousel({
		scroll:1,
		auto:4,
		wrap:"both",
        itemFirstInCallback: mycarousel_itemFirstInCallback,
        initCallback: mycarousel_initCallback,
        start: 1,
        // This tells jCarousel NOT to autobuild prev/next buttons
        buttonNextHTML: null,
        buttonPrevHTML: null
		
	});
	
});


// DropDown Menu
$(document).ready(function(){ 
		
	$('#navigation ul li').hover(function(){ 
		
		$(this).find('.dd:eq(0)').show();
		$(this).find('a:eq(0)').addClass('hover');
	 },
	 function(){  
		$(this).find('.dd').hide();
		$(this).find('a:eq(0)').removeClass('hover');
		
 	});

	$('#navigation ul li').hover(function(){
		
	if ($(this).find('.has-dd-hover').length){
	$(this).addClass('dd-hover');
	$(this).find('a').removeClass('active');
	}
	
	
	},
	function(){
		$(this).removeClass('dd-hover');
		$(this).find('a.has-dd-hover').addClass('active');
	 }
	);

});