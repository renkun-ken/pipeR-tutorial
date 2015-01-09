@echo off
rscript -e "Rgitbook::buildGitbook()"
cd _book
git init
git commit --allow-empty -m "Update build gitbook"
git checkout -b gh-pages
git add .
git commit -am "Update build gitbook"
git push https://github.com/renkun-ken/pipeR-tutorial.git gh-pages --force
