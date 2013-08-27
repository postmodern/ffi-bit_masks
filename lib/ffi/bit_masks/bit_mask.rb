require 'ffi'

module FFI
  module BitMasks
    #
    # The bitmask data converter.
    #
    class BitMask

      include DataConverter

      #
      # Flags of the bitmask.
      #
      # @return [Hash{Symbol => Integer}]
      #   The mapping of bit-flags to bitmasks.
      #
      attr_reader :flags

      #
      # The masks of the bitmask.
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
      # Initializes a new bitmask.
      #
      # @param [Hash{Symbol => Integer}] flags
      #   The flags and their masks.
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
      # The Symbols that can be passed to the data converter.
      #
      # @return [Array<Symbol>]
      #   The Array of Symbols.
      #
      # @note For compatibility with `FFI::Enum`.
      #
      def symbols
        @flags.keys
      end

      #
      # The mapping of acceptable Symbols to their Integer equivalents.
      #
      # @return [Hash{Symbol => Integer}]
      #   The mapping of Symbols.
      #
      # @note For compatibility with `FFI::Enum`.
      #
      def symbol_map
        @flags
      end

      #
      # @note For compatibility with `FFI::Enum`.
      #
      alias to_h    symbol_map

      #
      # @note For compatibility with `FFI::Enum`.
      #
      alias to_hash symbol_map

      #
      # Maps flags to masks and vice versa.
      #
      # @overload [](query)
      #
      #   @param [Symbol] query
      #     The flag name.
      #
      #   @return [Integer]
      #     The mask for the flag.
      #
      # @overload [](query)
      #
      #   @param [Integer] query
      #     The mask.
      #
      #   @return [Symbol]
      #     The flag for the mask.
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
      # Converts flags to a bitmask.
      #
      # @overload to_native(value)
      #
      #   @param [Hash{Symbol => Boolean}] value
      #     The flags and their values.
      #
      #   @return [Integer]
      #     The bitmask for the given flags.
      #
      # @overload to_native(value)
      #
      #   @param [#to_int] value
      #     The raw bitmask.
      #
      #   @return [Integer]
      #     The bitmask.
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
            int = value.to_int

            @bitmasks.each_key do |mask|
              uint |= (int & mask)
            end

            return uint
          else
            raise(ArgumentError,"invalid bitmask value #{value.inspect}")
          end
        end
      end

      #
      # Converts a bitmask into multiple flags.
      #
      # @param [Integer] value
      #   The raw bitmask.
      #
      # @return [Hash{Symbol => Boolean}]
      #   The flags for the bitmask.
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
