module FFI
  module BitFields
    class Field

      include DataConverter

      #
      # @param [Array<(Symbol, Integer)>] fields
      #
      def initialize(fields)
        @fields   = []
        @bitmasks = {}

        fields.each_slice(2) do |field,bitmask|
          @fields << field
          @bitmasks[field] = bitmask
        end

        @bitfields = @bitmasks.invert
      end

      #
      # @return [Array<Symbol>]
      #
      def symbols
        @fields
      end

      #
      # @return [Hash{Symbol => Integer}]
      #
      def symbol_map
        @bitmasks
      end

      alias to_h symbol_map
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
        when Symbol
          @bitmasks[query]
        when Integer
          @bitfields[query]
        end
      end

      alias find []

      #
      # Underlying type.
      #
      # @return [FFI::Type::UINT]
      #
      def native_type; Type::UINT; end

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
              uint |= @bitmasks[field]
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

        @bitmasks.each do |name,bitmask|
          bitfield[name] |= ((value & bitmask) == value)
        end

        return bitfield
      end

    end
  end
end
