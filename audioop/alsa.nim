
{.pragma: libasound, cdecl, dynlib: "libasound.so".}

type
  snd_output_t* = pointer
  snd_pcm_t* = pointer
  snd_pcm_sframes_t* = clong
  snd_pcm_uframes_t* = culong

  snd_pcm_stream_t* = enum
    SND_PCM_STREAM_PLAYBACK,
    SND_PCM_STREAM_CAPTURE


  snd_pcm_format_t* = enum
    SND_PCM_FORMAT_UNKNOWN = -1, ## Unknown 
    SND_PCM_FORMAT_S8 = 0, ## Signed 8 bit 
    SND_PCM_FORMAT_U8, ## Unsigned 8 bit 
    SND_PCM_FORMAT_S16_LE, ## Signed 16 bit Little Endian 
    SND_PCM_FORMAT_S16_BE, ## Signed 16 bit Big Endian 
    SND_PCM_FORMAT_U16_LE, ## Unsigned 16 bit Little Endian 
    SND_PCM_FORMAT_U16_BE, ## Unsigned 16 bit Big Endian 
    SND_PCM_FORMAT_S24_LE, ## Signed 24 bit Little Endian using low three bytes in 32-bit word 
    SND_PCM_FORMAT_S24_BE, ## Signed 24 bit Big Endian using low three bytes in 32-bit word 
    SND_PCM_FORMAT_U24_LE, ## Unsigned 24 bit Little Endian using low three bytes in 32-bit word 
    SND_PCM_FORMAT_U24_BE, ## Unsigned 24 bit Big Endian using low three bytes in 32-bit word 
    SND_PCM_FORMAT_S32_LE, ## Signed 32 bit Little Endian 
    SND_PCM_FORMAT_S32_BE, ## Signed 32 bit Big Endian 
    SND_PCM_FORMAT_U32_LE, ## Unsigned 32 bit Little Endian 
    SND_PCM_FORMAT_U32_BE, ## Unsigned 32 bit Big Endian 
    SND_PCM_FORMAT_FLOAT_LE, ## Float 32 bit Little Endian, Range -1.0 to 1.0 
    SND_PCM_FORMAT_FLOAT_BE, ## Float 32 bit Big Endian, Range -1.0 to 1.0 
    SND_PCM_FORMAT_FLOAT64_LE, ## Float 64 bit Little Endian, Range -1.0 to 1.0 
    SND_PCM_FORMAT_FLOAT64_BE, ## Float 64 bit Big Endian, Range -1.0 to 1.0 
    SND_PCM_FORMAT_IEC958_SUBFRAME_LE, ## IEC-958 Little Endian 
    SND_PCM_FORMAT_IEC958_SUBFRAME_BE, ## IEC-958 Big Endian 
    SND_PCM_FORMAT_MU_LAW, ## Mu-Law 
    SND_PCM_FORMAT_A_LAW, ## A-Law 
    SND_PCM_FORMAT_IMA_ADPCM, ## Ima-ADPCM 
    SND_PCM_FORMAT_MPEG, ## MPEG 
    SND_PCM_FORMAT_GSM, ## GSM 
    SND_PCM_FORMAT_SPECIAL = 31, ## Special 
    SND_PCM_FORMAT_S24_3LE = 32, ## Signed 24bit Little Endian in 3bytes format 
    SND_PCM_FORMAT_S24_3BE, ## Signed 24bit Big Endian in 3bytes format 
    SND_PCM_FORMAT_U24_3LE, ## Unsigned 24bit Little Endian in 3bytes format 
    SND_PCM_FORMAT_U24_3BE, ## Unsigned 24bit Big Endian in 3bytes format 
    SND_PCM_FORMAT_S20_3LE, ## Signed 20bit Little Endian in 3bytes format 
    SND_PCM_FORMAT_S20_3BE, ## Signed 20bit Big Endian in 3bytes format 
    SND_PCM_FORMAT_U20_3LE, ## Unsigned 20bit Little Endian in 3bytes format 
    SND_PCM_FORMAT_U20_3BE, ## Unsigned 20bit Big Endian in 3bytes format 
    SND_PCM_FORMAT_S18_3LE, ## Signed 18bit Little Endian in 3bytes format 
    SND_PCM_FORMAT_S18_3BE, ## Signed 18bit Big Endian in 3bytes format 
    SND_PCM_FORMAT_U18_3LE, ## Unsigned 18bit Little Endian in 3bytes format 
    SND_PCM_FORMAT_U18_3BE, ## Unsigned 18bit Big Endian in 3bytes format 
    SND_PCM_FORMAT_G723_24, ## G.723 (ADPCM) 24 kbit/s, 8 samples in 3 bytes
    SND_PCM_FORMAT_G723_24_1B, ## G.723 (ADPCM) 24 kbit/s, 1 sample in 1 byte
    SND_PCM_FORMAT_G723_40, ##G.723 (ADPCM) 40 kbit/s, 8 samples in 3 bytes
    SND_PCM_FORMAT_G723_40_1B, ##G.723 (ADPCM) 40 kbit/s, 1 sample in 1 byte
    SND_PCM_FORMAT_DSD_U8, ##Direct Stream Digital (DSD) in 1-byte samples (x8)
    SND_PCM_FORMAT_DSD_U16_LE, ##Direct Stream Digital (DSD) in 2-byte samples (x16)
    SND_PCM_FORMAT_DSD_U32_LE, ##Direct Stream Digital (DSD) in 4-byte samples (x32)
    SND_PCM_FORMAT_DSD_U16_BE, ##Direct Stream Digital (DSD) in 2-byte samples (x16)
    SND_PCM_FORMAT_DSD_U32_BE, ##Direct Stream Digital (DSD) in 4-byte samples (x32)
  
