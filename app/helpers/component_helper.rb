module ComponentHelper
  def component(component_name, *args, &block)
    locals = args.extract_options!
    render("/components/#{component_name}/#{component_name.split('/').last}.html.erb", locals, &block)
  end
  alias c component
end
