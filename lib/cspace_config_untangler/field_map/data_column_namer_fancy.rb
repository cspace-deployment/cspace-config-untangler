module CspaceConfigUntangler
  module FieldMap
    class DataColumnNamerFancy
      ::DataColumnNamerFancy = CspaceConfigUntangler::FieldMap::DataColumnNamerFancy
      attr_reader :result
      # @param fieldname [String] base field name from which to generate column names
      # @param sources [Array<CCU::ValueSources::Authority>] sources for the columns to be generated
      def initialize(fieldname:, sources:)
        @fieldname = fieldname
        @sources = sources
        @result = {}

        # build hash used to check whether to name using authority type, subtype, or both
        h = @sources.group_by{ |src| src.type }.transform_values{ |val| val.map(&:subtype) }

        @sources.each do |source|
          type = source.type
          name = @fieldname.clone
          use_type = h.keys.size > 1 ? true : false
          use_subtype = h[type].size > 1 ? true : false
          name = use_type ? name << type.capitalize : name
          name = use_subtype ? name << source.subtype.capitalize : name
          @result[source] = name
        end
      end
    end
  end
end
