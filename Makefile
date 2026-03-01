.PHONY: test

test:
	@cd /Users/pstachowski/Projects/TUYO/buffer_picker && nvim --headless -u ./tests/minimal_init.lua -c "lua dofile('tests/run.lua')" -c "qa!"
