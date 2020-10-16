import setuptools

with open("README.md", "r") as f:
    long_description = f.read()

setuptools.setup(
    name="baseMEOW",
    version="1.0.0",
    author="driazati",
    author_email="email@example.com",
    description="Encode and decode information as meows",
    long_description=long_description,
    long_description_content_type="text/markdown",
    url="https://github.com/driazati/baseMEOW",
    packages=setuptools.find_packages(),
    classifiers=[
        "Programming Language :: Python :: 3",
        "License :: OSI Approved :: MIT License",
        "Operating System :: OS Independent",
    ],
    entry_points={"console_scripts": ["baseMEOW = baseMEOW:main"]},
    python_requires=">=3.6",
)