#!/bin/sh
#!/bin/bash

set -x

should_preprocess_with_codegenerator=true

function failed()
{
    echo "Failed: $@" >&2
    exit 1
}

if $should_preprocess_with_codegenerator; then
	cd "${SOURCE_ROOT}/CodeGeneration"

	ruby -w "./cg_generate_objc.rb" --d "${SOURCE_ROOT}" || failed cg_generate_objc;
fi