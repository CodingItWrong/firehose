$(function() {
  $('[data-action="mark_read"], [data-action="mark_unread"], [data-action="delete"]').on('ajax:success', function(event) {
    var linkContainer = $(this).closest('[data-role="link_container"]');
    linkContainer.slideUp();
  });
});
