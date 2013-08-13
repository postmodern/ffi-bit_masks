module FFI
  module BitFields
    class Field

      include DataConverter

      #
      # Fields of the bit-field
      #
      # @return [Hash{Symbol => Integer}]
      #   The mapping of bit-fields to bitmasks.
      #
      attr_reader :fields

      #
      # The bitmasks of the bit-field
      #
      # @return [Hash{Integer => Symbol}]
      #   The mapping of bitmasks to bit-fields.
      #   
      attr_reader :bitmasks

      #
      # The underlying native type.
      #
      # @return [FFI::Type]
      #   The FFI primitive.
      #
      attr_reader :native_type

      #
      # @param [Hash{Symbol => Integer}] fields
      #
      # @param [Symbol] type
      #   The underlying type.
      #
      def initialize(fields,type)
        @fields      = fields
        @bitmasks    = fields.invert
        @native_type = FFI.find_type(type)
      end

      #
      # @return [Array<Symbol>]
      #
      def symbols
        @fields.keys
      end

      #
      # @return [Hash{Symbol => Integer}]
      #
      def symbol_map
        @fields
      end

      alias to_h    symbol_map
      alias to_hash symbol_map

      #
      # @overload [](query)
      #
      #   @param [Symbol] query
      #
      #   @return [Integer]
      #
      # @overload [](query)
      #
      #   @param [Integer] query
      #
      #   @return [Symbol]
      #
      def [](query)
        case query
        when Symbol  then @fields[query]
        when Integer then @bitmasks[query]
        end
      end

      alias find []

      #
      # @param [Hash, #to_int] value
      #
      # @return [Integer]
      #
      # @raise [ArgumentError]
      #
      def to_native(value,ctx=nil)
        uint = 0

        case value
        when Hash
          uint = 0

          value.each do |field,value|
            if value
              uint |= @fields[field]
            end
          end

          return uint
        else
          if value.respond_to?(:to_int)
            value.to_int
          else
            raise(ArgumentError,"invalid bitfield value #{value.inspect}")
          end
        end
      end

      #
      # @param [Integer] value
      #
      # @return [Hash]
      #
      def from_native(value,ctx=nil)
        bitfield = {}

        @fields.each do |name,bitmask|
          bitfield[name] ||= ((value & bitmask) == bitmask)
        end

        return bitfield
      end

    end
  end
end
