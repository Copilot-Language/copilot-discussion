all: clean
	ghc --make -O0 rtr.hs
	./rtr > data.txt 2>&1
	../plotSolution.py data.txt

clean:
	rm -rf *.hi
	rm -rf *.o
	rm -rf rtr
	rm -rf data.txt
