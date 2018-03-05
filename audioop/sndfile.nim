
##-----------------------------------------------------------------------------
##sndfile.nim
##-----------------------------------------------------------------------------
##
##NIM bindings to libsndfile
##
##This library provides both low level methods (that are just a very, VERY
##thin wrapper for the underlying library) and a higher level API which
##should, hoperfully, be more idiomatic and less error prone.
##
##Methods prefixed with "sf" are low level methods.
##

##TODO: Virtual IO
{.pragma: libsnd, cdecl, dynlib: "libsndfile.so".}

const SF_FALSE : cint = 0
const SF_TRUE  : cint = 1
const SF_AMBISONIC_NONE* : cint = 0x40
const SF_AMBISONIC_B_FORMAT* : cint = 0x41
# Formats, etc

type
  SNDFILE* = distinct pointer ##A pointer to the internal SNDFILE struct

  SF_OPEN_MODE* = enum
    ## Modes for sf_open* functions
    SFM_READ  = cint(0x10) #
    SFM_WRITE = cint(0x20) #
    SFM_RDWR = cint(0x30) #

  SF_FORMAT* = enum
    ##Major formats enum. For subformats, see SF_FORMAT_SUB.
    SF_FORMAT_WAV            = 0x010000        ##  Microsoft WAV format (little endian default). 
    SF_FORMAT_AIFF            = 0x020000        ##  Apple/SGI AIFF format (big endian). 
    SF_FORMAT_AU            = 0x030000        ##  Sun/NeXT AU format (big endian). 
    SF_FORMAT_RAW            = 0x040000        ##  RAW PCM data. 
    SF_FORMAT_PAF            = 0x050000        ##  Ensoniq PARIS file format. 
    SF_FORMAT_SVX            = 0x060000        ##  Amiga IFF / SVX8 / SV16 format. 
    SF_FORMAT_NIST            = 0x070000        ##  Sphere NIST format. 
    SF_FORMAT_VOC            = 0x080000        ##  VOC files. 
    SF_FORMAT_IRCAM            = 0x0A0000        ##  Berkeley/IRCAM/CARL 
    SF_FORMAT_W64            = 0x0B0000        ##  Sonic Foundry's 64 bit RIFF/WAV 
    SF_FORMAT_MAT4            = 0x0C0000        ##  Matlab (tm) V4.2 / GNU Octave 2.0 
    SF_FORMAT_MAT5            = 0x0D0000        ##  Matlab (tm) V5.0 / GNU Octave 2.1 
    SF_FORMAT_PVF            = 0x0E0000        ##  Portable Voice Format 
    SF_FORMAT_XI            = 0x0F0000        ##  Fasttracker 2 Extended Instrument 
    SF_FORMAT_HTK            = 0x100000        ##  HMM Tool Kit format 
    SF_FORMAT_SDS            = 0x110000        ##  Midi Sample Dump Standard 
    SF_FORMAT_AVR            = 0x120000        ##  Audio Visual Research 
    SF_FORMAT_WAVEX            = 0x130000        ##  MS WAVE with WAVEFORMATEX 
    SF_FORMAT_SD2            = 0x160000        ##  Sound Designer 2 
    SF_FORMAT_FLAC            = 0x170000        ##  FLAC lossless file format 
    SF_FORMAT_CAF            = 0x180000        ##  Core Audio File format 
    SF_FORMAT_WVE            = 0x190000        ##  Psion WVE format 
    SF_FORMAT_OGG            = 0x200000        ##  Xiph OGG container 
    SF_FORMAT_MPC2K            = 0x210000        ##  Akai MPC 2000 sampler 
    SF_FORMAT_RF64            = 0x220000        ##  RF64 WAV file 

  SF_FORMAT_SUB* = enum
    ##Sub formats
    SF_FORMAT_PCM_S8        = 0x0001        ##  Signed 8 bit data 
    SF_FORMAT_PCM_16        = 0x0002        ##  Signed 16 bit data 
    SF_FORMAT_PCM_24        = 0x0003        ##  Signed 24 bit data 
    SF_FORMAT_PCM_32        = 0x0004        ##  Signed 32 bit data 

    SF_FORMAT_PCM_U8        = 0x0005        ##  Unsigned 8 bit data (WAV and RAW only) 

    SF_FORMAT_FLOAT            = 0x0006        ##  32 bit float data 
    SF_FORMAT_DOUBLE        = 0x0007        ##  64 bit float data 

    SF_FORMAT_ULAW            = 0x0010        ##  U-Law encoded. 
    SF_FORMAT_ALAW            = 0x0011        ##  A-Law encoded. 
    SF_FORMAT_IMA_ADPCM        = 0x0012        ##  IMA ADPCM. 
    SF_FORMAT_MS_ADPCM        = 0x0013        ##  Microsoft ADPCM. 

    SF_FORMAT_GSM610        = 0x0020        ##  GSM 6.10 encoding. 
    SF_FORMAT_VOX_ADPCM        = 0x0021        ##  OKI / Dialogix ADPCM 

    SF_FORMAT_G721_32        = 0x0030        ##  32kbs G721 ADPCM encoding. 
    SF_FORMAT_G723_24        = 0x0031        ##  24kbs G723 ADPCM encoding. 
    SF_FORMAT_G723_40        = 0x0032        ##  40kbs G723 ADPCM encoding. 

    SF_FORMAT_DWVW_12        = 0x0040         ##  12 bit Delta Width Variable Word encoding. 
    SF_FORMAT_DWVW_16        = 0x0041         ##  16 bit Delta Width Variable Word encoding. 
    SF_FORMAT_DWVW_24        = 0x0042         ##  24 bit Delta Width Variable Word encoding. 
    SF_FORMAT_DWVW_N        = 0x0043         ##  N bit Delta Width Variable Word encoding. 

    SF_FORMAT_DPCM_8        = 0x0050        ##  8 bit differential PCM (XI only) 
    SF_FORMAT_DPCM_16        = 0x0051        ##  16 bit differential PCM (XI only) 

    SF_FORMAT_VORBIS        = 0x0060        ##  Xiph Vorbis encoding. 

    SF_FORMAT_ALAC_16        = 0x0070        ##  Apple Lossless Audio Codec (16 bit). 
    SF_FORMAT_ALAC_20        = 0x0071        ##  Apple Lossless Audio Codec (20 bit). 
    SF_FORMAT_ALAC_24        = 0x0072        ##  Apple Lossless Audio Codec (24 bit). 
    SF_FORMAT_ALAC_32        = 0x0073        ##  Apple Lossless Audio Codec (32 bit). 

  SF_ENDIAN* = enum
    ## Endianness options
    SF_ENDIAN_FILE            = 0x00000000    ##  Default file endian-ness. 
    SF_ENDIAN_LITTLE        = 0x10000000    ##  Force little endian-ness. 
    SF_ENDIAN_BIG            = 0x20000000    ##  Force big endian-ness. 
    SF_ENDIAN_CPU            = 0x30000000    ##  Force CPU endian-ness. 

  SF_FORMAT_MASK* = enum
    SF_FORMAT_SUBMASK        = 0x0000FFFF
    SF_FORMAT_TYPEMASK        = 0x0FFF0000
    SF_FORMAT_ENDMASK        = 0x30000000


