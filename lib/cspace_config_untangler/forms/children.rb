require_relative 'properties'

module CspaceConfigUntangler
  module Forms
    class Children
      def initialize(formobj, parentprops, data)
        @form = formobj
        @parent = parentprops
        @children = standardize_form_data(data)
        @children.each{ |child| CCU::Forms::Properties.new(@form, child['props'], @parent) } unless @children.nil?
      end

      # if there is only one child, it gets created as a hash
      # if there are multiple children, they are an array of hashes
      # turns a single child into an array containing one hash
      def standardize_form_data(data)
        if data.is_a?(Hash)
          result = [data]
        elsif data.is_a?(Array)
          result = data
        end
        report_non_nil_and_missing_keys(result)
        return result
      end

      # form children have keys: key, ref, props, and _owner
      # I'm proceeding based on the assumption that I only care about props because
      #  the others are always nil
      # This logs any non-nil values for key, ref, or _owner so I can inspect
      def report_non_nil_and_missing_keys(data)
        data.each{ |h|
          %w[key ref _owner].each{ |k| check_key(h, k) }
        } unless data.nil?
      end

      def check_key(hash, key)
        if hash.has_key?(key)
          CCU.log.warn("FORM STRUCTURE: NON-NIL HASH KEY: #{profile} - #{rectype} - #{@form.name} #{@parent.ui_path.join(' / ')} #{key} has value: #{hash[key]}") unless hash[key].nil?
        else
          CCU.log.warn("FORM STRUCTURE: MISSING HASH KEY: #{profile} - #{rectype} - #{@form.name} #{@parent.ui_path.join(' / ')} missing #{key} key")
        end
      end
    end
  end
end
