$ ->
    ws = new WebSocket 'ws://' + window.location.host + window.location.pathname

    ws.onmessage = (evt) ->
        data = JSON.parse evt.data

        $('#tableBody').append(
            $('<tr>').append(
                $('<td>').text data.user_id
            ).append(
                $('<td>').text data.message
            )
        )

    ws.onclose = ->
        console.log "WebSocket connection closed."

    ws.onopen = ->
        console.log "WebSocket connection established!"

    input_id = $('#user_id')
    input_msg = $('#message')

    $('#sendBtn').click ->
        return if input_id.val() is '' || input_msg.val() is ''

        data =
            user_id: input_id.val()
            message: input_msg.val()

        ws.send JSON.stringify data
        input_msg.val ''
