
SHELL=/bin/bash
TEXFILE          := wrroc.tex
ALLDOCS          := $(TEXFILE)

Basename         := $(TEXFILE:.tex=)

drawio_svgs      := $(wildcard *.drawio.svg)
image_pdfs			 := $(drawio_svgs:.drawio.svg=.pdf)
epss             := $(image_pdfs:.pdf=.eps)

# List of all generated image files (resulting from conversions)
intermediate_images        := $(image_pdfs) $(epss)
final_images := Fig1.eps Fig2.eps Fig3.eps Fig4.eps Fig5.eps


LATEXMKOPTS:= -pdf


default: images
	latexmk $(LATEXMKOPTS) $(TEXFILE)

images: $(final_images)


force: images
	latexmk $(LATEXMKOPTS) -gg $(TEXFILE)

preview: images
	latexmk $(LATEXMKOPTS) -pvc $(TEXFILE)

all: images
	latexmk $(LATEXMKOPTS) $(ALLDOCS)

forceall: images
	latexmk $(LATEXMKOPTS) -gg $(ALLDOCS)


# Rules to convert images to PDF
%.pdf : %.drawio.svg
	drawio --export --crop --format pdf --output $@ $<

%.eps : %.pdf
	# pdftops is part of poppler
	pdftops -eps -origpagesizes $< $@


# Hack to get all the images renamed
Fig1.eps: figure-process-rc-uml.eps
	cp $< $@
Fig2.eps: figure-example.eps
	cp $< $@
Fig3.eps: figure-workflow-rc-uml.eps
	cp $< $@
Fig4.eps: figure-provenance-rc-uml.eps
	cp $< $@
Fig5.eps: figure-venn.eps
	cp $< $@

littleclean:
	latexmk $(LATEXMKOPTS) -c
	rm -f *.bbl *.gl* *.a* $(intermediate_images) *-eps-converted-to.pdf indent.log

distclean: littleclean
	latexmk $(LATEXMKOPTS) -C
	rm -f $(final_images)

#diff-draft.pdf: default ./original_submission/wrroc.tex
#	#latexdiff --encoding=utf8 ./original_submission/wrroc.tex wrroc.tex > wrroc-diff.tex
#	latexmk ${LATEXMKOPTS} wrroc-diff
#
#diff: diff-draft.pdf


push:
	git commit -av -m "text"; git push

pull:
	git pull --rebase

.PHONY: distclean littleclean push pull
