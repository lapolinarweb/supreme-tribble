# -*- coding: utf-8 -*-
#
# CodeQL and LGTM support info build configuration file, created 
# on Tuesday 19th February.
#
# This file is execfile()d with the current directory set to its
# containing dir.
#
# Note that not all possible configuration values are present in this
# autogenerated file.
#
# All configuration values have a default; values that are commented out
# serve to show the default.

# For details of all possible config values, 
# see https://www.sphinx-doc.org/en/master/usage/configuration.html

##############################################################################
#
# Modified 22052019. 

# The configuration values below are specific to the supported languages and frameworks project
# To amend html_theme_options, update version/release number, or add more sphinx extensions,
# refer to code/documentation/ql-documentation/global-sphinx-files/global-conf.py

##############################################################################

# -- Project-specific configuration -----------------------------------

import os

# Import global config values
with open(os.path.abspath("../global-sphinx-files/global-conf.py")) as in_file:
    exec(in_file.read())

# Set QL as the default language for highlighting code. Set to none to disable 
# syntax highlighting. If omitted or left blank, it defaults to Python 3. 
highlight_language ='none'

# The master toctree document.
master_doc = 'index'

# Project-specific information.
project = u'Supported languages and frameworks'

# The version info for this project, if different from version and release in main conf.py file.
# The short X.Y version.
# version = u'1.20'
# The full version, including alpha/beta/rc tags.
# release = u'1.20'

# -- Project-specifc options for HTML output ----------------------------------------------

# The name for this set of Sphinx documents.  If None, it defaults to
# "<project> v<release> documentation".
html_title = 'Supported languages and frameworks'

# Output file base name for HTML help builder.
htmlhelp_basename = 'Supported languages and frameworks'

# -- Currently unused, but potentially useful, configs--------------------------------------

# Add any paths that contain custom themes here, relative to this directory.
#html_theme_path = []

# A shorter title for the navigation bar.  Default is the same as html_title.
#html_short_title = None

# The name of an image file (relative to this directory) to place at the top
# of the sidebar.
#html_logo = None

# Custom sidebar templates, maps document names to template names.
#html_sidebars = {}

# Add any extra paths that contain custom files (such as robots.txt or
# .htaccess) here, relative to this directory. These files are copied
# directly to the root of the documentation.
#html_extra_path = []

# List of patterns, relative to source directory, that match files and
# directories to ignore when looking for source files.
exclude_patterns = ['read-me-project.rst', 'cobol-note.rst']