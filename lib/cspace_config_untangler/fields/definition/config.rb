# frozen_string_literal: true

require_relative 'namespace'

module CspaceConfigUntangler
  module Fields
    module Definition
      # passes around all the stuff needed to create a field definition
      class Config
        attr_reader :namespace, :hash, :parent
        def initialize(rectype:, namespace:, field_hash:, parser:, name: nil, parent: nil)
          @rectype = rectype
          @namespace = Namespace.new(namespace)
          @hash = field_hash
          @parser = parser
          @name = name
          @parent = parent
        end

        # returns a copy of itself that can be safely passed on and modified
        def derive_child(field_hash:, name:, parent:)
          self.class.new(
            rectype: @rectype,
            namespace: @namespace,
            field_hash: field_hash,
            parser: @parser,
            name: name,
            parent: parent
          )
        end

        def signature
          return namespace_signature unless @name
          
          namespace_signature + " - #{@name}"
        end
        
        def namespace_signature
          "#{profile} - #{rectype} - #{namespace.literal}"
        end
        
        def profile
          @rectype.profile.name
        end

        def profile_config
          @rectype.profile.config
        end

        def rectype
          @rectype.name
        end

        def update_field_hash(hash)
          @hash = CCU.safe_copy(hash)
        end
      end
    end
  end
end
