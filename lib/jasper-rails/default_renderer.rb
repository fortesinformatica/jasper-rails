# -*- encoding: utf-8 -*
module JasperRails
  
  class DefaultRenderer < JasperRailsRenderer
    
    register :pdf, :mime_type => Mime::PDF do |jasper_print|
      _JasperExportManager = Rjb::import 'net.sf.jasperreports.engine.JasperExportManager'
      _JasperExportManager._invoke('exportReportToPdf', 'Lnet.sf.jasperreports.engine.JasperPrint;', jasper_print)
    end
    
  end
end
