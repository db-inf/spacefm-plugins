#!/bin/bash
## pak al deze spacefm plugins uit naar $basis om op te laden naar github
basis=/media/ramdisk
for z in *.spacefm-plugin.tar.gz *.spacefm-file-handler.tar.gz
do
	doeldir="$basis"/spacefm-plugins/"${z/.tar.gz}"
	mkdir -p "$doeldir"
	tar -xf "$z" -C "$doeldir"
done
pushd "$basis"/spacefm-plugins
echo "# De hele verzameling">"$basis"/collectie.md
for d in *.spacefm-plugin *.spacefm-file-handler
do
	md="${d/.spacefm-*}.md"
	echo -e "# $d" > "$md"
	sed -nE 's/^(cstm|hand_f)_.*-label=(.*)/## \2\n    /p;s/^(cstm|hand_f)_.*-line=/    /p' "$d"/plugin | sed -E 's/\\n/\n    /g;s/\\t/\t/g' >> "$md"
	cat "$md">>"$basis"/collectie.md
	echo "">>"$basis"/collectie.md
done
popd
# verwijder export van alle plugins ouder dan dit script (maar collectie.nd blijft volledig)
find -maxdepth 1 \( -name "*.spacefm-plugin.tar.gz" -o -name "*.spacefm-file-handler.tar.gz" \) \! -newer "_naarGitHub.sh" -exec bash -v -c "cd $basis/spacefm-plugins;"'rm -R "${1/.spacefm-*}.md" "${1/.tar.gz}/"' _ \{\} \;
# markeer NU als nieuwe scheidslijn voor gewijzigde plugins
touch "$0"
