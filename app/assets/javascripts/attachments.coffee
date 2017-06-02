# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

delete_attachments = ->
  $(document).on 'click', '.delete-attachment-link', (e) ->
    e.preventDefault();

    attachment_id = $(this).data('attachmentId')

    $.ajax
      type: "DELETE"
      url: "/attachments/" + attachment_id
      data:
        id: attachment_id
      success: ->
        $('li#attachment_'+attachment_id).remove();
      error: ->
        $('div.errors').html('Something is wrong.')

$(document).on('turbolinks:load', delete_attachments)
$(document).on('page:load', delete_attachments)
$(document).on('page:update', delete_attachments)
