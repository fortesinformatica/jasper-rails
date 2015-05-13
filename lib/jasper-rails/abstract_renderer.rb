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
      if  Rails.version >= '4.2'
        define_render_rails_geq_4_2(renderer,file_extension, options)
      else
        define_render_rails_less_4_2(renderer,file_extension, options)
      end
    end

    def self.after_fill(&block)
      self.after_fill_blocks += [block]
    end

    def self.define_render_rails_geq_4_2(renderer, file_extension, options = {})
      ActionController::Renderers.add "#{file_extension}".to_sym do |resource, opts|
        JasperRails::AbstractRenderer.response_report(self, renderer, resource, options.merge(opts))
      end
    end

    def self.define_render_rails_less_4_2(renderer,file_extension, options = {})
      ActionController::Responder.send(:define_method, "to_#{file_extension}") do
        JasperRails::AbstractRenderer.response_report(controller, renderer, resource, options.merge(self.options))
      end
    end

     def self.response_report(controller, renderer, resource, options)        
        template = "#{controller.controller_path}/#{controller.action_name}"

        if !options[:template].blank? && options[:template] != controller.action_name
          template = options[:template]
        end
        
        details_options = {:formats => [:jrxml], :handlers => []}

        jrxml_file = controller.lookup_context.find_template(template,[],false,[], details_options).identifier
        jasper_file = jrxml_file.sub(/\.jrxml$/, ".jasper")

        params = {}
        controller.instance_variables.each do |v|
          params[v.to_s[1..-1]] = controller.instance_variable_get(v)
        end
  
        response_options = JasperRails.config[:response_options].merge(:type => options[:mime_type])
        
        controller.send_data renderer.render(jasper_file, resource, params, options), response_options
      end
  end
end