bin/macmount: src/macmount.m
	clang -Wall -Werror $< \
		-lobjc \
		-framework DiskArbitration \
		-framework Foundation \
		-o $@
