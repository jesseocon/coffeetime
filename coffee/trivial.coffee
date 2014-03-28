class TextToScreenApp 
    constructor: (options) -> 
        options = options || {}
        defaults =
            base_url: '/displays'
            broken_image_src: ''
            campaign_id: '55555'
            image_page_no: 1
            image_target: '#target'
            instagram_image_src: ''
            jsonp_url: 'http://localhost:3000/displays'
            logo_image_target: ''
            max_message_length: 35
            message_end_string: '...'
            message_page_no: 1
            message_text_target: '#target'
            mo_interval: 10000
            phone_image_src: ''
            twitter_image_src: ''


        $.extend defaults, options
        this.base_url = defaults.base_url
        this.campaign_id = defaults.campaign_id
        this.image_page_no = defaults.image_page_no
        this.image_target = defaults.image_target
        this.jsonp_url = defaults.jsonp_url
        this.max_message_length = defaults.max_message_length
        this.message_page_no = defaults.message_page_no
        this.message_text_target = defaults.message_text_target
        this.mo_interval = defaults.mo_interval
        this.default_carousel_options = 
            mo_interval: this.mo_interval
            message_text_target: this.message_text_target
            image_target: this.image_target

        if typeof defaults.carousel == 'undefined'
            this.carousel = new Carousel this.default_carousel_options
        else
            this.carousel = defaults.carousel

# It would be good to subclass Mo 
# Possibly with TextMo and ImageMo
# as the textMo would proabably not need a preload images in
# a text only Mo.
class Mo
    constructor: (obj) ->
        this.content_url = obj.content_url
        this.handle = obj.handle
        this.id = obj.id
        this.is_type = obj.is_type
        this.message = obj.message
        this.brk_src = 'http://www.catholictradition.org/Christ/merciful-jesus.jpg'
        this.image = null

    preload_image: (arr, brkn_src) => 
        newimages = []
        loadedimages = 0
        postaction = ->
        arr = if arr? then arr else this.brk_src
        arr = if typeof arr == 'object' then arr else [arr] 

        imageloadpost = -> 
            loadedimages++

            if loadedimages == arr.length
                postaction(newimages)

        newimages = for item in arr
            ni = new Image
            ni.src = item
            ni.onload = ->
                imageloadpost()

            ni.onerror = -> 
                this.src = brkn_src 

            ni.onabort = ->

            this.image = ni
            $(ni).on 'click', ->
                alert 'it worked'

            ni

        result =
            done: (f) -> 
                postaction = f || postaction()
        return result

class Rotator

class Carousel
    constructor: (options) ->
        options = options || {}
        this.image_target = options.image_target
        this.mo_interval = options.mo_interval
        this.message_text_target = options.message_text_target


        this.mos = []

    set_mos: (arr) =>
        tmp_arr = ( new Mo a for a in arr )
        Array::push.apply this.mos, tmp_arr

    rotate_mos: =>

        mos = this.mos
        it = this.image_target
        tt = this.message_text_target
        interval = this.mo_interval
        console.log "this is the interval: ", interval
        counter = 0
        $(it).html(mos[counter].image)
        $(tt).html(mos[counter].message)
        handle = setInterval -> 
            counter++

            if counter > mos.length
                clearInterval(handle)
            else
                $(it).html(mos[counter].image) 
                $(tt).html(mos[counter].message)
        , interval 



$ ->
    form = $('form#login')
    window.tts = ->

        options =
            image_target: '#picture-div'
            message_text_target: '#text-div'
            mo_interval: 10000 

        new TextToScreenApp options
    window.textToScreen = tts()

    parmas = 
        campaign_id: 23900

    form.submit (event) ->
        event.preventDefault()
        $.ajax
            url: 'http://localhost:3000/displays'
            type: 'GET'
            data: parmas
            crossDomain: true
        .done (data) -> 
            console.log 'awesome sauce! we are done!'
            window.textToScreen.carousel.set_mos data.mos 
            for mo in window.textToScreen.carousel.mos 
                mo.preload_image(mo.content_url, 'http://www.catholictradition.org/Christ/merciful-jesus.jpg').done (images) -> 

            window.textToScreen.carousel.rotate_mos()

