_ = require 'underscore'
Backbone = require 'backbone'

module.exports = class MerryGoRoundNavView extends Backbone.View
  tagName: 'nav'
  className: '.mgr-navigation'

  events:
    'click .js-mgr-next': 'next'
    'click .js-mgr-prev': 'prev'
    'click .js-mgr-select': 'select'

  initialize: ({ @flickity, @advanceBy = 1, @template }) ->
    @flickity.on 'cellSelect', @render
    @flickity.on 'cellSelect', @announce

    $(document).on 'keydown.mgr', @keypress

  keypress: (e) =>
    return if $(e.target).is(':input')
    switch e.keyCode
      when 37
        @prev e
      when 39
        @next e

  announce: =>
    if @isStart()
      @trigger 'start'
    else if @isEnd()
      @trigger 'end'

  isStart: ->
    @flickity.selectedIndex <= 0

  isEnd: ->
    @flickity.selectedIndex + @advanceBy >= @flickity.cells.length

  next: (e) ->
    return if !@flickity.options.wrapAround and @isEnd()
    e.preventDefault()
    if @advanceBy > 1
      @flickity.select @flickity.selectedIndex + @advanceBy
    else
      @flickity.next true

  prev: (e) ->
    return if !@flickity.options.wrapAround and @isStart()
    e.preventDefault()
    if @advanceBy > 1
      @flickity.select @flickity.selectedIndex - @advanceBy
    else
      @flickity.previous true

  select: (e) ->
    e.preventDefault()
    @flickity.select $(e.currentTarget).data('index')

  checkWidth: ->
    cells = this.flickity.cells
    lastMargin = parseInt $(cells[cells.length - 1].element).css('marginRight')
    breaksWidth = $(this.flickity.viewport).width() < this.flickity.slideableWidth - lastMargin
    @$el.addClass 'no-scroll' if not breaksWidth

  render: =>
    @$el.html @template
      length: @flickity.cells.length
      index: @flickity.selectedIndex
      disableStart: !@flickity.options.wrapAround && @isStart()
      disableEnd: !@flickity.options.wrapAround && @isEnd()
    _.defer => @checkWidth()
    this

  remove: ->
    $(document).off 'keydown.mgr'
    @flickity.destroy()
    super
