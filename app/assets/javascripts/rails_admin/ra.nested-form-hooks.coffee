$ = jQuery

$(document).ready ->
  window.nestedFormEvents.insertFields = (content, assoc, link) ->
    tab_content = $(link).closest(".controls").siblings(".tab-content")
    tab_content.append content
    tab_content.children().last()

$(document).on 'nested:fieldAdded', 'form', (content) ->
  field = content.field.addClass('tab-pane').attr('id', 'unique-id-' + (new Date().getTime()))
  new_tab = $('<li><a data-toggle="tab" href="#' + field.attr('id') + '">' + field.children('.object-infos').data('object-label') + '</a></li>')
  parent_group = field.closest('.control-group')
  controls = parent_group.children('.controls')
  nav = controls.children('.nav')
  content = parent_group.children('.tab-content')
  toggler = controls.find('.toggler')
  nav.append(new_tab)

  # fix for option tree
  temp_classes = parent_group.attr('class').trim().split(" ")
  if temp_classes[temp_classes.length - 1] == "option_tree_level2s_field"
    correct_id = parent_group.attr('id').match(/[0-9]+/g)[3]
    splitter = "option_tree_level1s_attributes]["

    temp_name = field.children().first().attr('name')
    first_part = temp_name.split(splitter)[0]
    last_part = temp_name.split(splitter)[1]
    correct_name = first_part + splitter + correct_id + last_part.substring(1, last_part.length)
    field.children().first().attr('name', correct_name)

    textarea_field = field.children().last().find('.value_field').find('textarea')
    first_part = textarea_field.attr('name').split(splitter)[0]
    last_part = textarea_field.attr('name').split(splitter)[1]
    correct_name = first_part + splitter + correct_id + last_part.substring(1, last_part.length)
    textarea_field.attr('name', correct_name)

    photo_field = $(field.children().last().find('.photo_field').find('input')[0])
    first_part = photo_field.attr('name').split(splitter)[0]
    last_part = photo_field.attr('name').split(splitter)[1]
    correct_name = first_part + splitter + correct_id + last_part.substring(1, last_part.length)
    photo_field.attr('name', correct_name)

    photo_cached_field = $(field.children().last().find('.photo_field').find('input')[1])
    first_part = photo_cached_field.attr('name').split(splitter)[0]
    last_part = photo_cached_field.attr('name').split(splitter)[1]
    correct_name = first_part + splitter + correct_id + last_part.substring(1, last_part.length)
    photo_cached_field.attr('name', correct_name)
  # End fix for opttree

  $(window.document).trigger('rails_admin.dom_ready', [field, parent_group]) # fire dom_ready for new player in town
  new_tab.children('a').tab('show') # activate added tab
  nav.select(':hidden').show('slow') # show nav if hidden
  content.select(':hidden').show('slow') # show tabs content if hidden
  # toggler 'on' if inactive
  toggler.addClass('active').removeClass('disabled').children('i').addClass('icon-chevron-down').removeClass('icon-chevron-right')

$(document).on 'nested:fieldRemoved', 'form', (content) ->
  field = content.field
  nav = field.closest(".control-group").children('.controls').children('.nav')
  current_li = nav.children('li').has('a[href=#' + field.attr('id') + ']')
  parent_group = field.closest(".control-group")
  controls = parent_group.children('.controls')
  toggler = controls.find('.toggler')

  # try to activate another tab
  (if current_li.next().length then current_li.next() else current_li.prev()).children('a:first').tab('show')

  current_li.remove()

  if nav.children().length == 0 # removed last tab
    nav.select(':visible').hide('slow') # hide nav. No use anymore.
    # toggler 'off' if active
    toggler.removeClass('active').addClass('disabled').children('i').removeClass('icon-chevron-down').addClass('icon-chevron-right')
