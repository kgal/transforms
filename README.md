# Transforms 
[![Build Status](https://travis-ci.org/commoncriteria/transforms.svg?branch=master)](https://travis-ci.org/commoncriteria/transforms)
[![GitHub issues Open](https://img.shields.io/github/issues/commoncriteria/transforms.svg?maxAge=2592000)](https://github.com/commoncriteria/transforms/issues) 
![license](https://img.shields.io/badge/license-Unlicensed-blue.svg)

This poorly named _transforms_ project (should really be called 'commons' or something similiar as it is meant to be used as a submodule to other CC projects),
contains three basic file types (and one subproject) that are common resources to various protection profile projects.

These three types are:
* XSL Files, in the project's top directory, which transform the protection profile input file into
  various readable html documents,
* Schema Files (currently just schema.rng) in the _schemas_ directory, which defines, roughly, the structure of an input file, and
* Dictionary files, in the _dictionaries_ directory, which include various lists of words that are frequently used by protection
profiles but not recognized by _hunspell_, a spell checker we use.

It also contains a subproject, _rng-to-html_, in the _schemas_ directory and 
it is used by executing the shell script in the _bin_ directory. 
It uses _xsltproc_ to transform a RelaxNG schema (hopefully with annotations), to a clickable, javadoc-style reference.

## Links
[Help working with Transforms Submodule](https://github.com/commoncriteria/transforms/wiki/Working-with-Transforms-as-a-Submodule)

## License

See [License](./LICENSE)
