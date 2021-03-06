"""Setup file for rhasspywake_precise_hermes"""
from pathlib import Path

import setuptools

this_dir = Path(__file__).parent
with open(this_dir / "README.md") as readme_file:
    long_description = readme_file.read()

with open(this_dir / "requirements.txt") as requirements_file:
    requirements = requirements_file.read().splitlines()

with open(this_dir / "VERSION") as version_file:
    version = version_file.read().strip()

module_dir = this_dir / "rhasspywake_precise_hermes"
model_dir = module_dir / "models"
model_files = [str(f.relative_to(module_dir)) for f in model_dir.rglob("*")]

setuptools.setup(
    name="rhasspy-wake-precise-hermes",
    version=version,
    author="Michael Hansen",
    author_email="hansen.mike@gmail.com",
    url="https://github.com/rhasspy/rhasspy-wake-precise-hermes",
    packages=setuptools.find_packages(),
    package_data={"rhasspywake_precise_hermes": model_files + ["py.typed"]},
    install_requires=requirements,
    entry_points={
        "console_scripts": [
            "rhasspy-wake-precise-hermes = rhasspywake_precise_hermes.__main__:main"
        ]
    },
    classifiers=[
        "Programming Language :: Python :: 3",
        "Programming Language :: Python :: 3.7",
        "Programming Language :: Python :: 3.8",
        "License :: OSI Approved :: MIT License",
    ],
    long_description=long_description,
    long_description_content_type="text/markdown",
    python_requires=">=3.7",
)
