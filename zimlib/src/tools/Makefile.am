AM_CPPFLAGS=-I$(top_builddir)/include
if MAKE_BENCHMARK
  ZIMBENCH = zimbench
endif
bin_PROGRAMS = zimsearch $(ZIMBENCH)
zimsearch_SOURCES = zimSearch.cpp
zimbench_SOURCES = zimBench.cpp
LDADD = $(top_builddir)/src/libzim.la
