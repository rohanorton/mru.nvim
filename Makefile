SHELL = /bin/sh

minimal_init := './scripts/minimal_init.vim'
run_test = nvim --headless --noplugin -u $(minimal_init) -c "PlenaryBustedFile $(1)"

test: # Runs all tests
	nvim --headless --noplugin -u $(minimal_init) -c "PlenaryBustedDirectory ./lua/tests/ { minimal_init = $(minimal_init), timeout = 3000 }"
.PHONY: test
