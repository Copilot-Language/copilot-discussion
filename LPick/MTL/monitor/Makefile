test:
	cabal exec -- ghc monitor.hs
	./monitor
	gcc monitor_test.c copilot-c99-codegen/copilot.c triggers.c -o monitor_test
	./monitor_test

compile:
	cabal exec -- ghc monitor.hs
	./monitor
