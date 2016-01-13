require 'spec_helper'
require 'ffi/bit_masks'

describe FFI::BitMasks do
  it "should have a VERSION constant" do
    expect(subject.const_get('VERSION')).not_to be_empty
  end

  describe "#bit_mask" do
    subject do
      mod = Module.new
      mod.extend FFI::Library
      mod.extend FFI::BitMasks
    end

    let(:flags) { {:foo => 0x1, :bar => 0x2, :baz => 0x4} }

    it "should return a BitMask object" do
      expect(subject.bit_mask(:flags,flags).flags).to eq(flags)
    end

    it "should define a typedef for the bitmask" do
      bitmask = subject.bit_mask(:flags,flags)

      expect(subject.find_type(:flags)).to be_kind_of(FFI::Type::Mapped)
    end
  end
end
