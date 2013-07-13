class SinatraApp < Sinatra::Base
  configure :development do
    Bundler.require :development
    register Sinatra::Reloader
  end

  configure do
    set :server, 'thin'
    set :sockets, []
  end

  get '/' do
    if !request.websocket?
      slim :index
    else
      request.websocket do |ws|
        ws.onopen do
          settings.sockets << ws
        end

        ws.onmessage do |msg|
          EventMachine.next_tick { settings.sockets.each { |s| s.send(msg) } }
        end

        ws.onclose do
          warn("websocket closed")
          settings.sockets.delete(ws)
        end
      end
    end
  end

  get '/wschat.js' do
    coffee :wschat
  end
end
