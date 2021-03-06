LIB_ENCODER_A=$(BIN)/liballegro_encode.a
LIB_ENCODER_DLL=$(BIN)/liballegro_encode.so

-include lib_encode/project_mcu.mk

ifneq ($(findstring mingw,$(TARGET)),mingw)
	CFLAGS+=-fPIC
endif

LIB_ENCODE_SRC+=\
	lib_encode/Com_Encoder.c\
	lib_encode/HEVC_Encoder.c\
	lib_encode/HEVC_Sections.c\
	lib_encode/AVC_Encoder.c\
	lib_encode/AVC_Sections.c\
	lib_encode/Sections.c\
	lib_encode/NalWriters.c\
	lib_encode/IP_Utils.c\
	lib_encode/IP_Stream.c\
	lib_encode/lib_encoder.c\
	lib_encode/ISchedulerCommon.c\
	lib_encode/IScheduler.c\
	lib_encode/SourceBufferChecker.c\

ifneq ($(ENABLE_VP9),0)
	LIB_ENCODE_SRC+=\
    lib_encode/VP9_Probs.c\

endif

ifneq ($(ENABLE_JPEG),0)
	LIB_ENCODE_SRC+=\
    lib_encode/JpegTables.c\

endif

LIB_ENCODER_SRC:=\
  $(LIB_FPGA_SRC)\
  $(LIB_COMMON_SRC)\
  $(LIB_COMMON_ENC_SRC)\
  $(LIB_RTOS_SRC)\
  $(LIB_ENCODE_SRC)\
  $(LIB_SCHEDULER_SRC)\
  $(LIB_SCHEDULER_ENC_SRC)\
  $(LIB_BITSTREAM_SRC)\
  $(LIB_PREPROCESS_SRC)\
  $(LIB_BUF_MNGT_SRC)\
  $(LIB_RATECTRL_SRC)\
  $(LIB_PERFS_SRC)\

LIB_ENCODER_OBJ:=$(LIB_ENCODER_SRC:%=$(BIN)/%.o)

$(LIB_ENCODER_DLL): $(LIB_ENCODER_OBJ)

$(LIB_ENCODER_A): $(LIB_ENCODER_OBJ)


liballegro_encode: liballegro_encode_dll liballegro_encode_a

liballegro_encode_dll: $(LIB_ENCODER_DLL)

liballegro_encode_a: $(LIB_ENCODER_A)

TARGETS+=liballegro_encode_dll

UNITTEST+=$(shell find lib_encode/unittests -name "*.cpp")
UNITTEST+=$(LIB_ENCODE_SRC)
UNITTEST+=$(LIB_SCHEDULER_SRC)
UNITTEST+=$(LIB_SCHEDULER_ENC_SRC)
UNITTEST+=$(LIB_COMMON_SRC)
UNITTEST+=$(LIB_BITSTREAM_SRC)
UNITTEST+=$(LIB_COMMON_ENC_SRC)
UNITTEST+=$(LIB_PREPROCESS_SRC)
UNITTEST+=$(LIB_RATECTRL_SRC)

.PHONY: liballegro_encode liballegro_encode_dll liballegro_encode_a
