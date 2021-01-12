A ?= '33BF21'
U ?= 'BF0481'
G ?= '2166BF'
C ?= 'BF810D'

SIZE ?= 1024

A_DEC = $(shell ruby -e 'print "$A".scan(/../).map{|s|s.to_i(16)}.join(" ")')
U_DEC = $(shell ruby -e 'print "$U".scan(/../).map{|s|s.to_i(16)}.join(" ")')
G_DEC = $(shell ruby -e 'print "$G".scan(/../).map{|s|s.to_i(16)}.join(" ")')
C_DEC = $(shell ruby -e 'print "$C".scan(/../).map{|s|s.to_i(16)}.join(" ")')

png: rna.png

ppm: rna.ppm

.ppm.png:
	convert $< -filter point -resize $(SIZE)x $@

rna.ppm: rna-ascii.txt Makefile
	echo 'P3 64 68 255' > $@
	tr -d ' \n' < $< | sed \
		-e 's/A/$(A_DEC)\n/g' \
		-e 's/U/$(U_DEC)\n/g' \
		-e 's/G/$(G_DEC)\n/g' \
		-e 's/C/$(C_DEC)\n/g' >> $@
	echo '0 0 0 0 0 0 0 0 0 0 0 0' >> $@
	ruby -e 'puts "2021 created by hauleth - https://github.com/hauleth/biontech".rjust(192, "\0").each_byte.to_a.join(" ")' >> $@

clean:
	@rm -rf rna.ppm rna.png

.PHONY: png ppm clean
.SUFFIXES: .png .ppm
