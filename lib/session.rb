require 'json'
require 'byebug'


class Session
  # find the cookie for this app
  # deserialize the cookie into a hash #.to_json
  #get request's cookies - req.cookies
  def initialize(req)
    session_cookie = req.cookies['_rails_lite_app']
    if session_cookie
      @data = JSON.parse(session_cookie)
    else
      @data = {}
    end
  end

  def [](key)
    @data[key]
  end

  def []=(key, val)
    @data[key] = val
  end

  # serialize the hash into json and save in a cookie
  # add to the response's cookies
  def store_session(res)
    cookie = { path: '/', value: @data.to_json }
    res.set_cookie("_rails_lite_app", cookie)
  end
end