type
  sf_count_t {.header: "<sndfile.h>", importc: "sf_count_t"} = int
  size_t = cint

  SF_INFO* {.header: "<sndfile.h>", importc: "SF_INFO".} = object
    frames* : sf_count_t ##Number of frames
    samplerate* : int ##Sample rate
    channels* : int ##Number of channels
    format* : int ##Format. Should a bitmask composed of one SF_FORMAT and one SF_FORMAT_SUB
    sections : int
    seekable: int

  NIMSNDFileObj* = object
    ## Object that encapsulates an SNDFILE object
    sndfile : SNDFILE
    info* : NIMSNDFileInfo

  NIMSNDFile* = ref NIMSNDFileObj

  NIMSNDFileInfoObj* = object
    ## Object that encapsulates an SF_INFO struct
    info* : SF_INFO
    path : string
    mode : int

  NIMSNDFileInfo* = ref NIMSNDFileInfoObj

  NIMSNDFileError* = object of Exception
    code : int

  #TODO!
  #SF_VIRTUAL_IO {.header: "<sndfile.h>", importc: "SF_VIRTUAL_IO".} = object
  #  get_filelen : sf_vio_get_filelen
  #  seek : sf_vio_seek
  #  read : sf_vio_read
  #  write : sf_vio_write
  #  tell : sf_vio_tell


