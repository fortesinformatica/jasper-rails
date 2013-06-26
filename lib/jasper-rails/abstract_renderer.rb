# -*- encoding: utf-8 -*-
module JasperRails
    
  class AbstractRenderer
    def self.register(file_extension, options = {}, &block)
      renderer = self.new(file_extension, options, &block)
  
      if Mime::Type.lookup_by_extension(file_extension).nil?
        Mime::Type.register options[:mime_type], file_extension.to_sym
      end
      
      ActionController::Responder.send(:define_method, "to_#{file_extension}") do
        jasper_file = "#{Rails.root.to_s}/app/views/#{controller.controller_path}/#{controller.action_name}.jasper"
  
        params = {}
        controller.instance_variables.each do |v|
          params[v.to_s[1..-1]] = controller.instance_variable_get(v)
        end
  
        response_options = JasperRails.config[:response_options].merge(:type => options[:mime_type])
        
        controller.send_data renderer.render(jasper_file, resource, params, options), response_options
      end
    end
  end
end
