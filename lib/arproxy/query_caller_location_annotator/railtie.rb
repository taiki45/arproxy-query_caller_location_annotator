module Arproxy
  module QueryCallerLocationAnnotator
    class Railtie < ::Rails::Railtie
      initializer 'arproxy.query_caller_location_annotator' do
        if (::Rails.env.development? || ::Rails.env.test?) && !(ENV['DISABLE_QUERY_LOCATION_ANNOTATE'] == '1')
          ::Arproxy.configure do |config|
            config.adapter = 'mysql2'
            config.use ::Arproxy::QueryCallerLocationAnnotator::Proxy
          end

          ::ActiveSupport.on_load :active_record do
            ::Arproxy.enable!
          end
        end
      end
    end
  end
end
