require 'travis/api/app'

class Travis::Api::App
  module Extensions
    module Format
      ACCEPT = {
        atom: 'application/atom',
        png: 'image/png',
        svg: 'image/svg+xml',
        xml: 'application/xml',
      }

      def self.registered(app)
        app.helpers self
      end

      def format(*formats)
        condition do
          format_from_path?(formats) || accept_header?(formats)
        end
      end

      def format_from_path?(formats)
        format = env['travis.format_from_path']
        format && formats.include?(format.to_sym)
      end

      def accept_header?(formats)
        accept = env['HTTP_ACCEPT'].to_s
        formats.any? { |format| accept.include?(ACCEPT[format.to_sym]) }
      end
    end
  end
end
