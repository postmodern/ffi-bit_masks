# ffi-bit_masks

* [Homepage](https://github.com/postmodern/ffi-bit_masks#readme)
* [Issues](https://github.com/postmodern/ffi-bit_masks/issues)
* [Documentation](http://rubydoc.info/gems/ffi-bit_masks/frames)
* [Email](mailto:postmodern.mod3 at gmail.com)

## Description

FFI plugin which adds support for bitmasked types (or flags) to FFI.

## Features

* Can map a Hash of flags to their bitmask value.
* Can map an Integer bitmask to a Hash of flags.

## Examples

    require 'ffi/bit_masks'

    module MyLibrary
      extend FFI::Library

      ffi_lib 'foo'

      bit_mask :flags, {foo: 0x1, bar: 0x2, baz: 0x4}

      attach_function :my_func, [:pointer, :size_t, :flags], :int
    end

## Requirements

* [ffi](https://github.com/ffi/ffi#readme) ~> 1.0

## Install

    $ gem install ffi-bit_masks

## Copyright

Copyright (c) 2012-2013 Hal Brodigan

See {file:LICENSE.txt} for details.
