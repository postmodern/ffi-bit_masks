require 'ffi'

module FFI
  module BitMasks
    class BitMask

      include DataConverter

      #
      # Fields of the bitmask.
      #
      # @return [Hash{Symbol => Integer}]
      #   The mapping of bit-flags to bitmasks.
      #
      attr_reader :flags

      #
      # The bitmasks of the bitmask.
      #
      # @return [Hash{Integer => Symbol}]
      #   The mapping of bitmasks to bit-flags.
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
      # @param [Hash{Symbol => Integer}] flags
      #
      # @param [Symbol] type
      #   The underlying type.
      #
      def initialize(flags,type=:uint)
        @flags       = flags
        @bitmasks    = flags.invert
        @native_type = FFI.find_type(type)
      end

      #
      # @return [Array<Symbol>]
      #
      # @note For compatibility with `FFI::Enum`.
      #
      def symbols
        @flags.keys
      end

      #
      # @return [Hash{Symbol => Integer}]
      #
      # @note For compatibility with `FFI::Enum`.
      #
      def symbol_map
        @flags
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
        when Symbol  then @flags[query]
        when Integer then @bitmasks[query]
        end
      end

      #
      # @note For compatibility with `FFI::Enum`.
      #
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

          value.each do |flag,value|
            if (@flags.has_key?(flag) && value)
              uint |= @flags[flag]
            end
          end

          return uint
        else
          if value.respond_to?(:to_int)
            value.to_int
          else
            raise(ArgumentError,"invalid bitmask value #{value.inspect}")
          end
        end
      end

      #
      # @param [Integer] value
      #
      # @return [Hash]
      #
      def from_native(value,ctx=nil)
        flags = {}

        @flags.each do |flag,bitmask|
          flags[flag] ||= ((value & bitmask) == bitmask)
        end

        return flags
      end

    end
  end
end
