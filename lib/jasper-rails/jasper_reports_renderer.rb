# -*- encoding: utf-8 -*-
module JasperRails
  
  class JasperReportsRenderer < AbstractRenderer
    attr_accessor :file_extension
    attr_accessor :options
    attr_accessor :block
    
    def initialize file_extension, options, &block
      self.file_extension = file_extension
      self.options = options
      self.block = block
    end
    
    def compile jasper_file
      _JasperCompileManager = Rjb::import 'net.sf.jasperreports.engine.JasperCompileManager'
      
      jrxml_file  = jasper_file.sub(/\.jasper$/, ".jrxml")
      
      # Recursively compile subreports
      Nokogiri::XML(open(jrxml_file)).css('subreport/subreportExpression').each do |subreport_expression_node|
        subreport_file = subreport_expression_node.text[1..-2]
        
        if Pathname.new(subreport_file).relative?
          subreport_file = File.expand_path(File.join(File.dirname(jrxml_file), subreport_file))
        end
        compile(subreport_file)
      end
      
      # Compile it, if needed
      if !File.exist?(jasper_file) || (File.exist?(jrxml_file) && File.mtime(jrxml_file) > File.mtime(jasper_file))
        _JasperCompileManager.compileReportToFile(jrxml_file, jasper_file)
      end
    end

    def fill(jasper_file, datasource, parameters, controller_options={})
      _JRException                 = Rjb::import 'net.sf.jasperreports.engine.JRException'
      _JasperFillManager           = Rjb::import 'net.sf.jasperreports.engine.JasperFillManager'
      _JasperPrint                 = Rjb::import 'net.sf.jasperreports.engine.JasperPrint'
      _JRXmlUtils                  = Rjb::import 'net.sf.jasperreports.engine.util.JRXmlUtils'
      _JREmptyDataSource           = Rjb::import 'net.sf.jasperreports.engine.JREmptyDataSource'
      # This is here to avoid the "already initialized constant QUERY_EXECUTER_FACTORY_PREFIX" warnings.
      _JRXPathQueryExecuterFactory = silence_warnings{Rjb::import 'net.sf.jasperreports.engine.query.JRXPathQueryExecuterFactory'}
      _InputSource                 = Rjb::import 'org.xml.sax.InputSource'
      _StringReader                = Rjb::import 'java.io.StringReader'
      _HashMap                     = Rjb::import 'java.util.HashMap'
      _ByteArrayInputStream        = Rjb::import 'java.io.ByteArrayInputStream'
      _String                      = Rjb::import 'java.lang.String'

      parameters ||= {}
  
      # Converting default report params to java HashMap
      jasper_params = _HashMap.new
      JasperRails.config[:report_params].each do |k,v|
        jasper_params.put(k, v)
      end
  
      # Convert the ruby parameters' hash to a java HashMap, but keeps it as
      # default when they already represent a JRB entity.
      # Pay attention that, for now, all other parameters are converted to string!
      parameters.each do |key, value|
        jasper_params.put(_String.new(key.to_s, "UTF-8"), parameter_value_of(value))
      end
      
      # Fill the report
      if datasource
        input_source = _InputSource.new
        input_source.setCharacterStream(_StringReader.new(datasource.to_xml(JasperRails.config[:xml_options].update(controller_options)).to_s))
        data_document = silence_warnings do
          # This is here to avoid the "already initialized constant DOCUMENT_POSITION_*" warnings.
          _JRXmlUtils._invoke('parse', 'Lorg.xml.sax.InputSource;', input_source)
        end

        jasper_params.put(_JRXPathQueryExecuterFactory.PARAMETER_XML_DATA_DOCUMENT, data_document)

        generate_jasper_print jasper_params, jasper_file
      else
        jasper_print = _JasperFillManager.fillReport(jasper_file, jasper_params, _JREmptyDataSource.new)
      end
      
    end

    def generate_jasper_print jasper_params, jasper_file
      _JasperFillManager = Rjb::import 'net.sf.jasperreports.engine.JasperFillManager'
      jasper_print = _JasperFillManager.fillReport(jasper_file, jasper_params)
    end

    def export jasper_print, jr_exporter
      _ByteArrayOutputStream = Rjb::import 'java.io.ByteArrayOutputStream'
      _JRExporter            = Rjb::import jr_exporter
      _JRExporterParameter   = Rjb::import 'net.sf.jasperreports.engine.JRExporterParameter'
      
      exporter = _JRExporter.new
      baos = _ByteArrayOutputStream.new
      
      exporter.setParameter(_JRExporterParameter.JASPER_PRINT, jasper_print)
      exporter.setParameter(_JRExporterParameter.OUTPUT_STREAM, baos)
      exporter.exportReport
      baos.toByteArray      
    end
    
    def render jasper_file, datasource, parameters, controller_options
      begin
        compile(jasper_file)
        jasper_print = fill(jasper_file, datasource, parameters, controller_options)
        run_after_fill_blocks jasper_print, controller_options
        instance_exec(jasper_print, controller_options, &block)
      rescue Exception=>e
        if e.respond_to? 'printStackTrace'
          ::Rails.logger.error e.message
          e.printStackTrace
        else
          ::Rails.logger.error e.message + "\n " + e.backtrace.join("\n ")
        end
        raise e
      end
    end

    private

    def run_after_fill_blocks jasper_print, controller_options
      after_fill_blocks.each do |block|
        instance_exec(jasper_print, controller_options, &block)
      end
    end

    # Returns the value without conversion when it's converted to Java Types.
    # When isn't a Rjb class, returns a Java String of it.
    def parameter_value_of(param)
      _String = Rjb::import 'java.lang.String'
      _Boolean = Rjb::import 'java.lang.Boolean'
      # Using Rjb::import('java.util.HashMap').new, it returns an instance of
      # Rjb::Rjb_JavaProxy, so the Rjb_JavaProxy parent is the Rjb module itself.
      if param.class.parent == Rjb
        param
      elsif param.is_a?(TrueClass) || param.is_a?(FalseClass) 
        _Boolean.new(param)
      else
        _String.new(param.to_s)
      end
    end
    
  end
end