## Generating UCB Mappers, Mapper Manifest, Templates, and Test files


### Preparing to generate mappers
Before generating mappers, etc. you'll need to copy the latest and greatest version of the "application config files"
along with an appropriate version of the core config file
into the gitignored data/configs directory.

`cp spec/fixtures/files/ucb/*.json data/configs`
`cp spec/fixtures/files/7_0/core*.json data/configs`

### Creating the mappers
This will create mappers for each profile in a separate subdirectory of `data/mappers/ucb/release_#_#`:

Note that releases are labeled as such: 
`6.0 -> release_6_0`


`exe/ccu mappers write -p all -o data/mappers/ucb/release_# -s y`

For details on the options:

`ccu mappers help write`


### Validating the newly created mappers
See the description under `ccu mappers help validate` for what this checks.

The following will recursively validate (in all the subdirectories) all the mappers created in the previous step.


`exe/ccu mappers validate -i data/mappers/ucb/release_#_#`


### Creating the manifest

The following will create a manifest listing all valid **UCB** mappers created above:

`exe/ccu mappers manifest -i ucb/release_#_# -o data/mapper_manifests/ucb_profile_mappers_release_#_#.json`


### Committing the new stuff to github so that csv-importer can access them

Once you have updated mappers, manifests, templates, and/or test files, you'll want to commit them
to github so that others (and esp. the csv-importer) can access them:

```
git add ...
git commit -m "CSW-xxx: ...
git push -v
```
Etc...

### Creating templates and test files

If your profiles or record types change you'll need to verify that the new schema can be imported into with this tool.
Here is an approach to making test files from templates. 
* First, generate all the templates
* Then, a small script reads the templates and output a 2-line .csv test file: it has all the fields in the template, and some guesses about what sort of data to put in the fields. It's a start!

Here's how to make it all go, using UCB profiles and mappers:

```
# clean out the templates directory, if needed
git clean -f data/templates/
# create templates templates
exe/ccu templates write -p all -o data/templates/release_6_0/ucb/
# make test files from the templates (in data/tests)
python3 bin/make_tests_from_templates.py ~/cspace-config-untangler/data/templates/release_6_0/ucb  ~/cspace-config-untangler/data/tests 
# admire your handiwork
less data/tests/cinefiles_1-0-14_objectexit-test.csv
```

TBD: commit the tests to github? encourage edits of these generated test files to test various conditions? allow / encourage other test files to be kept here? 

### Running tests (i.e. importing a bunch of test files for different (ucb) profile and record types to ensure things are working)

See the UCB qa-automation repo for a Cucumber/Capybara suite that does this.
