require 'ffi/bit_masks/bit_mask'
require 'ffi/bit_masks/version'

module FFI
  module BitMasks
    #
    # Defines a new bitmask.
    #
    # @param [Symbol] name
    #
    # @param [Hash{Symbol => Integer}] flags
    #
    # @param [Symbol] type
    #   The underlying type.
    #
    # @return [BitMask]
    #   The new bitmask.
    #
    def bit_mask(name,flags,type=:uint)
      bit_mask = BitMask.new(type,flags)

      typedef(name,bit_mask)
      return bit_mask
    end
  end
end
