all: check coverage

.PHONY: \
    check \
    clean \
    coverage \
    format \
    init \
    install \
    setup \
    tests

check:
	R -e "library(styler)" \
      -e "resumen <- style_dir('R')" \
      -e "resumen <- rbind(resumen, style_dir('tests'))" \
      -e "resumen <- rbind(resumen, style_dir('tests/testthat'))" \
      -e "any(resumen[[2]])" \
      | grep FALSE

clean:
	rm --force *.tar.gz
	rm --force --recursive tests/testthat/_snaps
	rm --force NAMESPACE

coverage: setup tests
	Rscript tests/testthat/coverage.R

format:
	R -e "library(styler)" \
      -e "style_dir('R')" \
      -e "style_dir('tests')" \
      -e "style_dir('tests/testthat')"

init: setup init_github tests

init_github:
	git config --global --add safe.directory /workdir
	git config --global user.name "Ciencia de Datos • GECI"
	git config --global user.email "ciencia.datos@islas.org.mx"


setup: clean install

install:
	R -e "devtools::document()" && \
	R -e "devtools::check(error_on = 'error')" && \
	R -e "devtools::build()" && \
	R -e "devtools::install()"

tests:
	Rscript -e "devtools::test(stop_on_failure = TRUE)"

red: format
	Rscript -e "devtools::test(stop_on_failure = TRUE)" \
	&& git  restore tests/testthat/*.R \
	|| (git add tests/testthat/*.R && git commit -m "🛑🧪 Fail tests")
	chmod g+w -R .

green: format
	Rscript -e "devtools::test(stop_on_failure = TRUE)" \
	&& (git add R/*.R && git commit -m "✅ Pass tests") \
	|| git  restore R/*.R
	chmod g+w -R .

refactor: format
	Rscript -e "devtools::test(stop_on_failure = TRUE)" \
	&& (git add R/*.R tests/testthat/*.R && git commit -m "♻️ Refactor: ${message}") \
	|| git  restore R/*.R tests/testthat/*.R
	chmod g+w -R .
