"""
Setup script for gc-utils.
"""
from setuptools import setup, find_packages
import os

# Read the version from gc_utils/__init__.py
with open(os.path.join('gc_utils', '__init__.py'), 'r') as f:
    for line in f:
        if line.startswith('__version__'):
            version = line.strip().split('=')[1].strip(' \'"')
            break
    else:
        version = '0.1.0'  # Default if __version__ is not found

# Read long description from README.md
with open(os.path.join('..', 'README.md'), 'r') as f:
    long_description = f.read()

setup(
    name="gc-utils",
    version=version,
    author="GC-Utils Team",
    author_email="hytegeocaching@gmail.com",
    description="A collection of utilities for geocaching puzzle solving",
    long_description=long_description,
    long_description_content_type="text/markdown",
    url="https://github.com/spectraldecomp/gc-utils",
    packages=find_packages(),
    classifiers=[
        "Programming Language :: Python :: 3",
        "License :: OSI Approved :: MIT License",
        "Operating System :: OS Independent",
        "Development Status :: 3 - Alpha",
        "Intended Audience :: End Users/Desktop",
        "Topic :: Utilities",
    ],
    python_requires=">=3.6",
    entry_points={
        "console_scripts": [
            "gc-utils=gc_utils.cli.main:main",
        ],
    },
    install_requires=[
    ],
)