#libsndfile low level api
proc sf_open*(path : cstring, mode : cint, sinfo : ptr SF_INFO) : SNDFILE {.libsnd, importc:"sf_open" }
proc sf_open_fd*(fd : cint, mode : cint, sinfo : ptr SF_INFO, close_desc : cint) : SNDFILE {.libsnd, importc:"sf_open_fd" }
#proc sf_open_virtual*(sfvirtual : ptr SF_VIRTUAL_IO, mode : cint, sinfo : ptr SF_INFO, user_data : pointer) : SNDFILE {.libsnd, importc:"sf_open_virtual" }
proc sf_format_check*(sinfo : ptr SF_INFO) : cint {.libsnd, importc:"sf_format_check" }

proc sf_seek*(sndfile : SNDFILE, frames : sf_count_t, whence : cint) : sf_count_t {.libsnd, importc:"sf_seek" }

proc sf_command*(sndfile : SNDFILE, cmd : cint, data : pointer, datasize : int) : sf_count_t {.libsnd, importc:"sf_command" }

proc sf_error*(sndfile : SNDFILE) : cint {.libsnd, importc:"sf_error" }
proc sf_strerror*(sndfile : SNDFILE) : cstring {.libsnd, importc:"sf_strerror" }
proc sf_error_number*(error_number : cint) : cstring {.libsnd, importc:"sf_error_number" }

proc sf_perror*(sndfile : SNDFILE) : cint {.libsnd, importc:"sf_perror" }
proc sf_error_str*(sndfile : SNDFILE, str : cstring, len : size_t) : cint {.libsnd, importc:"sf_error_str" }

proc sf_read_short*(sndfile : SNDFILE, pointr : ptr cshort, items : sf_count_t) : sf_count_t {.libsnd, importc:"sf_read_short" }
proc sf_read_int*(sndfile : SNDFILE, pointr : ptr cint, items : sf_count_t) : sf_count_t {.libsnd, importc:"sf_read_int" }
proc sf_read_float*(sndfile : SNDFILE, pointr : ptr cfloat, items : sf_count_t) : sf_count_t {.libsnd, importc:"sf_read_float" }
proc sf_read_double*(sndfile : SNDFILE, pointr : ptr cdouble, items : sf_count_t) : sf_count_t {.libsnd, importc:"sf_read_double" }

proc sf_readf_short*(sndfile : SNDFILE, pointr : ptr cshort, frames : sf_count_t) : sf_count_t {.libsnd, importc:"sf_readf_short" }
proc sf_readf_int*(sndfile : SNDFILE, pointr : ptr cint, frames : sf_count_t) : sf_count_t {.libsnd, importc:"sf_readf_int" }
proc sf_readf_float*(sndfile : SNDFILE, pointr : ptr cfloat, frames : sf_count_t) : sf_count_t {.libsnd, importc:"sf_readf_float" }
proc sf_readf_double*(sndfile : SNDFILE, pointr : ptr cdouble, frames : sf_count_t) : sf_count_t {.libsnd, importc:"sf_readf_double" }

proc sf_write_short*(sndfile : SNDFILE, pointr : ptr cshort, items : sf_count_t) : sf_count_t {.libsnd, importc:"sf_write_short" }
proc sf_write_int*(sndfile : SNDFILE, pointr : ptr cint, items : sf_count_t) : sf_count_t {.libsnd, importc:"sf_write_int" }
proc sf_write_float*(sndfile : SNDFILE, pointr : ptr cfloat, items : sf_count_t) : sf_count_t {.libsnd, importc:"sf_write_float" }
proc sf_write_double*(sndfile : SNDFILE, pointr : ptr cdouble, items : sf_count_t) : sf_count_t {.libsnd, importc:"sf_write_double" }

