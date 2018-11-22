require 'active_support'
require 'active_support/core_ext'
require 'erb'
require_relative './session'

class ControllerBase
  attr_reader :req, :res, :params

  # Setup the controller
  def initialize(req, res)
    @req = req
    @res = res
  end

  # Helper method to alias @already_built_response
  def already_built_response?
    @already_built_response
  end

  # Set the response status code and header
  def redirect_to(url)
    unless already_built_response?
      @res.status = 302
      @res['location'] = url
      session.store_session(@res)
      @already_built_response = true
    else
      raise "I\'m not mad I\'m just disappointed"
    end
  end

  # Populate the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  def render_content(content, content_type = 'text/html')
    unless already_built_response?
      @res['Content-Type'] = content_type
      @res.write(content)
      session.store_session(@res)
      @already_built_response = true
    else
      raise "I\'m not mad I\'m just disappointed"
    end
    
  end

  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name)
    path = File.dirname(__FILE__)
    new_path = File.join(path, "..", 'views', self.class.name.underscore, "#{template_name}.html.erb")
    file_content = File.read(new_path)
    erb_code = ERB.new(file_content).result(binding)
    render_content(erb_code)
  end
  


  # method exposing a `Session` object
  # @session ||= constructs a session from the request (set this to local_var)
  
  #call store_session on @res in render_content and redirect_to
  def session
    @session ||= Session.new(@req)
  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(name)
  end
end

