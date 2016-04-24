dnl Configuring the LibXML external Library
if test -z "$PHP_LIBXML_DIR"; then
  PHP_ARG_WITH(libxml-dir, libxml2 install dir,
  [  --with-libxml-dir=[DIR]     php-augeas : libxml2 install prefix], no, no)
fi

if test "$PHP_LIBXML" = "no"; then
  AC_MSG_ERROR([php-augeas extension requires LIBXML extension, add --with-libxml-dir])
fi

PHP_SETUP_LIBXML(XML_SHARED_LIBADD, [
  PHP_ADD_EXTENSION_DEP(xml, libxml)
], [
  AC_MSG_ERROR([xml2-config not found. Use --with-libxml-dir=<DIR>])
])

PHP_ARG_WITH(augeas,for AUGEAS support,
[  --with-augeas[=DIR]       Include AUGEAS support])

if test "$PHP_AUGEAS" != "no"; then

  if test "$PHP_AUGEAS" != "yes"; then
    AUGEAS_SEARCH_DIRS=$PHP_AUGEAS
  else
    AUGEAS_SEARCH_DIRS="/usr/local /usr"
  fi

  for i in $AUGEAS_SEARCH_DIRS; do
    if test -f $i/include/augeas/augeas.h; then
      AUGEAS_DIR=$i
      AUGEAS_INCDIR=$i/include/augeas
    elif test -f $i/include/augeas.h; then
      AUGEAS_DIR=$i
      AUGEAS_INCDIR=$i/include
    fi
  done

  if test -z "$AUGEAS_DIR"; then
    AC_MSG_ERROR(Cannot find libaugeas use --with-augeas=<DIR>)
  fi

  AUGEAS_LIBDIR=$AUGEAS_DIR/$PHP_LIBDIR

  PHP_ADD_LIBRARY_WITH_PATH(augeas, $AUGEAS_LIBDIR, AUGEAS_SHARED_LIBADD)
  PHP_ADD_INCLUDE($AUGEAS_INCDIR)


  PHP_NEW_EXTENSION(augeas, augeas.c, $ext_shared)
  PHP_SUBST(AUGEAS_SHARED_LIBADD)
  PHP_SUBST(XML_SHARED_LIBADD)
  AC_DEFINE(HAVE_AUGEAS,1,[ ])
fi
