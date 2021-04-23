jQuery(function(){
	var $ = jQuery.noConflict();	
		
	var mobileNav = $('#mobile-nav-overlay');
	$(document)
		.on('click','.toggle-icon', function(){
			if( mobileNav.hasClass('hide') ) {
				mobileNav.removeClass('hide');
				mobileNav.addClass('active');
			} else {
				mobileNav.removeClass('active');
				mobileNav.addClass('hide');
			}
		})
		.on('click', '#mobile-nav-overlay', function(){
			$('#mobile-nav-overlay').addClass('hide' );
		})
		.on('click','#about-cassandra img, #blog-post img',function(){
			$(this).clone().appendTo('#mod-content');
			$('#fade,#modal,#close-modal').fadeIn();
			$('body,html').addClass('no-scroll');
		})
		.on('click','#close-modal,#fade',function(){
			$('#fade,#modal,#close-modal').fadeOut();
			$('body,html').removeClass('no-scroll');
			$('#mod-content').html('');
		})
		.on('click','.accordion-header',function(){
			var el = $(this);
			el.toggleClass('active');
			el.next().slideToggle();
		});
});
			