proc sf_writef_short*(sndfile : SNDFILE, pointr : ptr cshort, frames : sf_count_t) : sf_count_t {.libsnd, importc:"sf_writef_short" }
proc sf_writef_int*(sndfile : SNDFILE, pointr : ptr cint, frames : sf_count_t) : sf_count_t {.libsnd, importc:"sf_writef_int" }
proc sf_writef_float*(sndfile : SNDFILE, pointr : ptr cfloat, frames : sf_count_t) : sf_count_t {.libsnd, importc:"sf_writef_float" }
proc sf_writef_double*(sndfile : SNDFILE, pointr : ptr cdouble, frames : sf_count_t) : sf_count_t {.libsnd, importc:"sf_writef_double" }

proc sf_close*(sndfile  : SNDFILE) : int {.libsnd, importc:"sf_close" }



#libsndfile High level API
proc errSNDFile(msg : string, code = 0) = 
  ## Raise an error
  var ex = newException(NIMSNDFileError, msg)
  ex.code = code
  raise ex

proc newNIMSNDFile*() : NIMSNDFile = 
  ## Create new sndfile API entry point
  result = new NIMSNDFile
  result.info = new NIMSNDFileInfo

proc open*(self : NIMSNDFile, path : string, mode : SF_OPEN_MODE) = 
  ## Open a file for processing.
  ##
  ## path is the full path to the file to operate on
  ##
  ## mode is the file open mode.
  self.sndfile = sf_open(cstring(path), cint(mode), addr self.info.info)
  if pointer(self.sndfile) == nil:
    errSNDFile($sf_strerror(self.sndfile))

proc close*(self : NIMSNDFile) =  
  ## Close file.
  if pointer(self.sndfile) == nil:
    errSNDFile("Already closed")
  let error = sf_close(self.sndfile)
  if error != 0:
    errSNDFile($sf_error_number(cint(error)), error)

#-- Read -----------------------------------------------------------------------

proc readShort*(self : NIMSNDFile, count : int) : seq[int16] = 
  if pointer(self.sndfile) == nil:
    errSNDFile("Already closed")
  newSeq[int16](result, count)
  let read_count = sf_read_short(self.sndfile, cast[ptr cshort](addr result[0]), count)
  if read_count != count:
    result = result[0..read_count-1]

proc readInt*(self : NIMSNDFile, count : int) : seq[int32] = 
  if pointer(self.sndfile) == nil:
    errSNDFile("Already closed")
  newSeq[int32](result, count)
  let read_count = sf_read_int(self.sndfile, cast[ptr cint](addr result[0]), count)
  if read_count != count:
    result = result[0..read_count-1]

proc readFloat*(self : NIMSNDFile, count : int) : seq[float32] = 
  if pointer(self.sndfile) == nil:
    errSNDFile("Already closed")
  newSeq[float32](result, count)
  let read_count = sf_read_float(self.sndfile, cast[ptr cfloat](addr result[0]), count)
  if read_count != count:
    result = result[0..read_count-1]

proc readDouble*(self : NIMSNDFile, count : int) : seq[float64] = 
  if pointer(self.sndfile) == nil:
    errSNDFile("Already closed")
  newSeq[float64](result, count)
  let read_count = sf_read_double(self.sndfile, cast[ptr cdouble](addr result[0]), count)
  if read_count != count:
    result = result[0..read_count-1]

#-- Write ----------------------------------------------------------------------

proc writeShort*(self : NIMSNDFile, data : var seq[int16]) : int = 
  if pointer(self.sndfile) == nil:
    errSNDFile("Already closed")
  return sf_write_short(self.sndfile, cast[ptr cshort](addr data[0]), len(data))

proc writeInt*(self : NIMSNDFile, data : var seq[int32]) : int = 
  if pointer(self.sndfile) == nil:
    errSNDFile("Already closed")
  return sf_write_int(self.sndfile, cast[ptr cint](addr data[0]), len(data))

proc writeFloat*(self : NIMSNDFile, data : var seq[float32]) : int = 
  if pointer(self.sndfile) == nil:
    errSNDFile("Already closed")
  return sf_write_float(self.sndfile, cast[ptr cfloat](addr data[0]), len(data))

proc writeDouble*(self : NIMSNDFile, data : var seq[float64]) : int = 
  if pointer(self.sndfile) == nil:
    errSNDFile("Already closed")
  return sf_write_double(self.sndfile, cast[ptr cdouble](addr data[0]), len(data))

