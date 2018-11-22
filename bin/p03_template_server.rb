require 'rack'
require_relative '../lib/controller_base'

class MyController < ControllerBase
  def go
    render :show
  end
  
  # def render(template_name)
  #   path = File.dirname(__FILE__)
  #   new_path = File.join(path, 'views', "#{template_name}.html.erb")
  #   file_content = File.read(new_path)
  #   erb_code = ERB.new(file_content).result(binding)
  #   render_content(erb_code)
  # end
end

app = Proc.new do |env|
  req = Rack::Request.new(env)
  res = Rack::Response.new
  MyController.new(req, res).go
  res.finish
end

Rack::Server.start(
  app: app,
  Port: 3000
)
