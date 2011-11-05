#!/bin/sh
#!/bin/bash

set -x

should_preprocess_with_codegenerator=false
should_generate_doc=false

function failed()
{
    echo "Failed: $@" >&2
    exit 1
}

if $should_preprocess_with_codegenerator; then
	cd "${SOURCE_ROOT}/LibsITechArt/CodeGenerator"

	ruby -w "./cg_generate_objc.rb" --d "${SOURCE_ROOT}" || failed cg_generate_objc;
	ruby -w "./cg_generate_requests_customizer.rb" --d "${SOURCE_ROOT}" || failed cg_generate_requests_customizer;
fi

if $should_generate_doc; then	
	export DOXYGEN_PATH="/Applications/Doxygen.app/Contents/Resources/doxygen"	
	cd "${SOURCE_ROOT}"
	./BuildScripts/build_doc.sh
fi