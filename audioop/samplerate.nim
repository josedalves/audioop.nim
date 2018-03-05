
##-----------------------------------------------------------------------------
##samplerate.nim
##-----------------------------------------------------------------------------
##
##NIM bindings to libsamplerate
##

{.pragma: libsamplerate, cdecl, dynlib: "libsamplerate.so".}


type
  SRC_CONVERTER* = enum
    SRC_SINC_BEST_QUALITY       = int(0)
    SRC_SINC_MEDIUM_QUALITY     = int(1)
    SRC_SINC_FASTEST            = int(2)
    SRC_ZERO_ORDER_HOLD         = int(3)
    SRC_LINEAR                  = int(4)

  SRC_DATA* {.header: "<samplerate.h>", importc: "SRC_DATA".} = object
    data_in* : ptr cfloat
    data_out* : ptr cfloat
    input_frames* : clong
    output_frames* : clong
    input_frames_used* : clong
    output_frames_gen* : clong
    end_of_input* : cint
    src_ratio* : cdouble

  SRC_STATE* = pointer
  
  ResamplerObj = object
    src_data : SRC_DATA
    src_state : SRC_STATE

  Resampler = ref ResamplerObj

  ResamplerError = object of Exception
    code : int

#LOW LEVEL API

#Simple API
proc src_simple*(data : ptr SRC_DATA, converter_type : cint, channels : cint) : cint {.libsamplerate, importc:"src_simple" }

#Full API
proc src_new*(converter_type : cint, channels : cint, error : ptr cint) : SRC_STATE {.libsamplerate, importc:"src_new" }
proc src_delete*(state : SRC_STATE) : SRC_STATE {.libsamplerate, importc:"src_delete" }

proc src_process*(state : SRC_STATE, data : ptr SRC_DATA) : cint {.libsamplerate, importc:"src_process" }
proc src_reset*(state : SRC_STATE) : cint {.libsamplerate, importc:"src_reset" }
proc src_set_ratio*(state : SRC_STATE, new_ratio : cdouble) : cint {.libsamplerate, importc:"src_set_ratio" }


proc src_strerror*(error : cint) : cstring {.libsamplerate, importc:"src_strerror" }


#HIGH LEVEL API

proc errResampler(msg : string, code = 0) = 
  var ex = newException(ResamplerError, msg)
  ex.code = code
  raise ex

proc newResampler*() : Resampler = 
  ##Create a new resampler instance
  var
    error : cint = 0
    state : SRC_STATE
  result = new Resampler
  result.src_state = src_new(cint(SRC_SINC_FASTEST), cint(1), addr error)

  if error != 0:
    errResampler($src_strerror(error), error)

proc newResampler*(conv : SRC_CONVERTER, channels : int ) : Resampler = 
  ##Create a new resampler instance
  var
    error : cint = 0
    state : SRC_STATE
  result = new Resampler
  result.src_state = src_new(cint(conv), cint(channels), addr error)

  if error != 0:
    errResampler($src_strerror(error), error)

proc delete*(resampler : Resampler) = 
  resampler.src_state =  src_delete(resampler.src_state)

proc reconfigure*(self : Resampler, conv : int, channels : int) =
  ##Reconfigure the resampler
  ##
  ##Allows changing the converter and number of channels on the fly.
  var
    error : cint = 0

  if self.src_state != nil:
    self.delete()

  self.src_state = src_new(cint(conv), cint(channels), addr error)

  if error != 0:
    errResampler($src_strerror(error), error)

proc setSampleRates*(self : Resampler, in_samplerate : uint, out_samplerate : uint, smooth : bool = true) =
  ##Sets the sample rates.
  ##
  ##in_samplerate is the input sample rate and out_samplerate is the
  ##output sample rate
  ##
  ##For example, if you want to convert from 48000hz to 8000hz, you use:
  ##`resampler.setSampleRates(48000, 8000)`
  if smooth:
    self.src_data.src_ratio = cdouble(out_samplerate) / cdouble(in_samplerate)
  else:
    let error = src_set_ratio(self.src_state, cdouble(out_samplerate) / cdouble(in_samplerate))
    self.src_data.src_ratio = cdouble(out_samplerate) / cdouble(in_samplerate)
    if error != 0:
      errResampler($src_strerror(error), error)


proc process*(self : Resampler, data : var seq[float32]) : seq[float32] = 
  ##Process an entire chunk of data in one go and return the processed
  ##result
  ##
  ##data must be a "var seq", and will be changed in place
  var out_buffer = newSeq[float32](len(data))

  self.src_data.data_in = cast[ptr cfloat](addr data[0])
  self.src_data.data_out  = cast[ptr cfloat](addr out_buffer[0])
  self.src_data.input_frames = data.len()
  self.src_data.output_frames = out_buffer.len()
  self.src_data.output_frames_gen = 0
  self.src_data.input_frames_used = 0

  let error = src_process(self.src_state, addr self.src_data)

  if error != 0:
    errResampler($src_strerror(error), error)

  result = out_buffer[0..self.src_data.output_frames_gen-1]
  data = data[self.src_data.input_frames_used..len(data)-1]

