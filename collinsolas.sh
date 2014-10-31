#!/bin/bash

# Based in part on https://wincent.com/wiki/Fixing_the_baseline_on_the_Consolas_font_on_OS_X

function fail()
{
  local error=${1:-Unknown error}
  echo "Failed! $error"
  exit 1
}

# Check for ttx and xmlstarlet
# Get ttx here: http://sourceforge.net/projects/fonttools/
# Get xmlstarlet via Homebrew: brew install xmlstarlet
[[ -z "`which ttx`" || -z "`which xml`" ]] && fail "One of the required tools was not found in your PATH."

# Loop over Consolas fonts
for font in 'Consolas' 'Consolas Italic' 'Consolas Bold' 'Consolas Bold Italic'; do
  if [ -f "$font.ttf" ]; then
    # Dump font tables into .ttx XML file
    ttx "$font.ttf"
    [ $? -ne 0 ] && fail "ttx returned non-zero while processing $font"
    
    # Validate the .ttx XML file
    xml val "$font.ttx"
    [ $? -ne 0 ] && fail "$font.ttx is not valid XML"

    # Update the ascent, descent, and lineGap values in the Horizontal Header (hhea) table
    xml ed -L -u "/ttFont/hhea/ascent/@value" -v "1884" "$font.ttx"
    xml ed -L -u "/ttFont/hhea/descent/@value" -v "-514" "$font.ttx"
    xml ed -L -u "/ttFont/hhea/lineGap/@value" -v "0" "$font.ttx"

    # Delete the digital signature (DSIG) table, since the
    # modified font will no longer match the original signature
    xml ed -L -d "/ttFont/DSIG" "$font.ttx"

    # Loop over namerecord XML nodes in the name table and change the font name
    namerecord_count="`xml sel -t -v "count(/ttFont/name/namerecord)" "$font.ttx"`"
    [ -z "$namerecord_count" ] && fail "Failed to namerecord nodes"
    for (( namerecord_index = 1; namerecord_index <= $namerecord_count; namerecord_index++ )); do
    echo "Updating $namerecord_index of $namerecord_count namerecord nodes..."
      namerecord_xpath="/ttFont/name/namerecord[$namerecord_index]"
      namerecord="`xml sel -t -v "$namerecord_xpath" "$font.ttx"`"
      new_namerecord="`echo "$namerecord" | sed -e "s/Consolas/Collinsolas/g"`"
      xml ed -L -u "$namerecord_xpath" -v "$new_namerecord" "$font.ttx"
    done

    # Rewrite the font from the .ttx file
    ttx "$font.ttx"
  fi
done
