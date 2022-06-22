SHELL := bash

all: public presentation.html

%.html: %.org *.css img/* ## Gera uma apresentação em HTML a partir do arquivo org.
	docker run --rm --tty \
		--volume "$(shell pwd):$(shell pwd):ro" \
		--volume "$(shell pwd)/public:$(shell pwd)/public" \
		--workdir="$(shell pwd)" \
		--entrypoint emacs \
		rjfonseca/emacs:latest \
			--no-window-system --no-splash --no-x-resources --no-desktop \
			--eval "(require 'org-re-reveal)" \
			--file $(*).org \
			--eval "(org-re-reveal-export-to-html)" \
			--kill

.PHONY: public
public:
	mkdir -p public
	chmod 777 public
	cp -R presentation.css img public/

clean:
	rm -rf public presentation.html

.PHONY: bash
bash: ## Sobe o container usado na compilação e entra no bash.
	docker run --rm -it \
		--volume "$(shell pwd):$(shell pwd)" \
		--workdir="$(shell pwd)" \
		--entrypoint bash \
		rjfonseca/emacs:latest

.PHONY: edit
edit: ## Abre o arquivo presentation.org para edição dentro do container.
	docker run --rm -it \
		--volume "$(shell pwd):$(shell pwd)" \
		--workdir="$(shell pwd)" \
		--entrypoint emacs \
		rjfonseca/emacs:latest \
		presentation.org
