# -*- coding: utf-8 -*-
#
# QL training slides build configuration file
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
##################################################################################

# -- GLOBAL GENERAL CONFIG VALUES ------------------------------------------------

# The suffix(es) of source filenames.
# You can specify multiple suffix as a list of string:
# source_suffix = ['.rst', '.md']
source_suffix = '.rst'

# If your documentation needs a minimal Sphinx version, state it here.
# needs_sphinx = '1.7.9'
# Beware that some of the extensions don't work in version 1.8

# Add any Sphinx extension module names here, as strings. They can be
# extensions coming with Sphinx (named 'sphinx.ext.*') or your custom
# ones.
extensions = [
    'sphinx.ext.intersphinx',
    'sphinx.ext.mathjax',
    'hieroglyph',
    'sphinx.ext.graphviz',
]

# The encoding of source files.
#source_encoding = 'utf-8-sig'

# The name of the Pygments (syntax highlighting) style to use.
pygments_style = 'sphinx'

# Import the QL Lexer to use for syntax highlighting
import sys
import os

def setup(sphinx):
    sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)), os.path.pardir, 'global-sphinx-files')))
    from qllexer import QLLexer
    sphinx.add_lexer("ql", QLLexer())

# Set QL as the default language for highlighting code. Set to none to disable 
# syntax highlighting. If omitted or left blank, it defaults to Python 3. 
highlight_language = 'ql'

# The master toctree document.
master_doc = 'index'

# General information about the project.
project = u'QL training and variant analysis examples'

# Add any paths that contain custom static files (such as style sheets) here,
# relative to this directory. They are copied after the builtin static files,
# so a file named "default.css" will overwrite the builtin "default.css".
html_static_path = ['_static-training']


# Add any paths that contain templates here, relative to this directory.
#templates_path = ['../rst-styles/_templates-training']
#slide_theme_options = {'custom_css':'custom.css'}
slide_theme = 'slides-semmle-2'
slide_theme_path = ["_static-training/"]

# -- Project-specifc options for HTML output ----------------------------------------------

# The name for this set of Sphinx documents.  If None, it defaults to
# "<project> v<release> documentation".
html_title = 'QL training and variant analysis examples'

# Output file base name for HTML help builder.
htmlhelp_basename = 'QL training'
# The Semmle version info for the current release you're documenting, acts as replacement for
# |version| and |release|, also used in various other places throughout the
# built documents.
#
# The short X.Y version.
version = u'1.21'
# The full version, including alpha/beta/rc tags.
release = u'1.21'
copyright = u'2019 Semmle Ltd'
author = u'Semmle Ltd'

# The language for content autogenerated by Sphinx. Refer to documentation
# for a list of supported languages.
language = None

# If true, `todo` and `todoList` produce output, else they produce nothing.
todo_include_todos = False

# If true, links to the reST sources are added to the pages.
html_show_sourcelink = False

# If true, "Created using Sphinx" is shown in the HTML footer. Default is True.
html_show_sphinx = False


# Theme options are theme-specific and customize the look and feel of a theme
# further.  For a list of options available for each theme, see the
# documentation.
html_theme_options = {'font_size': '16px',
                      'body_text': '#333', 
                      'link': '#2F1695',
                      'link_hover': '#2F1695',
                      'font_family': 'Lato, sans-serif',
                      'head_font_family': 'Moderat, sans-serif',
                      'show_powered_by': False,
                      'nosidebar':True,
                      }

# Exclude the slide snippets from the build
exclude_patterns = ['slide-snippets']

##############################################################################