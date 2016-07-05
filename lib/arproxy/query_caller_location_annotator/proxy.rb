require 'arproxy'

module Arproxy
  module QueryCallerLocationAnnotator
    class Proxy < ::Arproxy::Base
      def execute(sql, name=nil)
        return super(sql, name) unless sql =~ /^(SELECT|INSERT|UPDATE|DELETE)/

        location = query_caller_location
        if location.present?
          super("#{sql} /* #{location} */", name)
        else
          super(sql, name)
        end
      end

      private

      def query_caller_location
        location = caller_locations.find { |l| annotate_location_regexp.match(l.absolute_path) }
        if location.nil?
          nil
        else
          "app#{location.absolute_path.gsub(annotate_match_location, '')}:#{location.lineno} `#{location.label}`"
        end
      end

      def annotate_match_location
        @annotate_match_location ||= ::Rails.root.join('app').to_s.freeze
      end

      def annotate_location_regexp
        @annotate_location_regexp ||= /\A#{Regexp.quote(annotate_match_location)}/.freeze
      end
    end
  end
end
