require 'ffi/bit_masks/bit_mask'
require 'ffi/bit_masks/version'

module FFI
  #
  # Adds bitmask types to FFI libraries.
  #
  module BitMasks
    #
    # Defines a new bitmask.
    #
    # @param [Symbol] name
    #   The name of the bitmask.
    #
    # @param [Hash{Symbol => Integer}] flags
    #   The flags and their masks.
    #
    # @param [Symbol] type
    #   The underlying type.
    #
    # @return [BitMask]
    #   The new bitmask.
    #
    def bit_mask(name,flags,type=:uint)
      bit_mask = BitMask.new(flags,type)

      typedef(bit_mask,name)
      return bit_mask
    end
  end
end
