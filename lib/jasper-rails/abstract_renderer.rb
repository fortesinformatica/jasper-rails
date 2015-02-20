# -*- encoding: utf-8 -*-
module JasperRails
    
  class AbstractRenderer

    class_attribute :after_fill_blocks
    self.after_fill_blocks = []

    def self.register(file_extension, options = {}, &block)
      renderer = self.new(file_extension, options, &block)
  
      if Mime::Type.lookup_by_extension(file_extension).nil?
        Mime::Type.register options[:mime_type], file_extension.to_sym
      end
      if  Rails.version > "4.1"
        define_render_rails_greater_4_1(renderer,file_extension, options)
      else
        define_render_rails_less_4_2(renderer,file_extension, options)
      end
    end

    def self.after_fill(&block)
      self.after_fill_blocks += [block]
    end

    def self.define_render_rails_less_4_2(renderer,file_extension, opts = {})
      ActionController::Responder.send(:define_method, "to_#{file_extension}") do
        if template_name = self.options[:template]
        else
          template_name = "#{controller.controller_path}/#{controller.action_name}"
        end
        details_options = {:formats => [:jrxml], :handlers => []}

        jrxml_file = controller.lookup_context.find_template(template_name,[],false,[],details_options).identifier
        jasper_file = jrxml_file.sub(/\.jrxml$/, ".jasper")      
  
        params = {}
        controller.instance_variables.each do |v|
          params[v.to_s[1..-1]] = controller.instance_variable_get(v)
        end
  
        response_options = JasperRails.config[:response_options].merge(:type => options[:mime_type])
        controller.send_data renderer.render(jasper_file, resource, params, self.options), response_options
      end
    end

    def self.define_render_rails_greater_4_1(renderer,file_extension, options = {})
      ActionController::Renderers.add "#{file_extension}".to_sym do |resource,opts|
        default_template = "#{self.controller_path}/#{self.action_name}"
        if opts[:template] != self.action_name
          template_name = opts[:template]
        else
          template_name = default_template
        end
        
        details_options = {:formats => [:jrxml], :handlers => []}

        jrxml_file = self.lookup_context.find_template(template_name,[],false,[],details_options).identifier
        jasper_file = jrxml_file.sub(/\.jrxml$/, ".jasper")      
  
        params = {}
        self.instance_variables.each do |v|
          params[v.to_s[1..-1]] = self.instance_variable_get(v)
        end
        
        response_options = JasperRails.config[:response_options].merge(:type => options[:mime_type])
        self.send_data renderer.render(jasper_file, resource, params, opts), response_options
      end
    end
  
  end

end