const SND_PCM_FORMAT_LAST = SND_PCM_FORMAT_DSD_U32_BE

when cpuEndian == littleEndian:
  type snd_pcm_format2_t* = enum
    ## Signed 16 bit CPU endian 
    SND_PCM_FORMAT_S16 = SND_PCM_FORMAT_S16_LE,
    ## Unsigned 16 bit CPU endian 
    SND_PCM_FORMAT_U16 = SND_PCM_FORMAT_U16_LE,
    ## Signed 24 bit CPU endian 
    SND_PCM_FORMAT_S24 = SND_PCM_FORMAT_S24_LE,
    ## Unsigned 24 bit CPU endian 
    SND_PCM_FORMAT_U24 = SND_PCM_FORMAT_U24_LE,
    ## Signed 32 bit CPU endian 
    SND_PCM_FORMAT_S32 = SND_PCM_FORMAT_S32_LE,
    ## Unsigned 32 bit CPU endian 
    SND_PCM_FORMAT_U32 = SND_PCM_FORMAT_U32_LE,
    ## Float 32 bit CPU endian 
    SND_PCM_FORMAT_FLOAT = SND_PCM_FORMAT_FLOAT_LE,
    ## Float 64 bit CPU endian 
    SND_PCM_FORMAT_FLOAT64 = SND_PCM_FORMAT_FLOAT64_LE,
    ## IEC-958 CPU Endian 
    SND_PCM_FORMAT_IEC958_SUBFRAME = SND_PCM_FORMAT_IEC958_SUBFRAME_LE

elif cpuEndian == bigEndian:
  type snd_pcm_format2_t* = enum
    #elif __BYTE_ORDER == __BIG_ENDIAN
    ## Signed 16 bit CPU endian 
    SND_PCM_FORMAT_S16 = SND_PCM_FORMAT_S16_BE,
    ## Unsigned 16 bit CPU endian 
    SND_PCM_FORMAT_U16 = SND_PCM_FORMAT_U16_BE,
    ## Signed 24 bit CPU endian 
    SND_PCM_FORMAT_S24 = SND_PCM_FORMAT_S24_BE,
    ## Unsigned 24 bit CPU endian 
    SND_PCM_FORMAT_U24 = SND_PCM_FORMAT_U24_BE,
    ## Signed 32 bit CPU endian 
    SND_PCM_FORMAT_S32 = SND_PCM_FORMAT_S32_BE,
    ## Unsigned 32 bit CPU endian 
    SND_PCM_FORMAT_U32 = SND_PCM_FORMAT_U32_BE,
    ## Float 32 bit CPU endian 
    SND_PCM_FORMAT_FLOAT = SND_PCM_FORMAT_FLOAT_BE,
    ## Float 64 bit CPU endian 
    SND_PCM_FORMAT_FLOAT64 = SND_PCM_FORMAT_FLOAT64_BE,
    ## IEC-958 CPU Endian 
    SND_PCM_FORMAT_IEC958_SUBFRAME = SND_PCM_FORMAT_IEC958_SUBFRAME_BE
else:
    raise

type snd_pcm_access_t* = enum
  SND_PCM_ACCESS_MMAP_INTERLEAVED = 0, ## mmap access with simple interleaved channels 
  SND_PCM_ACCESS_MMAP_NONINTERLEAVED, ## mmap access with simple non interleaved channels 
  SND_PCM_ACCESS_MMAP_COMPLEX, ## mmap access with complex placement 
  SND_PCM_ACCESS_RW_INTERLEAVED, ## snd_pcm_readi/snd_pcm_writei access 
  SND_PCM_ACCESS_RW_NONINTERLEAVED, ## snd_pcm_readn/snd_pcm_writen access 

const SND_PCM_ACCESS_LAST* = SND_PCM_ACCESS_RW_NONINTERLEAVED

proc snd_pcm_open*(pcmp : ptr snd_pcm_t, name : cstring, stream : snd_pcm_stream_t, mode : cint) : cint {.libasound, importc:"snd_pcm_open" }
proc snd_pcm_set_params*(pcm : snd_pcm_t, format : snd_pcm_format_t, access : snd_pcm_access_t, channels : cuint, rate : cint, soft_resample : cuint, latency : cuint) : cint {.libasound, importc:"snd_pcm_set_params" }

proc snd_pcm_writei*(pcm : snd_pcm_t, buffer : pointer, size : snd_pcm_uframes_t) : snd_pcm_sframes_t {.libasound, importc:"snd_pcm_writei" }
proc snd_pcm_recover*(pcm : snd_pcm_t, err : cint, silent : cint) : cint {.libasound, importc:"snd_pcm_recover" }
proc snd_pcm_close*(pcm : snd_pcm_t) : cint {.libasound, importc:"snd_pcm_close" }

proc snd_strerror*(errnum : cint) : cstring {.libasound, importc:"snd_strerror" }
