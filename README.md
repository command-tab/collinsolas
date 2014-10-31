## collinsolas

Collinsolas.sh: Fix Microsoft's broken Consolas font metrics.

Based in part on the hints in [Greg Hurrell's post](https://wincent.com/wiki/Fixing_the_baseline_on_the_Consolas_font_on_OS_X), this script edits the metrics for the Consolas font that ships with Microsoft Office to produce _Collinsolas_, a newly named version with improved baseline.

While this script could make the edits in-place, I chose to have it create a differently named font so I could leave the original intact. It's worth noting that a font's name does not come from its filename. There are special parts of the font file content that contain the name, so if you decide to change it, edit the script accordingly.

### Requirements

* A copy of the Consolas fonts
* [xmlstarlet](http://xmlstar.sourceforge.net/), installable via [Homebrew](http://brew.sh/) with `brew install xmlstarlet`
* [fonttools](http://sourceforge.net/projects/fonttools/)

### Running

1. Install the above requirements
1. Copy the following files to the same directory as this script:
    * `Consolas.ttf`
    * `Consolas Italic.ttf`
    * `Consolas Bold.ttf`
    * `Consolas Bold Italic.ttf`
1. Run `./collinsolas.sh`
1. Install the newly produced family of `Collinsolas` fonts
