#!/bin/bash
## pak al deze spacefm plugins uit naar $basis om op te laden naar github
basis=/media/ramdisk
for z in *.spacefm-plugin.tar.gz
do
	doeldir="$basis"/spacefm-plugins/"${z/.tar.gz}"
	mkdir -p "$doeldir"
	tar -xf "$z" -C "$doeldir"
done
pushd "$basis"/spacefm-plugins
echo "# De hele verzameling">"$basis"/collectie.md
for d in *.spacefm-plugin
do
	md="${d/.spacefm-plugin}.md"
	echo -e "# $d" > "$md"
	sed -nE 's/^cstm.*-label=(.*)/## \1\n    /p;s/^cstm.*-line=/    /p' "$d"/plugin | sed -E 's/\\n/\n    /g;s/\\t/\t/g' >> "$md"
	cat "$md">>"$basis"/collectie.md
	echo "">>"$basis"/collectie.md
done
popd
