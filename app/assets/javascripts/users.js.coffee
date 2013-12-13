jQuery ->
  # Show detail information about connection in users#show
  $('.show_detail_button').click ->
    $(this).parent().parent().children('.connection_detail').slideToggle()