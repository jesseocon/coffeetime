$ ->
    form = $('form#login')
    
    form.submit (event) ->
        data = {}
        data[input.name] = input.value for input in form.serializeArray()

        if data.password.length < 6
            invalid_reason = "Password is too short!"
        if not /\d/.test(data.password)
            invalid_reason = "Password must contain a number!"
        if not /\w/.test(data.password)
            invalid_reason = "Password must contain a letter!"

        if invalid_reason?
            event.preventDefault()
            alert invalid_reason
